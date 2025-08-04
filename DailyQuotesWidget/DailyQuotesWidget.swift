import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let quote: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now, quote: "📖 ציטוט לדוגמה")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(SimpleEntry(date: .now, quote: WidgetSharedData.load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let entry = SimpleEntry(date: .now, quote: WidgetSharedData.load())
        completion(Timeline(entries: [entry], policy: .never))
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
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DailyQuotesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("ציטוט יומי")
        .description("הצג ציטוט מעורר השראה")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
