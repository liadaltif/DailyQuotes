import WidgetKit
import AppIntents
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let quote: String
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now, quote: "📖 ציטוט לדוגמה")
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) -> SimpleEntry {
        let quote = WidgetSharedData.load(for: configuration.selectedQuote)
        return SimpleEntry(date: .now, quote: quote)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let quote = WidgetSharedData.load(for: configuration.selectedQuote)
        let entry = SimpleEntry(date: .now, quote: quote)
        return Timeline(entries: [entry], policy: .never)
    }
}

struct DailyQuotesWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("🕊️ ציטוט יומי")
                .font(.caption)
                .foregroundColor(.secondary)

            Text("“\(entry.quote)”")
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

@main
struct DailyQuotesWidget: Widget {
    let kind = "DailyQuotesWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            DailyQuotesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("ציטוט יומי")
        .description("הצג ציטוט מעורר השראה")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
