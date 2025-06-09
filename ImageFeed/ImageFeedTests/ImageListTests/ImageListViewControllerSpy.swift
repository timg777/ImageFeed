@testable import ImageFeed
import XCTest

final class ImageListViewControllerSpy: ImageListViewControllerProtocol {
    // MARK: - Internal Properties
    var presenter: ImageListPresenterProtocol?
    var lockUIExpectation: XCTestExpectation?
    var unlockUIExpectation: XCTestExpectation?
    var tableViewUpdateExpectation: XCTestExpectation?
    private(set) var isUILocked = false
    
    // MARK: - View Life Cycles
    func viewDidLoad() {
        presenter?.viewDidLoad()
    }
}

// MARK: - Extensions + Internal ImageListViewControllerSpy -> ImageListViewControllerProtocol Conformance
extension ImageListViewControllerSpy {
    func unlockUI() {
        isUILocked = false
        unlockUIExpectation?.fulfill()
    }
    
    func lockUI() {
        isUILocked = true
        lockUIExpectation?.fulfill()
    }
    
    func updateTableViewIfNeeded(photoCountsAtDifferentTime: (Int, Int)) {
        tableViewUpdateExpectation?.fulfill()
    }
    
    func present(
        _ viewControllerToPresent: UIViewController,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        // do nothing
    }
}
