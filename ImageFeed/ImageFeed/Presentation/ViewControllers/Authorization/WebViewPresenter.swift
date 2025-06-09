import WebKit

final class WebViewPresenter: WebViewPresenterProtocol {
    
    // MARK: - Private Constants
    private let authHelper: AuthHelperProtocol
    
    // MARK: - Internal Properties
    weak var view: WebViewControllerProtocol?
    
    // MARK: - Initialization
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    // MARK: - Presenter Life Cycles
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else {
            logErrorToSTDIO(
                errorDescription: "Failed to create URLRequest by OAouth2Service.getUserAuthRequest"
            )
            return
        }
        view?.load(request: request)
        
        didUpdateProgressValue(0)
    }
}

// MARK: - Extensions + Internal WebViewPresenter -> WebViewPresenterProtocol Conformance
extension WebViewPresenter {
    func didUpdateProgressValue(_ progress: Float) {
        let shouldHideProgress = shouldHideProgress(for: progress)
        view?.setProgressHidden(shouldHideProgress)
        view?.setProgressValue(shouldHideProgress ? 0 : progress)
    }
    
    func shouldHideProgress(for progress: Float) -> Bool {
        abs(progress - 1.0) <= 0.0001
    }
    
    func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return authHelper.code(from: url)
        }
        return nil
    }
}
