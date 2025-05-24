enum NetworkError: TracedError {
    case invalidURLString
    case invalidRequest
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case repeatedRequest
    
    var description: String {
        switch self {
        case .invalidURLString:
            "NetworkError - неправильно указан строковый URL"
        case .invalidRequest:
            "NetworkError - неправильный запрос"
        case .httpStatusCode(let int):
            "NetworkError - код ошибки \(int)"
        case .urlRequestError(let error):
            "NetworkError - ошибка URLRequest: \(error)"
        case .urlSessionError:
            "NetworkError - ошибка URLSession"
        case .repeatedRequest:
            "NetworkError - повторный запрос"
        }
    }
}
