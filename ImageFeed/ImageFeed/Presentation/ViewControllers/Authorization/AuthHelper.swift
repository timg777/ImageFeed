import Foundation

final class AuthHelper: AuthHelperProtocol {

    // MARK: - Private Constants
    private let configuration: AuthConfiguration
    private let oauth2Service = OAuth2Service.shared
    
    // MARK: - Initialization
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
}

// MARK: - Extensions + Private AuthHelper -> AuthHelperProtocol Conformance
extension AuthHelper {
    func authRequest() -> URLRequest? {
        oauth2Service.getUserAuthRequest()
    }
    
    func code(from url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let queryItems = urlComponents.queryItems,
            let codeQueryItem =
                queryItems.first(where: {
                    $0.name == "code"
                })
        {
            return codeQueryItem.value
        }
        return nil
    }
}
