import XCTest
@testable import ImageFeed

// MARK: - Attention! Do not run all ImageListTests by one scope. Run by one
// MARK: - This test uses real network requests
final class ImageListTests: XCTestCase {
    
    func testUIBlockingWhenLoading() {
        // given
        let lockUIExpectation = expectation(description: "lockUI")
        
        let presenter = ImageListPresenter()
        let nut = ImageListViewControllerSpy()
        nut.presenter = presenter
        presenter.view = nut
        nut.lockUIExpectation = lockUIExpectation
        
        // when
        nut.viewDidLoad()
        
        // then
        wait(
            for: [lockUIExpectation],
            timeout: 3
        )
        XCTAssertTrue(
            nut.isUILocked
        )
    }
    
    func testUIUnblockingAfterLoading() {
        // given
        let unlockUIExpectation = expectation(description: "unlockUI")
        
        let presenter = ImageListPresenter()
        let nut = ImageListViewControllerSpy()
        nut.presenter = presenter
        presenter.view = nut
        nut.unlockUIExpectation = unlockUIExpectation
        
        // when
        nut.viewDidLoad()
        
        // then
        wait(
            for: [unlockUIExpectation],
            timeout: 3
        )
        XCTAssertFalse(
            nut.isUILocked
        )
    }
    
    // MARK: - Tested using Charles Breakpoint replacing good response with error
    func testAlertPresentationWhenErrorOccurs() {}

    func testTableViewUpdateCalledAfterLoading() {
        // given
        let tableViewUpdateExpectation = expectation(description: "tableViewUpdate")
        
        let presenter = ImageListPresenter()
        let nut = ImageListViewControllerSpy()
        nut.presenter = presenter
        nut.tableViewUpdateExpectation = tableViewUpdateExpectation
        presenter.view = nut
        
        // when
        nut.viewDidLoad()
        
        // then
        wait(
            for: [tableViewUpdateExpectation],
            timeout: 5
        )
    }
    
}
