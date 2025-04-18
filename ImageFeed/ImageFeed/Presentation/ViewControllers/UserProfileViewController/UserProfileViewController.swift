import UIKit

final class UserProfileViewController: UIViewController {
    
    // MARK: - Private Constants
    private let userProfileImage = UIImageView()
    private let logoutButton = UIButton()
    private let usernameLabel = UILabel()
    private let nicknameLabel = UILabel()
    private let aboutUserLabel = UILabel()
    private let favoriteLabel = UILabel()
    private let emptyFavotiesImageView = UIImageView()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
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
        logoutButton.setImage(UIImage(named: "Exit"), for: .normal)
        logoutButton.imageView?.contentMode = .scaleAspectFit
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(
                equalToConstant: UserProfileViewConstraints.logoutButton_WidthHeightConstant.rawValue
            ),
            logoutButton.heightAnchor.constraint(equalTo: logoutButton.widthAnchor), // 1:1
            logoutButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: UserProfileViewConstraints.trailingAnchorConstant.rawValue
            ),
            logoutButton.centerYAnchor.constraint(equalTo: userProfileImage.centerYAnchor),
        ])
    }
}
