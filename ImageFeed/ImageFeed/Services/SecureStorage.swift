import KeychainWrapper

final class SecureStorage: SecureStorageProtocol {
    static let shared = SecureStorage()
    private init() {}
    
    private let storage = KeychainWrapper.default
    
    func getToken() -> String? {
        storage.string(forKey: GlobalNamespace.oAuthTokenKeyChainIdentifier)
    }
    
    func setToken(_ token: String) {
        storage.set(token, forKey: GlobalNamespace.oAuthTokenKeyChainIdentifier)
    }
    
    func removeToken() {
        storage.removeObject(forKey: GlobalNamespace.oAuthTokenKeyChainIdentifier)
    }
}
