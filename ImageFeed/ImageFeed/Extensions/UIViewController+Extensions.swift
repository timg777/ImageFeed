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
    
    func popToRootViewController(completion: (() -> Void)? = nil) {
        navigationController?.popToRootViewController(animated: true)
        completion?()
    }
}
