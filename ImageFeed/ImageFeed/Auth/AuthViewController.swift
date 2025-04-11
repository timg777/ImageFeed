import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Private Constants
    private let showWebViewSegueIdentifier = "showWebViewSegueIdentifier"
    
    // MARK: - IB Outlets
    @IBOutlet private weak var loginButton: UIButton!
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLoginButton()
    }
}

// MARK: - Extensions + Internal Segue Preparing
extension AuthViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let vc = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
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
    #warning("TODO: process code here")

    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

// MARK: - Extensions + Private IB Actions
private extension AuthViewController {
    @IBAction func didTapLoginButton(_ sender: Any) {
        
    }
}


// MARK: - Extensions + Private Setting Up Views
private extension AuthViewController {
    func configureLoginButton() {
        loginButton.layer.cornerRadius = 16
    }
}
