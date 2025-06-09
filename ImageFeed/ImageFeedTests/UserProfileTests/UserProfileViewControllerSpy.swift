@testable import ImageFeed
import XCTest

final class UserProfileViewControllerSpy: UserProfileViewControllerProtocol {
    // MARK: - Internal Constants
    let expectation: XCTestExpectation
    let isProfileCheck: Bool
    let expectedProfile: Profile?
    let expectedProfileImageURLString: String?
    
    // MARK: - Internal Properties
    var presenter: UserProfilePresenterProtocol?
    var profile: Profile?
    var profileImageURL: URL?
    
    // MARK: - Initialization
    init(
        expectation: XCTestExpectation,
        isProfileCheck: Bool,
        expectedProfile: Profile? = nil,
        expectedProfileImageURLString: String? = nil
    ) {
        self.expectation = expectation
        self.isProfileCheck = isProfileCheck
        self.expectedProfile = expectedProfile
        self.expectedProfileImageURLString = expectedProfileImageURLString
    }
}

// MARK: - Extensions + Internal UserProfileViewControllerSpy -> UserProfileViewControllerProtocol Conformance
extension UserProfileViewControllerSpy {
    func setUserProfile(_ profile: Profile) {
        if isProfileCheck &&
            profile.bio == expectedProfile?.bio &&
            profile.loginName == expectedProfile?.bio &&
            profile.name == expectedProfile?.name &&
            profile.username == expectedProfile?.username
        {
            self.profile = profile
            expectation.fulfill()
        }
    }
    
    func setProfileImage(using url: URL) {
        if !isProfileCheck && url.absoluteString == expectedProfileImageURLString {
            profileImageURL = url
            expectation.fulfill()
        }
    }
}
