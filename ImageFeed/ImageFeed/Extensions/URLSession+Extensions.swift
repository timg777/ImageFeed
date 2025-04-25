import Foundation

extension URLSession {
    func data(
        for urlRequest: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulFillCompletionOnMainThread: (Result<Data, Error>)  -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: urlRequest) { data, response, error in
            if
                let data,
                let response,
                let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200..<300 ~= statusCode {
                    fulFillCompletionOnMainThread(.success(data))
                } else {
                    fulFillCompletionOnMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error {
                fulFillCompletionOnMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulFillCompletionOnMainThread(.failure(NetworkError.urlSessionError))
            }
        }
        
        return task
    }
}
