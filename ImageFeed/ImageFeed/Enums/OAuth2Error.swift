enum OAuth2Error: Error {
    case invalidURLString
    
    case badRequest
    case badResponse
    
    case authenticationFailed
    case noResource
    case serverError
    
    case noCodeField
    
    case unknown
}
