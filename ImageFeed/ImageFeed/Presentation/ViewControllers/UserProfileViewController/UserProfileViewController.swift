import UIKit
import Kingfisher
import KeychainWrapper

final class UserProfileViewController: UIViewController {
    
    // MARK: - Private Views
    private let userProfileImage = UIImageView()
    private let logoutButton = UIButton()
    private let usernameLabel = UILabel()
    private let nicknameLabel = UILabel()
    private let aboutUserLabel = UILabel()
    private let favoriteLabel = UILabel()
    private let emptyFavotiesImageView = UIImageView()
    
    // MARK: - Private Constants
    private let storage: StorageProtocol = Storage.shared
    private let secureStorage = KeychainWrapper.default
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeProfileImageURLNotification()
        setUpViews()
        updateLabels()
    }
}

// MARK: - Extensions + Private Buttons Actions
private extension UserProfileViewController {
    @objc func logoutButtonTapped() {
        let viewController = SplashViewController()
        setRootViewController(vc: viewController) { [weak self] in
            self?.handleSecureStorageTokenDelete()
        }
    }
}

// MARK: - Extensions + Private UI Updates
private extension UserProfileViewController {
    
    func updateProfileImage(using profileImageURLString: String) {
        
        guard let profileImageURL = URL(string: profileImageURLString) else {
            logErrorToSTDIO(
                errorDescription: "Failed to create URL using user profile photo URL String -> \(profileImageURLString)"
            )
            return
        }
        
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
        
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        
        userProfileImage.kf.indicatorType = .activity
        userProfileImage.kf.setImage(
            with: profileImageURL,
            placeholder: UIImage(named: "Userpick-Stub"),
            options: [
                .processor(processor)
            ]) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let imageResult):
                    userProfileImage.image = imageResult.image
                case .failure(let error):
                    logErrorToSTDIO(
                        errorDescription: error.localizedDescription
                    )
                }
            }

    }
    
    func updateLabels() {
        guard
            let profile = profileService.profile
        else {
            logErrorToSTDIO(
                errorDescription: "Failed to retrieve user ProfileService.profile. No user profile has been found"
            )
            return
        }
        
        usernameLabel.text = profile.name
        nicknameLabel.text = profile.loginName
        aboutUserLabel.text = profile.bio
    }
}

// MARK: - Extensions + Private Helpers
private extension UserProfileViewController {
    func handleSecureStorageTokenDelete() {
        secureStorage.removeObject(forKey: GlobalNamespace.oAuthTokenKeyChainIdentifier)
    }
    
    func observeProfileImageURLNotification() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.shared.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] notification in
                guard let self else { return }
                
                guard
                    let profileImageURLString = notification.userInfo?[UserInfoKey.profileImageURLString.rawValue] as? String
                else {
                    logErrorToSTDIO(
                        errorDescription: "No profileImageURLString found in notification"
                    )
                    return
                }

                updateProfileImage(using: profileImageURLString)
            }
    }
}

// MARK: - Extensions + Private Setting Up Views
private extension UserProfileViewController {
    func setUpViews() {
        view.backgroundColor = .ypBlack
        
        setUpUserProfileImage()
        
        setUpLogoutButton()
        
        setUpUsernameLabel()
        
        setUpNicknameLabel()
        
        setUpAboutUserLabel()
        
        setUpFavoriteLabel()
        
        setUpEmptyFavoritesImageView()
    }
    
