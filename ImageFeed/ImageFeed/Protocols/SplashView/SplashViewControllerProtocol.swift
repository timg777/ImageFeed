import UIKit

protocol SplashViewControllerProtocol: AnyObject {
    var presenter: SplashViewPresenterProtocol? { get set }
    func routeToMain()
    func routeToAuthentication()
    func present(
        _ viewControllerToPresent: UIViewController,
        animated: Bool,
        completion: (() -> Void)?
    )
}
