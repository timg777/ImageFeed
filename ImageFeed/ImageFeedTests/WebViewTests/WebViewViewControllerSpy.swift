@testable import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewControllerProtocol {
    // MARK: - Internal Properties
    var presenter: WebViewPresenterProtocol?
    private(set) var loadReqestCalled = false
    private(set) var progressValue: Float = 0
    private(set) var progressHidden: Bool = true
    
    // MARK: - View Life Cycles
    func viewDidLoad() {
        presenter?.viewDidLoad()
    }
}

// MARK: - Extensions + Internal WebViewViewController -> WebViewControllerProtocol Conformance
extension WebViewViewControllerSpy {
    func load(request: URLRequest) {
        loadReqestCalled = true
    }
    
    func setProgressValue(_ progress: Float) {
        progressValue = progress
    }
    
    func setProgressHidden(_ hidden: Bool) {
        progressHidden = hidden
    }
}