    func setUpUserProfileImage() {
        userProfileImage.image = UIImage(named: "Userpick-Stub")
        userProfileImage.layer.cornerRadius = UserProfileViewConstraints.userProfileImage_LayerCornerRadiusConstant.rawValue
        userProfileImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(userProfileImage)
        
        NSLayoutConstraint.activate([
            userProfileImage.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: UserProfileViewConstraints.leadingAnchorConstant.rawValue
            ),
            userProfileImage.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: UserProfileViewConstraints.userProfileImage_TopAnchorConstant.rawValue
            ),
            userProfileImage.heightAnchor.constraint(
                equalToConstant: UserProfileViewConstraints.userProfileImage_WidthHeightConstant.rawValue
            ),
            userProfileImage.widthAnchor.constraint(
                equalTo: userProfileImage.heightAnchor
            ) // 1:1
        ])
    }
    
    func setUpUsernameLabel() {
        usernameLabel.attributedText = UserProfileViewAttributedString.userNameLabelAttributedText
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: UserProfileViewConstraints.leadingAnchorConstant.rawValue
            ),
            usernameLabel.topAnchor.constraint(
                equalTo: userProfileImage.bottomAnchor,
                constant: UserProfileViewConstraints.usernameLabel_TopAnchorConstant.rawValue
            )
        ])
    }
    
    func setUpNicknameLabel() {
        nicknameLabel.attributedText = UserProfileViewAttributedString.nicknameLabelAttributedText
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nicknameLabel)
        
        NSLayoutConstraint.activate([
            nicknameLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: UserProfileViewConstraints.leadingAnchorConstant.rawValue
            ),
            nicknameLabel.topAnchor.constraint(
                equalTo: usernameLabel.bottomAnchor,
                constant: UserProfileViewConstraints.usernameLabel_TopAnchorConstant.rawValue
            )
        ])
    }
    
    func setUpAboutUserLabel() {
        aboutUserLabel.attributedText = UserProfileViewAttributedString.aboutUserLabelAttributedText
        aboutUserLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(aboutUserLabel)
        
        NSLayoutConstraint.activate([
            aboutUserLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: UserProfileViewConstraints.leadingAnchorConstant.rawValue
            ),
            aboutUserLabel.topAnchor.constraint(
                equalTo: nicknameLabel.bottomAnchor,
                constant:  UserProfileViewConstraints.usernameLabel_TopAnchorConstant.rawValue
            )
        ])
    }
    
    func setUpLogoutButton() {
        logoutButton.setImage(
            UIImage(named: "Exit"),
            for: .normal
        )
        logoutButton.imageView?.contentMode = .scaleAspectFit
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(
                equalToConstant: UserProfileViewConstraints.logoutButton_WidthHeightConstant.rawValue
            ),
            logoutButton.heightAnchor.constraint(
                equalTo: logoutButton.widthAnchor
            ), // 1:1
            logoutButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: UserProfileViewConstraints.trailingAnchorConstant.rawValue
            ),
            logoutButton.centerYAnchor.constraint(
                equalTo: userProfileImage.centerYAnchor
            ),
        ])
    }
  
    func setUpFavoriteLabel() {
        favoriteLabel.attributedText = UserProfileViewAttributedString.favoriteLabelAttributedText
        favoriteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(favoriteLabel)
        
        NSLayoutConstraint.activate([
            favoriteLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: UserProfileViewConstraints.leadingAnchorConstant.rawValue
            ),
            favoriteLabel.topAnchor.constraint(
                equalTo: aboutUserLabel.bottomAnchor,
                constant: UserProfileViewConstraints.favoriteLabel_TopAnchorConstant.rawValue
            )
        ])
    }
    
    func setUpEmptyFavoritesImageView() {
        emptyFavotiesImageView.image = UIImage(named: "No Photo")
        emptyFavotiesImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emptyFavotiesImageView)
        
        NSLayoutConstraint.activate([
            emptyFavotiesImageView.widthAnchor.constraint(
                equalToConstant: 115
            ),
            emptyFavotiesImageView.heightAnchor.constraint(
                equalTo: emptyFavotiesImageView.widthAnchor
            ), // 1:1
            emptyFavotiesImageView.topAnchor.constraint(
                equalTo: favoriteLabel.bottomAnchor,
                constant: UserProfileViewConstraints.emptyFavotiesImageView_WidthHeightConstant.rawValue
            ),
            emptyFavotiesImageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            )
        ])
    }
}
