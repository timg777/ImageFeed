import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Private Properties
    private var alertPresenter: AlertPresenterProtocol?
    
    // MARK: - Private Views
    private lazy var loginButton: UIButton = {
        .init()
    }()
    private lazy var logoImageView: UIImageView = {
        .init()
    }()
    
    // MARK: - Properties
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        alertPresenter = AlertPresenter()
    }
}

// MARK: - Extensions + Internal AuthViewController -> WebViewViewControllerDelegate Conformance
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        DispatchQueue.main.async {
            UIBlockingActivityIndicator.showActivityIndicator()
        }
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            DispatchQueue.main.async {
                UIBlockingActivityIndicator.dismissActivityIndicator()
            }
            guard let self else { return }
            switch result {
            case .success(let token):
                delegate?.didAuthenticate(self, with: token)
                dismiss(animated: true)
            case .failure(let error):
                delegate?.didFailAuthentication(with: error)
                showAlert()
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

// MARK: - Extensions + Private AuthViewController Button Handlers
private extension AuthViewController {
    @objc func didTapLoginButton() {
        let authHelper = AuthHelper()
        let webViewPresenter = WebViewPresenter(authHelper: authHelper)
        let webViewViewController = WebViewViewController()
        webViewPresenter.view = webViewViewController
        webViewViewController.presenter = webViewPresenter
        webViewViewController.delegate = self
        
        webViewViewController.modalPresentationStyle = .fullScreen
        present(
            webViewViewController,
            animated: true
        )
    }
}

// MARK: - Extensions + Private AuthViewController Helpers
private extension AuthViewController {
    func showAlert() {
        alertPresenter?.present(
            present: present,
            action: { [weak self] in
            self?.alertPresenter = nil
        })
    }
}

// MARK: - Extensions + Private AuthViewController Setting Up View
private extension AuthViewController {
    func setUpViews() {
        view.backgroundColor = .ypBlack
        
        setUpLoginButton()
        setUpLogoImage()
    }
    
    func setUpLoginButton() {
        loginButton.backgroundColor = .ypWhite
        loginButton.setAttributedTitle(
            .init(
                string: "Войти",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 17, weight: .bold),
                    .foregroundColor: UIColor.ypBlack
                ]
            ),
            for: .normal)
        loginButton.layer.cornerRadius = 16
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.accessibilityIdentifier = AccessibilityElement.loginButton.rawValue
        loginButton.addTarget(
            self,
            action: #selector(didTapLoginButton),
            for: .touchUpInside
        )
        
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.widthAnchor.constraint(
                equalToConstant: view.frame.width
            ),
            loginButton.heightAnchor.constraint(
                equalToConstant: 48
            ),
            loginButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            loginButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            loginButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -124
            )
        ])
    }
    
    func setUpLogoImage() {
        logoImageView.image = UIImage(resource: .logoOfUnsplash)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor
            ),
            logoImageView.bottomAnchor.constraint(
                equalTo: loginButton.bottomAnchor,
                constant: -350
            ),
            logoImageView.heightAnchor.constraint(
                equalToConstant: 60
            ),
            logoImageView.widthAnchor.constraint(
                equalTo: logoImageView.heightAnchor
            ) // 1:1
        ])
    }
}
