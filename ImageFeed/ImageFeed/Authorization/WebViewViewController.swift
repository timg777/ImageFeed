import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var backButton: UIButton!
    
    // MARK: - Private Properties
    private let oauth2Service = OAuth2Service.shared
    
    // MARK: - Internal Properties
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        configureBackButton()
        loadAuthView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: [.new],
            context: nil
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        webView.removeObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            context: nil
        )
    }
}

// MARK: - Extensions + Private UI Updates
private extension WebViewViewController {
    func loadAuthView() {
        guard let request = oauth2Service.getUserAuthRequest() else { return }
        webView.load(request)
    }
    
    func updateProgress() {
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self else { return }
                progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
            }
        }
    }
}

// MARK: - Extensions + Internal WKWebView estimatedProgress value observation
extension WebViewViewController {
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(
                forKeyPath: keyPath,
                of: object,
                change: change,
                context: context
            )
        }
    }
}

// MARK: - Extensions + Internal WKNavigationDelegate Conformace
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            decisionHandler(.cancel)
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            delegate?.webViewViewControllerDidCancel(self)
        } else {
            decisionHandler(.allow)
        }
    }
}

// MARK: - Extensions + Private IB Actions
private extension WebViewViewController {
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - Extensions + Private Setiing Up Views
private extension WebViewViewController {
    func configureBackButton() {
        backButton.setTitle("", for: .normal)
        backButton.setImage(.navBackButton, for: .normal)
        backButton.tintColor = .ypBlack
    }
}

// MARK: - Extensions + Private Helpers
private extension WebViewViewController {
    func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            let queryItems = urlComponents.queryItems,
            let codeQueryItem = queryItems.first(where: { $0.name == "code" })
        {
            return codeQueryItem.value
        }
        return nil
    }
}
