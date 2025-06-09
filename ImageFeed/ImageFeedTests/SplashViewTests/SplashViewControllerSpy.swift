@testable import ImageFeed
import XCTest

final class SplashViewControllerSpy: SplashViewControllerProtocol {
    // MARK: - Internal Properties
    var presenter: (any ImageFeed.SplashViewPresenterProtocol)?
    
    var isUILocked = false
    var mainRouteExpectation: XCTestExpectation?
    
    // MARK: - View Life Cycles
    func viewDidLoad() {
        presenter?.viewDidLoad()
        presenter?.viewDidAppear()
    }
}

// MARK: - Extensions + Interal SplashViewControllerSpy -> SplashViewControllerProtocol Conformance
extension SplashViewControllerSpy {
    func routeToMain() {
        mainRouteExpectation?.fulfill()
    }
    
    func routeToAuthentication() {
        // do nothing
    }
    
    func present(
        _ viewControllerToPresent: UIViewController,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        // do nothing
    }
}
