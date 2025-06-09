import WebKit

protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ progress: Float)
    func shouldHideProgress(for progress: Float) -> Bool
    func code(from navigationAction: WKNavigationAction) -> String?
}
