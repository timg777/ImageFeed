import Foundation

final class UserProfilePresenter: UserProfilePresenterProtocol {
    
    // MARK: - Internal Properties
    weak var view: UserProfileViewControllerProtocol?
    
    // MARK: - Private Properties
    private lazy var observerObject: Observer? = {
        try? Observer(
            self,
            for: [
                .profileImageServiceDidChangeNotification,
                .profileServiceProviderDidChangeNotification
            ]
        )
    }()
    
    // MARK: - Presenter Life Cycles
    func viewDidLoad() {
        addObserverObject()
    }
    
    deinit {
        NotificationCenterManager.shared.removeObserver(observerObject)
    }
}

// MARK: - Extensions + Private UserProfilePresenter Methods
private extension UserProfilePresenter {
    func addObserverObject() {
        if let observerObject {
            NotificationCenterManager.shared.addObserver(observerObject)
        } else {
            logErrorToSTDIO(
                errorDescription: "Failed to create observer object for notifications"
            )
        }
    }
}

// MARK: - Extensions + Internal UserProfilePresenter -> UserProfilePresenterProtocol Conformance
extension UserProfilePresenter {
    func didReceiveUserProfile(_ userProfile: Profile) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.setUserProfile(userProfile)
        }
    }
    
    func didReceiveProfilePhotoURL(url: URL) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.setProfileImage(using: url)
        }
    }
}

// MARK: - Extensions + Internal UserProfilePresenter -> NotificationObserver Conformance
extension UserProfilePresenter: NotificationObserver {
    func handleNotification(_ notification: Notification) {
        if notification.name == .profileImageServiceDidChangeNotification {
            
            guard
                let profileImageURLString = notification.userInfo?[UserInfoKey.profileImageURLString.rawValue] as? String,
                let profileImageURL = URL(string: profileImageURLString)
            else {
                logErrorToSTDIO(
                    errorDescription: "No profileImageURLString found in notification"
                )
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.didReceiveProfilePhotoURL(url: profileImageURL)
            }
            
        } else if notification.name == .profileServiceProviderDidChangeNotification {
            
            guard
                let profile = notification.userInfo?[UserInfoKey.userProfile.rawValue] as? Profile
            else {
                logErrorToSTDIO(
                    errorDescription: "No profile found in notification"
                )
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.didReceiveUserProfile(profile)
            }
            
        }
    }
}
