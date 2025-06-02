import Foundation

// MARK: - Extensions + Internal Notification Equatable overriding
extension Notification {
    static func == (lhs: Notification, rhs: Notification) -> Bool {
        lhs.name == rhs.name &&
        (lhs.object as AnyObject?) === (rhs.object as AnyObject?)
    }
}
