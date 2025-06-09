import Foundation

final class MockSender {
    // MARK: - Private Constants
    private let notificationName: Notification.Name
    private let infoToSend: [AnyHashable: Any]
    
    // MARK: - Internal Initialization
    init(
        notificationName: Notification.Name,
        infoToSend: [AnyHashable : Any]
    ) {
        self.notificationName = notificationName
        self.infoToSend = infoToSend
    }
    
    // MARK: - Internal Methods
    func sendNotification() {
        NotificationCenter.default
            .post(
                name: notificationName,
                object: self,
                userInfo: infoToSend
            )
    }
}
