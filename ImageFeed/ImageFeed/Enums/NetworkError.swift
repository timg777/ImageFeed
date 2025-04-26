enum NetworkError: Error {
    case invalidRequest
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case badTokenType(String)
}
