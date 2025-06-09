import Foundation

// MARK: - Extensions + Internal URLSession Custom Tasks
extension URLSession {
    
    enum HTTPMethod: String {
        case GET, POST, PUT, DELETE
    }
    
    func objectTask<T: Decodable>(
        for urlRequest: URLRequest,
        handler: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnMainThread: (Result<T, Error>)  -> Void = { result in
            DispatchQueue.main.async {
                handler(result)
            }
        }

        let task = dataTask(with: urlRequest) { data, response, error in
            if let error {
                fulfillCompletionOnMainThread(
                    .failure(NetworkError.urlRequestError(error))
                )
                return
            }
            
            guard
                let data,
                let response = response as? HTTPURLResponse
            else {
                fulfillCompletionOnMainThread(
                    .failure(NetworkError.urlSessionError)
                )
                return
            }
                                              
            guard
                200..<300 ~= response.statusCode
            else {
                fulfillCompletionOnMainThread(
                    .failure(NetworkError.httpStatusCode(response.statusCode))
                )
                return
            }
            
            if let data: T = self.decode(data: data) {
                fulfillCompletionOnMainThread(
                    .success(data)
                )
            } else {
                fulfillCompletionOnMainThread(
                    .failure(ParseError.decodeError(T: T.self))
                )
            }
        }
        
        return task
    }

    func objectTask<T: Decodable>(
        urlString: String,
        httpMethod: HTTPMethod = .GET,
        headerFields: [String: String] = [:],
        parameters: [String: String] = [:],
        handler: @escaping (Result<T, Error>) -> Void
    ) throws -> URLSessionTask {
    
        guard
            let url = parameters.isEmpty ?
                URL(string: urlString) :
                createURL(
                    base: urlString,
                    with: parameters
                )
        else {
            throw NetworkError.invalidURLString
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headerFields
        
        return objectTask(
            for: urlRequest,
            handler: handler
        )
    }
}

// MARK: - Extensions + Fileprivate URLSession Helpers
fileprivate extension URLSession {
    func decode<T: Decodable>(
        data: Data
    ) -> T? {
        let decoder = JSONDecoder()
        return try?
        decoder.decode(
            T.self,
            from: data
        )
    }
    
    func createURL(
        base urlString: String,
        with parameters: [String: String]
    ) -> URL? {
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems =
        parameters.map {
            URLQueryItem(
                name: $0,
                value: $1
            )
        }
        return urlComponents?.url
    }
}
