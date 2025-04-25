import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Private Constants
    private let storage = OAuth2TokenStorage.shared
    
    // MARK: - IB Outlets
    @IBOutlet private weak var loginButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLoginButton()
    }
}

// MARK: - Extensions + Internal Segue Preparing
extension AuthViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GlobalNamespace.showWebViewSegueIdentifier {
            guard
                let vc = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(GlobalNamespace.showWebViewSegueIdentifier)")
                return
            }
            vc.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - Exetnsions + Internal WebViewViewControllerDelegate Conformance
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let token):
                storage.token = token
                delegate?.didAuthenticate(self)
            case .failure(let error):
                delegate?.didFailAuthentication(with: error)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

// MARK: - Extensions + Private Setting Up Views
private extension AuthViewController {
    func configureLoginButton() {
        loginButton.layer.cornerRadius = 16
    }
}
