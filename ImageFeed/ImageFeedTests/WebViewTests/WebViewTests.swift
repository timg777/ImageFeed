@testable import ImageFeed
import WebKit
import XCTest

final class WebViewTests: XCTestCase {
    
    private let spyViewController = WebViewViewControllerSpy()
    private let viewController = WebViewViewController()
    private let authHelper = AuthHelper(configuration: .test)
    private lazy var presenter = WebViewPresenter(authHelper: authHelper)
    private lazy var spyPresenter = WebViewPresenterSpy(authHelper: authHelper)
    
    func testViewControllerCallsViewDidLoad() throws {
        //given
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        let _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidiLoadCalled)
        
        viewController.presenter = nil
    }
    
    func testPresenterCallsLoadRequest() throws {
        //given
        let viewController = WebViewViewControllerSpy()
        let presenter = WebViewPresenterSpy(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.loadReqestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() throws {
        //given
        checkProgressVisibility(
            byValue: 0.6,
            expectedShouldHideProgress: false
        )
    }
    
    func testProgressVisibleWhenGreaterThenOne() throws {
        //given
        checkProgressVisibility(
            byValue: 1,
            expectedShouldHideProgress: true
        )
    }
    
    func testProgressValue() throws {
        //given
        spyViewController.presenter = presenter
        presenter.view = spyViewController
        let variation: [Float] = [0.2, 0.7, 0.3, 0.8, 0.9, 0.5]
        //when
        variation.forEach {

            //then
            checkProgressValue($0)
        }
        
        spyViewController.presenter = nil
        presenter.view = nil
    }
    
    func testAuthHelperAuthURL() throws {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //when
        let url = authHelper.authRequest()?.url

        guard let urlString = url?.absoluteString else {
            XCTFail("Auth URL is nil")
            return
        }

        //then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() throws {
        //given
        let givenCode = "test code"
        
        //when
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        urlComponents?.queryItems = [
            .init(name: "code", value: givenCode)
        ]
        
        guard let url = urlComponents?.url else {
            XCTFail("URL is nil")
            return
        }
        let receivedCode = authHelper.code(from: url)
        
        //then
        XCTAssertEqual(receivedCode, givenCode)
    }
}

// MARK: - Extensions + Private WebViewTests Helpers
private extension WebViewTests {
    func checkProgressVisibility(
        byValue progress: Float,
        expectedShouldHideProgress: Bool
    ) {
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertEqual(shouldHideProgress, expectedShouldHideProgress)
    }
    
    func checkProgressValue(
        _ progress: Float
    ) {
        //when
        presenter.didUpdateProgressValue(progress)
        let currentProgressValue = spyViewController.progressValue
        
        //then
        XCTAssertEqual(currentProgressValue, progress)
    }
}
