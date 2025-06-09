import UIKit
import WebKit
import ProgressHUD

final class WebViewViewController: UIViewController & WebViewControllerProtocol {
    
    // MARK: - Private Properties
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - Private Views
    private lazy var webView: WKWebView = {
        .init()
    }()
    private lazy var progressView: UIProgressView = {
        .init()
    }()
    private lazy var backButton: UIButton = {
        .init()
    }()
    
    // MARK: - Internal Properties
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [.new]
        ) { [weak self] _, progress in
            guard let progress = progress.newValue else {
                logErrorToSTDIO(
                    errorDescription: "No progress value"
                )
                return
            }
            let floatProgress = Float(progress)
            self?.presenter?.didUpdateProgressValue(floatProgress)
        }
        
        webView.navigationDelegate = self
        setUpView()
    }
    
    deinit {
        estimatedProgressObservation = nil
    }
}

// MARK: - Extensions + Internal WebViewViewController UI Updates
extension WebViewViewController {
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    func setProgressValue(_ progress: Float) {
        progressView.setProgress(
            progress,
            animated: true
        )
    }
    
    func setProgressHidden(_ hidden: Bool) {
        progressView.isHidden = hidden
    }
}

// MARK: - Extensions + Internal WebViewViewController -> WKNavigationDelegate Conformace
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void
    ) {
        progressView.resetProgress()
        if let code = presenter?.code(from: navigationAction) {
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
        webView.accessibilityIdentifier = AccessibilityElement.unsplashWebView.rawValue
        
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
