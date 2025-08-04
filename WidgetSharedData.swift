// WidgetSharedData.swift

import Foundation

struct WidgetSharedData {
    private static let suiteName = "group.com.liadaltif.DailyQuotes"
    private static let globalKey = "currentQuote"

    private static var defaults: UserDefaults? {
        let ud = UserDefaults(suiteName: suiteName)
        if ud == nil {
            print("⚠️ [WidgetSharedData] ⚠️ UserDefaults(suiteName:\(suiteName)) is nil")
        }
        return ud
    }

    static func save(_ quote: String) {
        guard let ud = defaults else { return }
        ud.set(quote, forKey: globalKey)
        print("🐛 [WidgetSharedData] Saved “\(quote)” as global quote")
    }

    static func load() -> String? {
        guard let ud = defaults else { return nil }
        let q = ud.string(forKey: globalKey)
        print("🐛 [WidgetSharedData] Loaded “\(q ?? "nil")” from global quote")
        return q
    }
}
