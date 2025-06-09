import UIKit

final class OAuth2Service: OAuth2ServiceProtocol {
    
    // MARK: - Singletone initialization
    static let shared = OAuth2Service()
    private init() {}
    
    // MARK: - Private Constants
    private let configuration: AuthConfiguration = .standard
    
    // MARK: - Private Properties
    private var lastCode: String?
    private var task: URLSessionTask?

}

// MARK: - Extensions + Internal OAuth2Service -> OAuth2ServiceProtocol Conformance
extension OAuth2Service {
    func fetchOAuthToken(
        code: String,
        handler: @escaping (Result<String, Error>) -> Void
    ) {
        guard
            lastCode != code
        else {
            handler(
                .failure(OAuth2Error.duplicateOAuthRequest)
            )
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard
            let request = makeOAuthTokenRequest(code: code)
        else {
            handler(
                .failure(OAuth2Error.invalidRequest)
            )
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuth2TokenResponseBody, Error>) in
            guard let self else { return }
            switch result {
            case .success(let oAuthTokenResponse):
                let tokenType = oAuthTokenResponse.token_type
                
                if tokenType.lowercased() == "bearer" {
                    handler(
                        .success(oAuthTokenResponse.access_token)
                    )
                } else {
                    handler(
                        .failure(OAuth2Error.invalidTokenType(tokenType))
                    )
                }
            case .failure(let error):
                handler(
                    .failure(error)
                )
            }
            self.task = nil
            self.lastCode = nil
        }
        
        self.task = task
        task.resume()
    }
}

// MARK: - Extensions + Internal Requests
extension OAuth2Service {
    func getUserAuthRequest() -> URLRequest? {
        guard
            var urlComponents = URLComponents(string: configuration.authURLString)
        else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(
                name: "client_id",
                value: configuration.accessKey
            ),
            URLQueryItem(
                name: "redirect_uri",
                value: configuration.redirectURI
            ),
            URLQueryItem(
                name: "response_type",
                value: "code"
            ),
            URLQueryItem(
                name: "scope",
                value: configuration.accessScope
            )
        ]
        
        guard
            let url = urlComponents.url
        else { return nil }
        
        let request = URLRequest(url: url)
        return request
    }
}

// MARK: - Extensions + Private Helpers
private extension OAuth2Service {
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = configuration.defaultBaseURL else { return nil }
        guard let url = URL(
            string: "oauth/token/"
            + "?client_id=\(configuration.accessKey)"
            + "&&client_secret=\(configuration.secretKey)"
            + "&&redirect_uri=\(configuration.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        )
        else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
