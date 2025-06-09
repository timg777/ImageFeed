import Foundation

protocol AuthHelperProtocol: AnyObject {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}
