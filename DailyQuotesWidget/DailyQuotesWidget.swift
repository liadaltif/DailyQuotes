import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let verse: String
    let profile: WidgetProfile
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        let sample = WidgetProfile(name: "דוגמה", color: CodableColor(.primary), textSize: 16)
        return SimpleEntry(date: .now, verse: "פסוק לדוגמה", profile: sample)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let verse = await TehillimService.fetchRandomVerse()
        let profile = configuration.profile?.profile ?? WidgetProfile(name: "ברירת מחדל", color: CodableColor(.primary), textSize: 16)
        return SimpleEntry(date: .now, verse: verse, profile: profile)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let verse = await TehillimService.fetchRandomVerse()
        let profile = configuration.profile?.profile ?? WidgetProfile(name: "ברירת מחדל", color: CodableColor(.primary), textSize: 16)
        let entry = SimpleEntry(date: .now, verse: verse, profile: profile)
        return Timeline(entries: [entry], policy: .never)
    }
}

struct DailyQuotesWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(entry.verse)
                .font(.system(size: CGFloat(entry.profile.textSize)))
                .foregroundColor(entry.profile.color.color)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct DailyQuotesWidget: Widget {
    let kind: String = "DailyQuotesWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            DailyQuotesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("פסוק יומי")
        .description("הצג פסוק מתהילים לפי פרופיל")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
