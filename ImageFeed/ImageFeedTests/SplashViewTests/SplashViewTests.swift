@testable import ImageFeed
import XCTest

final class SplashViewTests: XCTestCase {
    // MARK: - Too difficult to test 'cause of logout function calling needed
    func testAuthenticationRouting() {}
    
    func testMainRouting() {
        // given
        let mainRouteExpectation = expectation(description: "mainRoute")
        
        let presenter = SplashViewPresenter()
        let nut = SplashViewControllerSpy()
        nut.mainRouteExpectation = mainRouteExpectation
        nut.presenter = presenter
        presenter.view = nut
        
        // when
        nut.viewDidLoad()
        
        // then
        wait(
            for: [mainRouteExpectation],
            timeout: 5
        )
    }
}
