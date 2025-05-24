import UIKit

struct GlobalNamespace {
    // MARK: - global config
    static let localizationIdentifier = "ru_RU"
    static let imagesListServicePhotosPerPageCount: Int = 10
    
    // MARK: - Security Data
    static let appName = "com.TIPT.ImageFeed"
    static let account = "timg777@yandex.ru"
    static let userOAuthTokenSaltPiece_1 = "%0x008!.4"
    static let userOAuthTokenSaltPiece_2 = "*&x0#8^"
    
    // MARK: - UserDefaults Keys
    static let isNotFirstLaunchKey = "isNotFirstLaunch"
    
    // MARK: - KeyChain Identifiers
    static let oAuthTokenKeyChainIdentifier = ".OAuthTokenKeyChainIdentifier"
    
    // MARK: - insets
    static let imageInsets =
    UIEdgeInsets(
        top: 4,
        left: 0,
        bottom: 4,
        right: 0
    )
    static let tableViewEdgeInsets =
    UIEdgeInsets(
        top: 5,
        left: 16,
        bottom: 5,
        right: 16
    )
    
    // MARK: - other
    static let cellCornerRadius: CGFloat = 16
    
    // MARK: - likeButton config
    static let likeButtonShadowRadius = CGFloat(7)
    static let likeButtonShadowOpacity: Float = 0.5
    static let likeButtonShadowOffset: CGSize = .zero
    static let likeButtonShadowColor: CGColor = UIColor.black.cgColor
    
    // MARK: - Routing
    enum Routing: String {
        case tabBarControllerIdentifier = "TabBarControllerIdentifier"
    }
    
    // MARK: - notification identifiers
    enum NorificationName: String {
        case profileImageProviderDidChange
        case imagesListServiceDidChangeNotification
    }
}
