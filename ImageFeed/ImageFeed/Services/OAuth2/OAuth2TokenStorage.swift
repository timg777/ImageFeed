import Foundation

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: GlobalNamespace.userOAuthTokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: GlobalNamespace.userOAuthTokenKey)
        }
    }
}
