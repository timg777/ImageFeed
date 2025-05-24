import UIKit

extension UIViewController {
    func route(
        to vc: UIViewController,
        completion: (() -> Void)? = nil
    ) {
        navigationController?.pushViewController(vc, animated: true)
        completion?()
    }
    
    func popViewController(completion: (() -> Void)? = nil) {
        navigationController?.popViewController(animated: true)
        completion?()
    }
    
    func setRootViewController(
        vc viewController: UIViewController,
        completion: (() -> Void)? = nil
    ) {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true
        window.rootViewController = navigationController
        completion?()
    }
}
