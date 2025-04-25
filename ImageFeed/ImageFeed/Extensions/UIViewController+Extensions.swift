import UIKit

extension UIViewController {
    func route(to vcID: String, completion: (() -> Void)? = nil) {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: vcID)
        window.rootViewController = viewController
        completion?()
    }
}
