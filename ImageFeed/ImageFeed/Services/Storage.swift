import Foundation

final class Storage: StorageProtocol {
    
    // MARK: - Singletone initialization
    static let shared = Storage()
    private init() {}
    
    // MARK: - Private Constants
    private let storage = UserDefaults.standard
}

// MARK: - Extensions + Internal Storage -> StorageProtocol Conformance
extension Storage {
    // MARK: - Internal Properties
    var isNotFirstLaunch: Bool {
        get {
            storage.bool(forKey: GlobalNamespace.isNotFirstLaunchKey)
        }
        set {
            storage.set(newValue, forKey: GlobalNamespace.isNotFirstLaunchKey)
        }
    }
}
