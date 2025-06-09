@testable import ImageFeed
import WebKit

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    
    var authHelper: AuthHelperProtocol?
    private(set) var viewDidiLoadCalled = false
    var view: WebViewControllerProtocol?
    
    init(authHelper: AuthHelperProtocol? = nil) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        viewDidiLoadCalled = true
        guard let request = authHelper?.authRequest() else {
            logErrorToSTDIO(
                errorDescription: "Failed to create URLRequest by OAouth2Service.getUserAuthRequest"
            )
            return
        }
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ progress: Float) {
        // do nothing
    }
    
    func shouldHideProgress(for progress: Float) -> Bool {
        true
    }
    
    func code(from navigationAction: WKNavigationAction) -> String? {
        nil
    }
}
