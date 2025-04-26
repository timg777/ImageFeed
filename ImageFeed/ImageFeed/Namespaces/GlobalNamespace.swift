import UIKit

struct GlobalNamespace {
    // MARK: - global config
    static let localizationIdentifier = "ru_RU"
    static let userOAuthTokenKey = "userOAuthToken"
    
    // MARK: - insets
    static let imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
    static let tableViewEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    
    // MARK: - other
    static let cellCornerRadius: CGFloat = 16
    
    // MARK: - likeButton config
    static let likeButtonShadowRadius = CGFloat(7)
    static let likeButtonShadowOpacity: Float = 0.5
    static let likeButtonShadowOffset: CGSize = .zero
    static let likeButtonShadowColor: CGColor = UIColor.black.cgColor
    
    // MARK: - routing identifiers
    static let authenticationSegueIdentifier = "UserAuthenticationSegueIdentifier"
    static let tabBarControllerIdentifier = "TabBarControllerIdentifier"
    static let showWebViewSegueIdentifier = "showWebViewSegueIdentifier"
    static let greetingControllerIdentifier = "GreetingViewControllerIdentifier"
}
