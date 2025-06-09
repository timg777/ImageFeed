import Foundation
import Combine

final class NotificationCenterManager {
    
    static let shared = NotificationCenterManager()
    
    let observers = NSHashTable<Observer>.weakObjects()
    private(set) var lastNotifications = Set<Notification>()
    
    private let notificationSubject = PassthroughSubject<Notification, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let notificationNames = Notification.Name.allCustomCases
    
    private init() {
        notificationNames.forEach {
            NotificationCenter.default
                .publisher(for: $0)
                .subscribe(notificationSubject)
                .store(in: &cancellables)
        }
        
        notificationSubject
            .sink { [weak self] notification in
                self?.handleNotification(notification)
            }
            .store(in: &cancellables)
    }
    
    deinit {
        lastNotifications.removeAll()
        observers.removeAllObjects()
    }
}

// MARK: - Extensions + Internal NotificationCenterManager Methods
extension NotificationCenterManager {
    func addObserver(_ observer: Observer) {
        observers.add(observer)
        
        lastNotifications.forEach {
            notifyObservers(notification: $0)
        }
    }
    
    func removeObserver(_ observer: Observer?) {
        observers.allObjects
            .filter { $0 === observer }
            .forEach { observers.remove($0) }
    }
    
    func removeAllObservers(exclude mainObserver: Observer? = nil) {
        observers.allObjects
            .forEach {
                if $0 !== mainObserver {
                    observers.remove($0)
                }
            }
    }
    
    func clearNotifications() {
        lastNotifications.removeAll()
    }
}

// MARK: - Extensions + Private NotificationCenterManager Methods
private extension NotificationCenterManager {
    
    func notifyObservers(notification: Notification) {
        guard !observers.allObjects.isEmpty else {
            tryStoreNotification(notification: notification)
            return
        }
        observers.allObjects.forEach {
            if !$0.tryNotify(with: notification) {
                tryStoreNotification(notification: notification)
            } else {
                notificationHandled(notification)
            }
        }
    }
    
    func tryStoreNotification(notification: Notification) {
        if !lastNotifications.contains(notification) {
            lastNotifications.insert(notification)
        }
    }
    
    func handleNotification(_ notification: Notification) {
        notifyObservers(notification: notification)
    }
    
    func notificationHandled(_ notification: Notification) {
        lastNotifications.remove(notification)
    }
}
