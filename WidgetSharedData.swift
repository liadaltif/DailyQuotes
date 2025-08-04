import Foundation
import AppIntents

struct WidgetSharedData {
    static let appGroupID = "group.com.liadaltif.DailyQuotes"

    static func save(_ quote: String, for option: QuoteOption) {
        UserDefaults(suiteName: appGroupID)?
            .set(quote, forKey: option.rawValue)
    }

    static func load(for option: QuoteOption) -> String {
        UserDefaults(suiteName: appGroupID)?
            .string(forKey: option.rawValue)
            ?? option.rawValue
    }
}
