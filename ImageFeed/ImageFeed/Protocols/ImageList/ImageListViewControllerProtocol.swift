import UIKit

protocol ImageListViewControllerProtocol: AnyObject {
    var presenter: ImageListPresenterProtocol? { get set }
    func unlockUI()
    func lockUI()
    func updateTableViewIfNeeded(photoCountsAtDifferentTime: (Int, Int))
    func present(
        _ viewControllerToPresent: UIViewController,
        animated: Bool,
        completion: (() -> Void)?
    )
}
