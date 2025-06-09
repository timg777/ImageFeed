import Foundation

protocol WebViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ progress: Float)
    func setProgressHidden(_ hidden: Bool)
}
