import WidgetKit
import SwiftUI

struct BackgroundEntry: TimelineEntry {
    let date: Date
    let quote: String
    let profile: NewWidgetProfile?
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> BackgroundEntry {
        BackgroundEntry(date: Date(),
                        quote: "Quote",
                        profile: nil)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) -> BackgroundEntry {
        entry(for: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<BackgroundEntry> {
        let profile = configuration.profile?.profile
        var quote = WidgetSharedData.load()
        if quote == nil {
            print("Provider: no saved quote found, fetching random Tehillim verse")
            quote = await NewTehillimService.fetchRandomVerse()
        }
        let entry = BackgroundEntry(date: Date(),
                                   quote: quote ?? "Add a quote in the app",
                                   profile: profile)
        return Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600)))
    }

    private func entry(for configuration: ConfigurationAppIntent) -> BackgroundEntry {
        let profile = configuration.profile?.profile
        let quote = WidgetSharedData.load() ?? "Add a quote in the app"
        return BackgroundEntry(date: Date(),
                               quote: quote,
                               profile: profile)
    }
}
