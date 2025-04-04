import UIKit

enum UserProfileViewConstraints: CGFloat {
    case userProfileImage_LayerCornerRadiusConstant = 35
    case trailingAnchorConstant = -16 // + superview.safeAreaLayoutGuide.trailingAnchor
    case leadingAnchorConstant = 16 // + superview.safeAreaLayoutGuide.leadingAnchor
    case userProfileImage_WidthHeightConstant = 70
    case userProfileImage_TopAnchorConstant = 32
    case usernameLabel_TopAnchorConstant = 8 // + userProfileImageView.topAnchor
    case favoriteLabel_TopAnchorConstant = 24 // + aboutUserLabel/nicknameLabel/usernameLabel.topAnchor
    case logoutButton_WidthHeightConstant = 44
    case emptyFavotiesImageView_WidthHeightConstant = 115
}

enum UserProfileViewAttributedString {
    
    static var userNameLabelAttributedText: NSAttributedString {
        NSAttributedString(
            string: "Placeholder_username",
            attributes: [
                .kern : 0.3,
                .font : UIFont.systemFont(ofSize: 23, weight: .bold),
                .foregroundColor : UIColor.ypWhite
            ]
        )
    }
    
    static var nicknameLabelAttributedText: NSAttributedString {
        NSAttributedString(
            string: "@placeholder_nickname",
            attributes: [
                .kern : 0,
                .font : UIFont.systemFont(ofSize: 13, weight: .regular),
                .foregroundColor : UIColor.ypGray,
                .baselineOffset : 8,
            ]
        )
    }
    
    static var aboutUserLabelAttributedText: NSAttributedString {
        NSAttributedString(
            string: "Placeholder_about",
            attributes: [
                .kern : 0,
                .font : UIFont.systemFont(ofSize: 13, weight: .regular),
                .foregroundColor : UIColor.ypWhite
            ]
        )
    }
    
    static var favoriteLabelAttributedText: NSAttributedString {
        NSAttributedString(
            string: "Избранное",
            attributes: [
                .kern : 0,
                .font : UIFont.systemFont(ofSize: 23, weight: .bold),
                .foregroundColor : UIColor.ypWhite
            ]
        )
    }

}

final class UserProfileViewController: UIViewController {
    
    // MARK: - Private Constants
    private let userProfileImage = UIImageView()
    private let logoutButton = UIButton()
    private let usernameLabel = UILabel()
    private let nicknameLabel = UILabel()
    private let aboutUserLabel = UILabel()
    private let favoriteLabel = UILabel()
    private let emptyFavotiesImageView = UIImageView()
    
    // MARK: - VIew Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
}

private extension UserProfileViewController {
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
            emptyFavotiesImageView.widthAnchor.constraint(equalToConstant: 115),
            emptyFavotiesImageView.heightAnchor.constraint(equalTo: emptyFavotiesImageView.widthAnchor), // 1:1
            emptyFavotiesImageView.topAnchor.constraint(
                equalTo: favoriteLabel.bottomAnchor,
                constant: UserProfileViewConstraints.emptyFavotiesImageView_WidthHeightConstant.rawValue
            ),
            emptyFavotiesImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
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
}




