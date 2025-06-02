import Foundation

// MARK: - Extensions + Internal Static Custom Notification.Name
extension Notification.Name {
    static let profileServiceProviderDidChangeNotification = Notification.Name("profileServiceProviderDidChangeNotification")
    static let profileImageServiceDidChangeNotification = Notification.Name("profileImageServiceDidChangeNotification")
    static let imagesListServicePhotosDidChangeNotification = Notification.Name("imagesListServiceDidChangeNotification")
    static let notificationCenterDidChangeNotification = Notification.Name("notificationCenterDidChangeNotification")
    static let logoutNotification = Notification.Name("logoutNotification")
    
    static let allCustomCases: [Notification.Name] = [
        profileServiceProviderDidChangeNotification,
        profileImageServiceDidChangeNotification,
        imagesListServicePhotosDidChangeNotification,
        notificationCenterDidChangeNotification,
        logoutNotification
    ]
}
