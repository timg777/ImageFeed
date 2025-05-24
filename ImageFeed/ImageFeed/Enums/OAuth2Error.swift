enum OAuth2Error: TracedError {
    case authenticationFailed
    case duplicateOAuthRequest
    case invalidRequest
    case invalidTokenType(String)
    
    var description: String {
        switch self {
        case .authenticationFailed:
            return "OAuth2Error - не удалось аутентифицировать пользователя"
        case .invalidRequest:
            return "OAuth2Error - не удалось создать запрос"
        case .duplicateOAuthRequest:
            return "OAuth2Error - попытка повторного запроса токена"
        case .invalidTokenType(let type):
            return "OAuth2Error - невалидный тип токена: \(type)."
        }
    }
}
