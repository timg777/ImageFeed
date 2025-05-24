enum ParseError: TracedError {
    case decodeError(T: Any.Type)
    
    var description: String {
        switch self {
        case .decodeError(let T):
            "ParseError - ошибка декодирование типа: \(T)"
        }
    }
}
