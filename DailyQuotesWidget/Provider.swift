import WidgetKit
import SwiftUI


struct BackgroundEntry: TimelineEntry {
    let date: Date
    let backgroundURL: URL?
    let quote: String
    let profile: NewWidgetProfile?
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> BackgroundEntry {
        BackgroundEntry(date: Date(),
                        backgroundURL: loadBackgroundURL(),
                        quote: "Quote",
                        profile: nil)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) -> BackgroundEntry {
        entry(for: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<BackgroundEntry> {
        let profile = configuration.profile?.profile
        let backgroundURL = loadBackgroundURL()
        var quote = WidgetSharedData.load()
        if quote == nil {
            print("Provider: no saved quote found, fetching random Tehillim verse")
            quote = await NewTehillimService.fetchRandomVerse()
        }
        let entry = BackgroundEntry(date: Date(),
                                   backgroundURL: backgroundURL,
                                   quote: quote ?? "Add a quote in the app",
                                   profile: profile)
        return Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600)))
    }

    private func entry(for configuration: ConfigurationAppIntent) -> BackgroundEntry {
        let profile = configuration.profile?.profile
        let quote = WidgetSharedData.load() ?? "Add a quote in the app"
        return BackgroundEntry(date: Date(),
                               backgroundURL: loadBackgroundURL(),
                               quote: quote,
                               profile: profile)
    }

    private func loadBackgroundURL() -> URL? {
        guard let url = AppGroup.sharedBackgroundURL(),
            FileManager.default.fileExists(atPath: url.path) else {
            print("Provider: background image missing at \(AppGroup.sharedBackgroundURL()?.path ?? "nil")")
            return nil
        }
        print("Provider: using background at", url.path)
        return url
    }

}

