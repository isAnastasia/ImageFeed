import Foundation

final class DateFormatters {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    static let iSO8601dateFormatter = ISO8601DateFormatter()
}
