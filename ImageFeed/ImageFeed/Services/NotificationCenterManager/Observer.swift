import Foundation

final class Observer {
    let observer: NotificationObserver
    let senders: [Any.Type]?
    let names: [Notification.Name]
    
    init(
        _ observer: NotificationObserver,
        from senders: [Any.Type]? = nil,
        for names: [Notification.Name]
    ) throws {
        guard !names.isEmpty else {
            throw NSError(
                domain: "Observer must observe at least one notification",
                code: 0,
                userInfo: nil
            )
        }
        self.observer = observer
        self.senders = senders
        self.names = names
    }

    func tryNotify(with notification: Notification) -> Bool {
        guard
            let sender = notification.object
        else {
            return false
        }
        
        if senders?.isEmpty ?? true {
            if names.contains(notification.name) {
                observer.handleNotification(notification)
                return true
            }
        } else if let senders = senders {
            for senderType in senders {
                if senderType == type(of: sender) {
                    observer.handleNotification(notification)
                    return true
                }
            }
        }
        
        return false
    }

}
