import XCTest
import WebKit
import ProgressHUD

final class ImageFeedUITests: XCTestCase {
    
    /// ImageFeed Enum Copy
    enum AccessibilityElement: String {
        case alertOKButton
        case loginButton
        case unsplashWebView
        case logoutButton
        case cellLikeButton
        case singleImage
        case singleImageBackButton
        case tableViewId
    }

    private let login: String = "_"
    private let password: String = "_"
    
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }

    @MainActor
    func testAuth() throws {
        let loginButton = app.buttons[AccessibilityElement.loginButton.rawValue]
        XCTAssertTrue(
            loginButton
                .exists
        )
        loginButton.tap()
        
        let webView = app.webViews[AccessibilityElement.unsplashWebView.rawValue]
        XCTAssertTrue(
            webView
                .waitForExistence(timeout: 2)
        )
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(
            loginTextField
                .waitForExistence(timeout: 5)
        )
        
        loginTextField.tap()
        loginTextField.typeText(login)
        loginTextField.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(
            passwordTextField.exists
        )
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        passwordTextField.swipeUp()
        
        let webViewLoginButton = webView.buttons["Login"]
        XCTAssertTrue(
            webViewLoginButton
                .exists
        )
        webViewLoginButton.tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery
            .children(matching: .cell)
            .element(boundBy: 0)
        
        XCTAssertTrue(
            cell
                .waitForExistence(timeout: 5)
        )
    }
    
    @MainActor
    func testFeed() throws {
        let tablesQueryBeforeRoutingToSingleImage = app.tables
        XCTAssertTrue(
            tablesQueryBeforeRoutingToSingleImage
                .element
                .waitForExistence(timeout: 2)
        )
        
        let firstCellBeforeSwipe =
        tablesQueryBeforeRoutingToSingleImage
            .children(matching: .cell)
            .element(boundBy: 0)
        XCTAssertTrue(
            firstCellBeforeSwipe
                .exists
        )
        
        tablesQueryBeforeRoutingToSingleImage
            .element
            .swipeUp(velocity: 350)
        
        sleep(3)
        
        let cellToLike =
        tablesQueryBeforeRoutingToSingleImage
            .children(matching: .cell)
            .element(boundBy: 1)
        XCTAssertTrue(
            cellToLike
                .waitForExistence(timeout: 2)
        )
        
        let likeButton = cellToLike.buttons["Like off"]
        XCTAssertTrue(
            likeButton
                .waitForExistence(timeout: 3)
        )
        XCTAssertTrue(
            likeButton.wait(
                for: \.isHittable,
                toEqual: true,
                timeout: 10
            )
        )
        
        likeButton.tap()
        sleep(2)
        
        let unlikeButton = cellToLike.buttons["Like on"]
        XCTAssertTrue(
            unlikeButton
                .waitForExistence(timeout: 3)
        )
        XCTAssertTrue(
            unlikeButton.wait(
                for: \.isHittable,
                toEqual: true,
                timeout: 5
            )
        )
        
        unlikeButton.tap()
        sleep(2)
        
        XCTAssertTrue(
            cellToLike.exists && cellToLike.isHittable
        )
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images[AccessibilityElement.singleImage.rawValue]
        XCTAssertTrue(
            image.exists
        )
        
        image.pinch(
            withScale: 3,
            velocity: 1
        )
        image.pinch(
            withScale: 0.3,
            velocity: -1
        )
        
        let singleImageBackButton = app.buttons[AccessibilityElement.singleImageBackButton.rawValue]
        singleImageBackButton.tap()
        
        let tablesQueryAfterRoutingToSingleImage = app.tables
        let secondCellAfterRoutingToSingleImage =
        tablesQueryAfterRoutingToSingleImage
            .children(matching: .cell)
            .element(boundBy: 1)
        XCTAssertTrue(
            secondCellAfterRoutingToSingleImage
                .waitForExistence(timeout: 2)
        )
    }
    
    @MainActor
    func testProfile() throws {
        let profileTabBarItem = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(
            profileTabBarItem
                .waitForExistence(timeout: 2)
        )
        profileTabBarItem.tap()
        
        let nameLabel = app.staticTexts["Tim Emptiness"]
        let aboutLabel = app.staticTexts["Some information about Tim"]
        let instaTagLabel = app.staticTexts["@urweakness"]
        XCTAssertTrue(
            nameLabel
                .waitForExistence(timeout: 2)
        )
        XCTAssertTrue(
            aboutLabel
                .exists
        )
        XCTAssertTrue(
            instaTagLabel
                .exists
        )
        
        let logoutButton = app.buttons[AccessibilityElement.logoutButton.rawValue]
        XCTAssertTrue(
            logoutButton
                .waitForExistence(timeout: 2)
        )
        logoutButton.tap()
        
        let alertBodyLabel = app.staticTexts["Уверены, что хотите выйти?"]
        XCTAssertTrue(
            alertBodyLabel
                .waitForExistence(timeout: 2)
        )
        
        let alertButtons = app.alerts["Пока, пока!"].buttons
        let alertOKButton = alertButtons[AccessibilityElement.alertOKButton.rawValue]
        XCTAssertTrue(
            alertOKButton
                .exists
        )
        alertOKButton.tap()
        
        let loginButton = app.buttons[AccessibilityElement.loginButton.rawValue]
        XCTAssertTrue(
            loginButton
                .waitForExistence(timeout: 2)
        )
    }
}
