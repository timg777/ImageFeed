import Foundation

protocol NotificationObserver: AnyObject {
    func handleNotification(_ notification: Notification)
}
