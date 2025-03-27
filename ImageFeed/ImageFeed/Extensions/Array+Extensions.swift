extension Array where Element: Equatable {
    subscript (safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
