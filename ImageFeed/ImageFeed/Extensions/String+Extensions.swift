import Foundation

// MARK: - Extensions + Internal String date correct format computed property
extension String {
    var correctDateFormat: Self? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH-mm-ssZ"
        
        guard
            let date = dateFormatter.date(from: self)
        else {
            return nil
        }
        
        dateFormatter.dateFormat = "d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        return dateFormatter.string(from: date)
    }
}
