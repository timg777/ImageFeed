@testable import ImageFeed
import XCTest

final class MockObserver: NotificationObserver {
    // MARK: - Internal Properties
    var receivedNotification: Notification?
    
    // MARK: - Private Constants
    private let expectation: XCTestExpectation?
    
    // MARK: - Internal Initialization
    init(expectation: XCTestExpectation? = nil) {
        self.expectation = expectation
    }
    
    // MARK: - internal Methods
    func handleNotification(_ notification: Notification) {
        receivedNotification = notification
        expectation?.fulfill()
    }
}
