import Foundation

protocol UserProfilePresenterProtocol: AnyObject {
    var view: UserProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didReceiveUserProfile(_ userProfile: Profile)
    func didReceiveProfilePhotoURL(url: URL)
}
