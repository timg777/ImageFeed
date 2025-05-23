import UIKit
import KeychainWrapper

final class SplashViewController: UIViewController {
    
    // MARK: - Private Views
    private let launchImage = UIImageView()
    
    // MARK: - Private Constants
    private var storage: StorageProtocol = Storage.shared
    private let secureStorage = KeychainWrapper.default
    private let activityIndicator = UIBlockingActivityIndicator.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    // MARK: - View Life Cycles
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpViews()

        if storage.isNotFirstLaunch {
            if let token = handleSecureStorageTokenResult() {
                fetchUserProfile(by: token)
                routeToMain()
            } else {
                logErrorToSTDIO(
                    errorDescription: "No token found in KeychainWrapper"
                )
                routeToAuthentication()
            }
        } else {
            storage.isNotFirstLaunch = true
            handleSecureStorageTokenResult(remove: true)
            routeToAuthentication()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
}

// MARK: - Extensions + Internal Appearance Control
extension SplashViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: - Extensions + Internal AuthViewControllerDelegate Conformance
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        activityIndicator.showActivityIndicator()
        guard let token = handleSecureStorageTokenResult() else {
            logErrorToSTDIO(
                errorDescription: "Failed to handle secure storage token result"
            )
            return
        }
        fetchUserProfile(by: token)
    }
    
    func didFailAuthentication(with error: any Error) {
        routeToAuthentication()
        logErrorToSTDIO(
            errorDescription: (error as? TracedError)?.description ?? error.localizedDescription
        )
    }
}

// MARK: - Extensions + Private Helpers
private extension SplashViewController {
    
    @discardableResult
    func handleSecureStorageTokenResult(remove: Bool = false) -> String? {
        if remove {
            secureStorage.removeObject(
                forKey: GlobalNamespace.oAuthTokenKeyChainIdentifier
            )
            return nil
        } else {
            return secureStorage.string(
                forKey: GlobalNamespace.oAuthTokenKeyChainIdentifier
            )
        }
    }
    
    func fetchUserProfile(by token: String) {
        profileService.fetchProfile(
            httpMethod: .GET,
            token: token
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                profileImageService.fetchProfileImageURL(
                    username: profile.username,
                    token: token
                ) { result in
                    self.dismissAndGoToMain()
                    switch result {
                    case .success(_):
                        // TODO: - succeeded staff here
                        break
                    case .failure(let error):
                        logErrorToSTDIO(
                            errorDescription: (error as? TracedError)?.description ?? error.localizedDescription
                        )
                    }
                }
            case .failure(let error):
                logErrorToSTDIO(
                    errorDescription: (error as? TracedError)?.description ?? error.localizedDescription
                )
            }
        }
    }
}

// MARK: - Extensions + Private Routing
private extension SplashViewController {
    func dismissAndGoToMain() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            dismiss(animated: true) { [weak self] in
                guard let self else { return }
                activityIndicator.dismissActivityIndicator()
                routeToMain()
            }
        }
    }
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
        setRootViewController(vc: tabBarController)
    }
}

// MARK: - Extensions + Private Setting Up Views
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
