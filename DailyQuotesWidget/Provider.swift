import WidgetKit
import SwiftUI

struct BackgroundEntry: TimelineEntry {
    let date: Date
    let backgroundURL: URL?
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> BackgroundEntry {
        BackgroundEntry(date: Date(), backgroundURL: loadBackgroundURL())
    }

    func getSnapshot(in context: Context, completion: @escaping (BackgroundEntry) -> ()) {
        let entry = BackgroundEntry(date: Date(), backgroundURL: loadBackgroundURL())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BackgroundEntry>) -> ()) {
        let entry = BackgroundEntry(date: Date(), backgroundURL: loadBackgroundURL())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    private func loadBackgroundURL() -> URL? {
        guard let url = AppGroup.sharedBackgroundURL(),
              FileManager.default.fileExists(atPath: url.path) else {
            print("Provider: background image missing at \(AppGroup.sharedBackgroundURL()?.path ?? \"nil\")")
            return nil
        }
        print("Provider: using background at", url.path)
        return url
    }
}

