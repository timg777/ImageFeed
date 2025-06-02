@testable import ImageFeed
import XCTest

final class NotificationCenterManagerTests: XCTestCase {
    
    let manager = NotificationCenterManager.shared
    private let notificationName = Notification.Name.logoutNotification
    private let infoToSend: [AnyHashable: Any] = ["SomeKey":"Some value"]
    
    func testAddObserver() throws {
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
        let observer = MockObserver()
        let observerObject =
        try Observer(
            observer,
            for: [
                .logoutNotification
            ]
        )
        manager.addObserver(observerObject)
        manager.removeObserver(observer)
        
        let observersCount = manager.observers.allObjects.count
        let managerContainsObserver = manager.observers.contains(observerObject)
        XCTAssertEqual(observersCount, 0)
        XCTAssertFalse(managerContainsObserver)
    }
    
    func testRemoveAllObservers() throws {
        let observer1 = MockObserver()
        let observer2 = MockObserver()
        
        observer1.receivedNotification = .init(name: .logoutNotification)
        observer2.receivedNotification = .init(name: .imagesListServiceDidChangeNotification)
        
        let observerObject1 =
        try Observer(
            observer1,
            for: [
                .logoutNotification
            ]
        )
        let observerObject2 =
        try Observer(
            observer2,
            for: [
                .imagesListServiceDidChangeNotification
            ]
        )
        
        manager.addObserver(observerObject1)
        manager.addObserver(observerObject2)
        manager.removeAllObservers()
        
        let observersCount = manager.observers.allObjects.count
        XCTAssertEqual(observersCount, 0)
    }
    
    func testNotificationReceivedByServiceWithZeroObservers() throws {
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
}





final class MockObserver: NotificationObserver {
    var receivedNotification: Notification?
    let expectation: XCTestExpectation?
    
    init(expectation: XCTestExpectation? = nil) {
        self.expectation = expectation
    }
    
    func handleNotification(_ notification: Notification) {
        receivedNotification = notification
        expectation?.fulfill()
    }
}

final class MockSender {
    private let notificationName: Notification.Name
    private let infoToSend: [AnyHashable: Any]
    
    init(
        notificationName: Notification.Name,
        infoToSend: [AnyHashable : Any]
    ) {
        self.notificationName = notificationName
        self.infoToSend = infoToSend
    }
    
    func sendNotification() {
        NotificationCenter.default
            .post(
                name: notificationName,
                object: self,
                userInfo: infoToSend
            )
    }
}
