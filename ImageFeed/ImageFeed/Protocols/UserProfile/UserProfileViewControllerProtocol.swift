import Foundation

protocol UserProfileViewControllerProtocol: AnyObject {
    var presenter: UserProfilePresenterProtocol? { get set }
    func setUserProfile(_ profile: Profile)
    func setProfileImage(using url: URL)
}
