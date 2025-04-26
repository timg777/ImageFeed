import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Private Constants
    private let storage = OAuth2TokenStorage.shared
    
    // MARK: - View Life Cycles
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if storage.token != nil {
            routeToMain()
        } else {
            routeToAuthentication()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
}

// MARK: - Extensions + Internal Appearance Control
extension SplashViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GlobalNamespace.authenticationSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(GlobalNamespace.authenticationSegueIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - Extensions + Internal AuthViewControllerDelegate Conformance
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        dismiss(animated: true) { [weak self] in
            self?.routeToMain()
        }
    }
    
    func didFailAuthentication(with error: any Error) {
        routeToAuthentication()
        // TODO: - error handling here...
    }
}

// MARK: - Extensions + Private Routing
private extension SplashViewController {
    func routeToAuthentication() {
        performSegue(withIdentifier: GlobalNamespace.authenticationSegueIdentifier, sender: nil)
    }
    
    func routeToMain() {
        route(to: GlobalNamespace.tabBarControllerIdentifier)
    }
}
