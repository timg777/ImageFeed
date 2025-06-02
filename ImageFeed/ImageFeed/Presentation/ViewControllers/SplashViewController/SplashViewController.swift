import UIKit
import WebKit
import Kingfisher

final class SplashViewController: UIViewController {
    
    // MARK: - Private Views
    private lazy var launchImage: UIImageView = {
        .init()
    }()
    
    // MARK: - Private Constants
    private var storage: StorageProtocol = Storage.shared
    private let secureStorage: SecureStorageProtocol = SecureStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared
    
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
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter()
        addObserverObject()
        setUpViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if storage.isNotFirstLaunch {
            if let token = secureStorage.getToken() {
                UIBlockingActivityIndicator.showActivityIndicator()
                fetchUserProfile(by: token) { [weak self] username in
                    self?.fetchUserProfilePhoto(by: token, username: username)
                }
                routeToMain()
            } else {
                routeToAuthentication()
            }
        } else {
            storage.isNotFirstLaunch = true
            routeToAuthentication()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    deinit {
        NotificationCenterManager.shared.removeObserver(observerObject)
    }
}

// MARK: - Extensions + Internal SplashViewController Appearance Control
extension SplashViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: - Extensions + Internal SplashViewController NotificationObserver Conformance
extension SplashViewController: NotificationObserver {
    func handleNotification(_ notification: Notification) {
        if notification.name == .logoutNotification {
            logout()
        }
    }
}

// MARK: - Extensions + Internal SplashViewController -> AuthViewControllerDelegate Conformance
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController, with token: String) {
        secureStorage.setToken(token)
    }
    
    func didFailAuthentication(with error: any Error) {
        routeToAuthentication()
        logErrorToSTDIO(
            errorDescription: (error as? TracedError)?.description ?? error.localizedDescription
        )
    }
}

// MARK: - Extensions + Private SplashViewController Helpers
private extension SplashViewController {
    
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
        
        routeToAuthentication()
    }
    
    func fetchUserProfile(
        by token: String,
        completion: ((String) -> Void)? = nil
    ) {
        profileService.fetchProfile(
            httpMethod: .GET,
            token: token
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                completion?(profile.username)
            case .failure(let error):
                logErrorToSTDIO(
                    errorDescription: (error as? TracedError)?.description ?? error.localizedDescription
                )
                self.alertPresenter?.present(present: self.present)
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
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                completion?()
            case .failure(let error):
                logErrorToSTDIO(
                    errorDescription: (error as? TracedError)?.description ?? error.localizedDescription
                )
                self.alertPresenter?.present(present: self.present)
            }
        }
    }
}

// MARK: - Extensions + Private SplashViewController Routing
private extension SplashViewController {
    func routeToAuthentication() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        
        authViewController.modalPresentationStyle = .fullScreen
        present(
            authViewController,
            animated: true
        )
    }
    
    func routeToMain() {
        let tabBarController = TabBarController()
        
        tabBarController.modalPresentationStyle = .fullScreen
        present(
            tabBarController,
            animated: false
        )
    }
}

// MARK: - Extensions + Private SplashViewController Setting Up Views
private extension SplashViewController {
    func setUpViews() {
        view.backgroundColor = .ypBlack
        setUpLaunchImage()
    }
    
    func setUpLaunchImage() {
        launchImage.image = UIImage(named: "LaunchScreenVector")
        launchImage.layer.cornerRadius = UserProfileViewConstraints.userProfileImage_LayerCornerRadiusConstant.rawValue
        launchImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(launchImage)
        
        NSLayoutConstraint.activate([
            launchImage.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor
            ),
            launchImage.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor
            ),
            launchImage.heightAnchor.constraint(
                equalToConstant: UserProfileViewConstraints.userProfileImage_WidthHeightConstant.rawValue
            ),
            launchImage.widthAnchor.constraint(
                equalTo: launchImage.heightAnchor
            ) // 1:1
        ])
    }
}
