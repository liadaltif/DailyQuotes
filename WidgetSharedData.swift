import Foundation
import WidgetKit

struct WidgetSharedData {
    static let appGroupID = "group.com.liadaltif.DailyQuotes"
    static let selectedKey = "SelectedQuote"

    static func save(_ quote: String) {
        UserDefaults(suiteName: appGroupID)?
            .set(quote, forKey: selectedKey)
    }

    static func load() -> String {
        UserDefaults(suiteName: appGroupID)?
            .string(forKey: selectedKey)
            ?? "ברוך הבא לווידג'ט 📖"
    }
}
