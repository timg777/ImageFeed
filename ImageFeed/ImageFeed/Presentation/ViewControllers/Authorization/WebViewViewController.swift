import UIKit
import WebKit
import ProgressHUD

final class WebViewViewController: UIViewController {
    
    // MARK: - Private Properties
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - Private Constants
    private let oauth2Service = OAuth2Service.shared
    
    // MARK: - Private Views
    private let webView = WKWebView()
    private let progressView = UIProgressView()
    private let backButton = UIButton()
    
    // MARK: - Internal Properties
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [.new]
        ) { [weak self] _, _ in
            self?.updateProgress()
        }

        setUpView()
        loadAuthView()
    }
}

// MARK: - Extensions + Private UI Updates
private extension WebViewViewController {
    func loadAuthView() {
        guard let request = oauth2Service.getUserAuthRequest() else {
            logErrorToSTDIO(
                errorDescription: "Failed to create URLRequest by OAouth2Service.getUserAuthRequest"
            )
            return
        }
        webView.load(request)
    }
    
    func updateProgress() {
        progressView.setProgress(
            Float(webView.estimatedProgress),
            animated: true
        )
        
        if webView.estimatedProgress >= 1.0 {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.progressView.alpha = 0
            }
        } else {
            progressView.alpha = 1
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
        progressView.resetProgress()
        if let code = code(from: navigationAction) {
            decisionHandler(.cancel)
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            delegate?.webViewViewControllerDidCancel(self)
        } else {
            decisionHandler(.allow)
        }
    }
}

// MARK: - Extensions + Private Button Actions
private extension WebViewViewController {
    @objc func didTapBackButton() {
        dismiss(animated: true)
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

// MARK: - Extensions + Private Setiing Up Views
private extension WebViewViewController {
    func setUpView() {
        setUpWebView()
        setUpBackButton()
        setUpProgressView()
    }
    
    func setUpBackButton() {
        backButton.setTitle(
            "",
            for: .normal
        )
        backButton.setImage(
            .navBackButton,
            for: .normal
        )
        backButton.tintColor = .ypBlack
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(
            self,
            action: #selector(didTapBackButton),
            for: .touchUpInside
        )
        
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            backButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: -2
            ),
            backButton.heightAnchor.constraint(
                equalToConstant: 44
            ),
            backButton.widthAnchor.constraint(
                equalTo: backButton.heightAnchor
            ) // 1:1
        ])
    }
    
    func setUpWebView() {
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(
                equalTo: view.topAnchor
            ),
            webView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
            webView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            webView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            webView.heightAnchor.constraint(
                equalToConstant: view.bounds.height
            ),
            webView.widthAnchor.constraint(
                equalToConstant: view.bounds.width
            )
        ])
    }
    
    func setUpProgressView() {
        progressView.resetProgress()
        progressView.trackTintColor = .ypGray
        progressView.progressTintColor = .ypBlack.withAlphaComponent(0.6)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            progressView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            progressView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            progressView.widthAnchor.constraint(
                equalToConstant: view.bounds.width
            ),
            progressView.heightAnchor.constraint(
                equalToConstant: 3
            )
        ])
    }
}
