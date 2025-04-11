import UIKit

enum OAuth2Error: Error {
    case invalidURLComponentsString
    case invalidURLString
    
    case badRequest
    case badResponse
    
    case authenticationFailed
    case noResource
    case serverError
    
    case unknown
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
}

extension OAuth2Service {
    func fetchOAuthToken(code: String, _ handler: @escaping (Result<String, Error>) -> Void) {
        
        guard
            let request = buildURLRequest()
        else {
            handler(.failure(OAuth2Error.invalidURLString))
        }
        let task = URLSession.shared.dataTask(with: request)
        
        switch getStatusCode(from: task.response) {
        case 200:
            handler(.success())
        case 401:
            handler(.failure(OAuth2Error.authenticationFailed))
        case 404:
            handler(.failure(OAuth2Error.noResource))
        case 500:
            handler(.failure(OAuth2Error.serverError))
        default:
            handler(.failure(OAuth2Error.unknown))
        }
        
        task.resume()
    }
    
    private func buildURLRequest() -> URLRequest? {
        guard
            var urlComponents = URLComponents(string: "https://github.com/login/oauth/access_token")
        else {
            return .failure(OAuth2Error.invalidURLComponentsString)
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey)
        ]
        
        guard
            let URL = urlComponents.url
        else {
            return .failure(OAuth2Error.invalidURLString)
        }
        
        return .success(URLRequest(url: URL))
    }
    
    private func getStatusCode(from response: URLResponse?) -> Int? {
        (response as? HTTPURLResponse)?.statusCode
    }
}
