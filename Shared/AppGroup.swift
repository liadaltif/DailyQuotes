import Foundation

enum AppGroup {
    static let id = "group.com.liadaltif.DailyQuotes"

    /// Location of the background image shared via the app group.
    static func sharedBackgroundURL() -> URL? {
        FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: id)?
            .appendingPathComponent("background.jpg")
    }
}
