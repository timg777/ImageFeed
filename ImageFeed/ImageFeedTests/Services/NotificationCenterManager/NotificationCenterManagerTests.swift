@testable import ImageFeed
import XCTest

final class NotificationCenterManagerTests: XCTestCase {
    
    private let manager = NotificationCenterManager.shared
    private let notificationName = Notification.Name.logoutNotification
    private let infoToSend: [AnyHashable: Any] = ["SomeKey":"Some value"]
    
    func testAddObserver() throws {
        clearManagerData()
        
        let observer = MockObserver()
        let observerObject =
        try Observer(
            observer,
            for: [
                .logoutNotification
            ]
        )
        manager.addObserver(observerObject)
        
        let observersCount = manager.observers.allObjects.count
        let managerContainsObserver = manager.observers.contains(observerObject)

        XCTAssertEqual(observersCount, 1)
        XCTAssertTrue(managerContainsObserver)
    }
    
    func testRemoveObserver() throws {
        clearManagerData()
        
        let observer = MockObserver()
        let observerObject =
        try Observer(
            observer,
            for: [
                .logoutNotification
            ]
        )
        manager.addObserver(observerObject)
        manager.removeObserver(observerObject)
        
        let observersCount = manager.observers.allObjects.count
        let managerContainsObserver = manager.observers.contains(observerObject)
        
        XCTAssertEqual(observersCount, 0)
        XCTAssertFalse(managerContainsObserver)
    }
    
    func testRemoveAllObservers() throws {
        clearManagerData()
        
        let firstObserver = MockObserver()
        let secondObserver = MockObserver()
        
        firstObserver.receivedNotification = .init(name: .logoutNotification)
        secondObserver.receivedNotification = .init(name: .imagesListServicePhotosDidChangeNotification)
        
        let firstObserverObject =
        try Observer(
            firstObserver,
            for: [
                .logoutNotification
            ]
        )
        let secondObserverObject =
        try Observer(
            secondObserver,
            for: [
                .imagesListServicePhotosDidChangeNotification
            ]
        )
        
        manager.addObserver(firstObserverObject)
        manager.addObserver(secondObserverObject)
        manager.removeAllObservers()
        
        let observersCount = manager.observers.allObjects.count
        XCTAssertEqual(observersCount, 0)
    }
    
    func testNotificationReceivedByServiceWithZeroObservers() throws {
        clearManagerData()
        
        let sender = MockSender(
            notificationName: notificationName,
            infoToSend: infoToSend
        )
        sender.sendNotification()
        
        let notification = manager.lastNotifications.first
        XCTAssertEqual(
            manager.lastNotifications.count,
            1
        )
        XCTAssertEqual(
            notification?.name,
            notificationName
        )
        XCTAssertEqual(
            notification?.userInfo?["SomeKey"] as? String,
            infoToSend["SomeKey"] as? String
        )
    }
    
    func testNotificationWhenObserverInitializedBeforeMessageSended() throws {
        clearManagerData()
        
        let expectation = self.expectation(description: "Wait for notification")
        let sender = MockSender(
            notificationName: notificationName,
            infoToSend: infoToSend
        )
        let observer = MockObserver(
            expectation: expectation
        )
        let observerObject =
        try Observer(
            observer,
            from: [
                MockSender.self
            ],
            for: [
                .logoutNotification
            ]
        )
        
        manager.addObserver(observerObject)
        sender.sendNotification()
        
        wait(for: [expectation], timeout: 3)
        
        let notification = observer.receivedNotification
        XCTAssertTrue(manager.lastNotifications.isEmpty)
        XCTAssertNotNil(notification)
        XCTAssertEqual(
            notification?.name,
            notificationName
        )
        XCTAssertEqual(
            notification?.userInfo?["SomeKey"] as? String,
            infoToSend["SomeKey"] as? String
        )
    }
    
    func testNotificationWhenObserverInitializedAfterMessageSended() throws {
        clearManagerData()
        
        let expectation = self.expectation(description: "Wait for notification")
        let sender = MockSender(
            notificationName: notificationName,
            infoToSend: infoToSend
        )
        let observer = MockObserver(
            expectation: expectation
        )
        let observerObject =
        try Observer(
            observer,
            from: [
                MockSender.self
            ],
            for: [
                .logoutNotification
            ]
        )
        
        sender.sendNotification()
        XCTAssertFalse(manager.lastNotifications.isEmpty)
        manager.addObserver(observerObject)
        
        wait(for: [expectation], timeout: 3)
        
        let notification = observer.receivedNotification
        XCTAssertTrue(manager.lastNotifications.isEmpty)
        XCTAssertNotNil(notification)
        XCTAssertEqual(
            notification?.name,
            notificationName
        )
        XCTAssertEqual(
            notification?.userInfo?["SomeKey"] as? String,
            infoToSend["SomeKey"] as? String
        )
    }
    
    private func clearManagerData() {
        manager.clearNotifications()
        manager.removeAllObservers()
    }
}
