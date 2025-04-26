import Foundation

extension URLSession {

    func dataTaskResult(
        for urlRequest: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnMainThread: (Result<Data, Error>)  -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: urlRequest) { data, response, error in
            
            if let error {
                fulfillCompletionOnMainThread(.failure(NetworkError.urlRequestError(error)))
                return
            }
            
            guard
                let data,
                let response = response as? HTTPURLResponse
            else {
                fulfillCompletionOnMainThread(.failure(NetworkError.urlSessionError))
                return
            }
                                              
            if 200..<300 ~= response.statusCode {
                fulfillCompletionOnMainThread(.success(data))
            } else {
                fulfillCompletionOnMainThread(.failure(NetworkError.httpStatusCode(response.statusCode)))
            }
        }
        
        return task
    }
}
