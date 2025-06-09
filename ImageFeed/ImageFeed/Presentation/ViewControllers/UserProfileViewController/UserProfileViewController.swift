import UIKit
import Kingfisher

final class UserProfileViewController: UIViewController & UserProfileViewControllerProtocol {

    // MARK: - Private Views
    private lazy var userProfileImage: UIImageView = {
        .init()
    }()
    private lazy var logoutButton: UIButton = {
        .init()
    }()
    private lazy var usernameLabel: UILabel = {
        .init()
    }()
    private lazy var nicknameLabel: UILabel = {
        .init()
    }()
    private lazy var aboutUserLabel: UILabel = {
        .init()
    }()
    private lazy var favoriteLabel: UILabel = {
        .init()
    }()
    private lazy var emptyFavotiesImageView: UIImageView = {
        .init()
    }()
    
    // MARK: - Private Properties
    private var alertPresenter: AlertPresenterProtocol?
    
    // MARK: - Internal Properties
    var presenter: UserProfilePresenterProtocol?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        alertPresenter = AlertPresenter()
        
        setUpViews()
    }
}

// MARK: - Extensions + Internal UserProfileViewController -> UserProfileViewControllerProtocol Conformance
extension UserProfileViewController {
    func setUserProfile(_ profile: Profile) {
        updateLabels(using: profile)
    }
    
    func setProfileImage(using url: URL) {
        updateProfileImage(using: url)
    }
}

// MARK: - Extensions + Private UserProfileViewController Buttons Actions
private extension UserProfileViewController {
    @objc func logoutButtonTapped() {
        DispatchQueue.main.async {
            self.alertPresenter?.present(
                present: self.present,
                yesButtonAction: { [weak self] in
                    NotificationCenter.default
                        .post(
                            name: .logoutNotification,
                            object: self
                        )
                    self?.dismiss(animated: true)
                }
            )
        }
    }
}

// MARK: - Extensions + Private UserProfileViewController UI Updates
private extension UserProfileViewController {
    
    func updateProfileImage(using profileImageURL: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        
        userProfileImage.kf.setImage(
            with: profileImageURL,
            placeholder: UIImage(resource: .userpickStub),
            options: [
                .processor(processor)
            ]) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    userProfileImage.layer.sublayers?.removeAll()
                case .failure(let error):
                    logErrorToSTDIO(
                        errorDescription: error.localizedDescription
                    )
                }
            }
    }
    
    func updateLabels(using profile: Profile) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self else { return }
            usernameLabel.text = profile.name
            nicknameLabel.text = profile.loginName
            aboutUserLabel.text = profile.bio
            
            usernameLabel.layer.sublayers?.removeAll()
            nicknameLabel.layer.sublayers?.removeAll()
            aboutUserLabel.layer.sublayers?.removeAll()
        }
    }
}

// MARK: - Extensions + Private UserProfileViewController Setting Up Views
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
        
        userProfileImage.layer.addGradientLoadingAnimation(
            cornerRadius: UserProfileViewConstraints.userProfileImage_LayerCornerRadiusConstant.rawValue
        )
        userProfileImage.layer.scaleGradientAnimationSubLayer(scaleFactor: 1.2)
        
        usernameLabel.layer.addGradientLoadingAnimation(cornerRadius: 5)
        nicknameLabel.layer.addGradientLoadingAnimation(cornerRadius: 5)
        aboutUserLabel.layer.addGradientLoadingAnimation(cornerRadius: 5)
    }
    
    func setUpUserProfileImage() {
        userProfileImage.image = UIImage(resource: .userpickStub)
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
            UIImage(resource: .exit),
            for: .normal
        )
        logoutButton.imageView?.contentMode = .scaleAspectFit
        logoutButton.accessibilityIdentifier = AccessibilityElement.logoutButton.rawValue
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
        emptyFavotiesImageView.image = UIImage(resource: .noPhoto)
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
