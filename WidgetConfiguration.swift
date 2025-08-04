import Foundation

struct WidgetConfiguration {
    static let appGroup = "group.com.yourname.DailyQuotes" // Replace with your actual App Group ID
    static let widgetTypeKey = "selectedWidgetType"

    static func save(widgetType: WidgetType) {
        let defaults = UserDefaults(suiteName: appGroup)
        defaults?.set(widgetType.rawValue, forKey: widgetTypeKey)
    }

    static func getSelectedType() -> WidgetType {
        let defaults = UserDefaults(suiteName: appGroup)
        let raw = defaults?.string(forKey: widgetTypeKey) ?? WidgetType.quoteOfTheDay.rawValue
        return WidgetType(rawValue: raw) ?? .quoteOfTheDay
    }
}
