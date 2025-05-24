import Foundation

extension Date {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: GlobalNamespace.localizationIdentifier)
        return formatter
    }
    
    func convertToDate(with ISOStandartString: String) -> Date? {
        dateFormatter.date(from: ISOStandartString)
    }
    
    func convertToString() -> String {
        dateFormatter.string(
            from: self
        ).replacingOccurrences(
            of: "г.",
            with: ""
        )
    }
}
