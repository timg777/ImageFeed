import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Private Constants
    private let storage: StorageProtocol = Storage.shared
    private let secureStorage: SecureStorageProtocol = SecureStorage.shared
    
    // MARK: - Private Properties
    private var alertPresenter: AlertPresenterProtocol?
    
    // MARK: - IB Outlets
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

// MARK: - Extensions + Internal WebViewViewControllerDelegate Conformance
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        UIBlockingActivityIndicator.showActivityIndicator()
        
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            UIBlockingActivityIndicator.dismissActivityIndicator()
            guard let self else { return }
            switch result {
            case .success(let token):
                handleSecureStorageTokenUpdate(token)
                delegate?.didAuthenticate(self)
            case .failure(let error):
                delegate?.didFailAuthentication(with: error)
                showAlert()
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

// MARK: - Extensions + Private Button Handlers
private extension AuthViewController {
    @objc func didTapLoginButton() {
        let webViewViewController = WebViewViewController()
        webViewViewController.delegate = self
        webViewViewController.modalPresentationStyle = .fullScreen
        present(
            webViewViewController,
            animated: true
        )
    }
}

// MARK: - Extensions + Private Helpers
private extension AuthViewController {
    func showAlert() {
        alertPresenter?.present(
            kind: .authError,
            present: present,
            nil
        )
    }
    
    func handleSecureStorageTokenUpdate(_ token: String) {
        secureStorage.setToken(token)
    }
}

// MARK: - Extensions + Private Setting Up View
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
        logoImageView.image = UIImage(named: "Logo_of_Unsplash")
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
