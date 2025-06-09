import Foundation
import WebKit
import Kingfisher

final class SplashViewPresenter: SplashViewPresenterProtocol {
    
    // MARK: - Private Constants
    private var storage: StorageProtocol = Storage.shared
    private let secureStorage: SecureStorageProtocol = SecureStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared
    
    // MARK: - Internal Properties
    weak var view: SplashViewControllerProtocol?
    
    // MARK: - Private Properties
    private var alertPresenter: AlertPresenterProtocol?
    
    private lazy var observerObject: Observer? = {
        try? .init(
            self,
            from: [
                UserProfileViewController.self
            ],
            for: [
                .logoutNotification
            ]
        )
    }()
    
    // MARK: - Presenter Life Cycles
    func viewDidLoad() {
        addObserverObject()
        alertPresenter = AlertPresenter()
    }
    
    func viewDidAppear() {
        if storage.isNotFirstLaunch {
            if let token = secureStorage.getToken() {
                fetchUserProfile(by: token) { [weak self] username in
                    self?.fetchUserProfilePhoto(by: token, username: username)
                }
                DispatchQueue.main.async { [weak self] in
                    self?.view?.routeToMain()
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.view?.routeToAuthentication()
                }
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.storage.isNotFirstLaunch = true
                self?.view?.routeToAuthentication()
            }
        }
    }
    
    deinit {
        NotificationCenterManager.shared.removeObserver(observerObject)
    }
}

// MARK: - Extensions + Private SplashViewController Methods
private extension SplashViewPresenter {
    func addObserverObject() {
        if let observerObject {
            NotificationCenterManager.shared.addObserver(observerObject)
        } else {
            logErrorToSTDIO(
                errorDescription: "Failed to create observer object for notifications"
            )
        }
    }
    
    func logout() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(
            ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()
        ) { records in
            records.forEach {
                WKWebsiteDataStore.default().removeData(
                    ofTypes: $0.dataTypes,
                    for: [$0],
                    completionHandler: {}
                )
            }
        }
        
        URLCache.shared.removeAllCachedResponses()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier ?? "")
        UserDefaults.standard.synchronize()
        ImageCache.default.clearMemoryCache()
        secureStorage.removeToken()
        
        NotificationCenterManager.shared.removeAllObservers()
        NotificationCenterManager.shared.clearNotifications()
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.routeToAuthentication()
        }
    }
}

// MARK: - Extensions + Internal SplashViewPresenter -> SplashViewPresenterProtocol Conformance
extension SplashViewPresenter {
    func didAuthenticate(_ vc: AuthViewController, with token: String) {
        secureStorage.setToken(token)
    }
    
    func didFailAuthentication(with error: any Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.routeToAuthentication()
        }
        logErrorToSTDIO(
            errorDescription: (error as? TracedError)?.description ?? error.localizedDescription
        )
    }
    
    func fetchUserProfile(
        by token: String,
        completion: ((String) -> Void)? = nil
    ) {
        profileService.fetchProfile(
            httpMethod: .GET,
            token: token
        ) { [weak self, weak view] result in
            guard let self, let view else { return }
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    completion?(profile.username)
                }
            case .failure(let error):
                logErrorToSTDIO(
                    errorDescription: (error as? TracedError)?.description ?? error.localizedDescription
                )
                DispatchQueue.main.async {
                    self.alertPresenter?.present(present: view.present)
                }
            }
        }
    }
    
    func fetchUserProfilePhoto(
        by token: String,
        username: String,
        completion: (() -> Void)? = nil
    ) {
        profileImageService.fetchProfileImageURL(
            username: username,
            token: token
        ) { [weak self, weak view] result in
            guard let self, let view else { return }
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    completion?()
                }
            case .failure(let error):
                logErrorToSTDIO(
                    errorDescription: (error as? TracedError)?.description ?? error.localizedDescription
                )
                
                DispatchQueue.main.async {
                    self.alertPresenter?.present(present: view.present)
                }
            }
        }
    }
}

// MARK: - Extensions + Internal SplashViewPresenter NotificationObserver Conformance
extension SplashViewPresenter: NotificationObserver {
    func handleNotification(_ notification: Notification) {
        if notification.name == .logoutNotification {
            logout()
        }
    }
}
