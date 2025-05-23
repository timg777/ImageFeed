enum AlertKind {
    case authError
    
    var header: String {
        switch self {
        case .authError:
            "Что-то пошло не так"
        }
    }
    
    var body: String {
        switch self {
        case .authError:
            "Не удалось войти в систему"
        }
    }
    
    var buttonText: String {
        switch self {
        case .authError:
            "Ок"
        }
    }
}
