@testable import ImageFeed
import XCTest

final class UserProfileTests: XCTestCase {
    
    private let presenter = UserProfilePresenter()
    
    func testPresenterProfileReceivedNotified() {
        // given
        let notificationExpectation = self.expectation(description: "Wait for notification")
        let expectedProfile = Profile(
            username: "test",
            name: "test",
            loginName: "test",
            bio: "test"
        )
        let viewController = UserProfileViewControllerSpy(
            expectation: notificationExpectation,
            isProfileCheck: true,
            expectedProfile: expectedProfile
        )
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        NotificationCenter.default
            .post(
                name: .profileServiceProviderDidChangeNotification,
                object: ProfileService.self,
                userInfo:
                    [
                        UserInfoKey.userProfile.rawValue : expectedProfile
                    ]
            )
        wait(
            for: [notificationExpectation],
            timeout: 5
        )
        
        //then
        XCTAssertNotNil(
            viewController.profile
        )
        XCTAssertEqual(
            viewController.profile?.bio,
            expectedProfile.bio
        )
        XCTAssertEqual(
            viewController.profile?.loginName,
            expectedProfile.loginName
        )
        XCTAssertEqual(
            viewController.profile?.name,
            expectedProfile.name
        )
        XCTAssertEqual(
            viewController.profile?.username,
            expectedProfile.username
        )
    }
    
    func testSPresenterProfileImageURLReceivedNotified() {
        // given
        guard
            let testImageURL = URL(string: "https://example.com/image.png")
        else {
            XCTFail(#function + ": Failed to create URL.");
            return
        }

        let notificationExpectation = expectation(description: "Wait for notification")
        let viewController = UserProfileViewControllerSpy(
            expectation: notificationExpectation,
            isProfileCheck: false,
            expectedProfileImageURLString: testImageURL.absoluteString
        )
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        NotificationCenter.default
            .post(
                name: .profileImageServiceDidChangeNotification,
                object: ProfileImageService.self,
                userInfo:
                    [
                        UserInfoKey.profileImageURLString.rawValue : testImageURL.absoluteString
                    ]
            )
        wait(
            for: [notificationExpectation],
            timeout: 5
        )
        
        //then
        XCTAssertNotNil(
            viewController.profileImageURL
        )
        XCTAssertEqual(
            viewController.profileImageURL,
            testImageURL
        )
    }
    
}
