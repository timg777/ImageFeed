import Foundation

final class Storage: StorageProtocol {
    
    static let shared = Storage()
    private let storage = UserDefaults.standard
    private init() {}
    
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
