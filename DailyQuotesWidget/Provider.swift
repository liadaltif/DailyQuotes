import WidgetKit
import SwiftUI

struct Entry: TimelineEntry {
    let date: Date
    let backgroundURL: URL?
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), backgroundURL: loadBackgroundURL())
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = Entry(date: Date(), backgroundURL: loadBackgroundURL())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = Entry(date: Date(), backgroundURL: loadBackgroundURL())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    private func loadBackgroundURL() -> URL? {
        guard let url = sharedBackgroundURL(),
              FileManager.default.fileExists(atPath: url.path) else {
            print("Provider: background image missing at \(sharedBackgroundURL()?.path ?? "nil")")
            return nil
        }
        print("Provider: using background at", url.path)
        return url
    }
}
