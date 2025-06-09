import KeychainWrapper

final class SecureStorage: SecureStorageProtocol {
    
    // MARK: - Singletone initialization
    static let shared = SecureStorage()
    private init() {}
    
    // MARK: - Private Constants
    private let storage = KeychainWrapper.default
}

// MARK: - Extensions + Internal SecureStorage -> SecureStorageProtocol Conformance
extension SecureStorage {
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
