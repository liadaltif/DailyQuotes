import Foundation
import SwiftUI
import WidgetKit


private let appGroupID = "group.com.liadaltif.DailyQuotes"

private func sharedBackgroundURL() -> URL? {
    FileManager.default
        .containerURL(forSecurityApplicationGroupIdentifier: appGroupID)?
        .appendingPathComponent("WidgetImages/background.jpg")
}

// MARK: - Timeline

struct BackgroundEntry: TimelineEntry {
    let date: Date
    let backgroundURL: URL?
}

struct BackgroundImageProvider: TimelineProvider {
    func placeholder(in context: Context) -> BackgroundEntry {
        BackgroundEntry(date: .now, backgroundURL: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (BackgroundEntry) -> Void) {
        completion(BackgroundEntry(date: .now, backgroundURL: sharedBackgroundURL()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BackgroundEntry>) -> Void) {
        let entry = BackgroundEntry(date: .now, backgroundURL: sharedBackgroundURL())
        // Use .never if you only refresh when the app saves a new image + reloads timelines.
        completion(Timeline(entries: [entry], policy: .never))
    }
}
