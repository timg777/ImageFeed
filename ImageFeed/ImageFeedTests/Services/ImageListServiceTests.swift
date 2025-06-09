@testable import ImageFeed
import XCTest

final class ImageListServiceTests: XCTestCase {
    
    enum InternetConnectionState {
        case available
        case unavailable
    }
    
    // MARK: - Specify your connection state
    let specifiedConnectionState: InternetConnectionState = .available
    
    func testForInternetConnection() throws {
        ImagesListService.shared.fetchPhotosNextPage { [weak self] result in
            guard let self else {
                XCTFail("Self is nil")
                return
            }
            switch result {
            case .success(let success):
                checkConnectionStateForMismatching(isSuccess: true)
            case .failure(let failure):
                checkConnectionStateForMismatching(isSuccess: false)
            }
        }
    }
    
    func testForManyRequestRetries() throws {
        // given
        let service = ImagesListService.shared
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: .imagesListServicePhotosDidChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        
        // when
        (0..<5).forEach { _ in
            ImagesListService.shared.fetchPhotosNextPage { _ in }
        }
        
        // then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(service.photos.count + 1, GlobalNamespace.imagesListServicePhotosPerPageCount)
    }
    
    private func checkConnectionStateForMismatching(isSuccess: Bool) {
        switch specifiedConnectionState {
        case .available:
            if !isSuccess {
                XCTFail("Internet connection is available, but service fetching failed")
            }
        case .unavailable:
            if isSuccess {
                XCTFail("Internet connection is unavailable, but service fetching succeeded")
            }
        }
    }
}
