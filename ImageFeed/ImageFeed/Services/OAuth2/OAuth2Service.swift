import UIKit

final class OAuth2Service: OAuth2ServiceProtocol {
    static let shared = OAuth2Service()
    private init() {}
}

// MARK: - Extensions + Internal Data Fetching
extension OAuth2Service {
    func fetchOAuthToken(
        code: String,
        handler: @escaping (Result<String, Error>) -> Void
    ) {
        guard
            let request = makeOAuthTokenRequest(code: code)
        else {
            handler(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTaskResult(for: request) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let oAuthTokenResponse = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    let tokenType = oAuthTokenResponse.token_type
                    
                    if tokenType.lowercased() == "bearer" {
                        handler(.success(oAuthTokenResponse.access_token))
                    } else {
                        handler(.failure(NetworkError.badTokenType(tokenType)))
                    }
                } catch {
                    handler(.failure(error))
                    return
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
        
        task.resume()
    }
}

// MARK: - Extensions + Internal Requests
extension OAuth2Service {
    func getUserAuthRequest() -> URLRequest? {
        guard
            var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthporizeURLString)
        else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
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
        guard let baseURL = Constants.defaultBaseURL else { return nil }
        guard let url = URL(
            string: "oauth/token/"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
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
