import WidgetKit
import SwiftUI

// MARK: – Your timeline entry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let quote: String
}

// MARK: – Your provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now, quote: "📖 ציטוט לדוגמה")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let text = WidgetSharedData.load() ?? QuoteOption.tzedek.rawValue
        completion(.init(date: .now, quote: text))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let text = WidgetSharedData.load() ?? QuoteOption.tzedek.rawValue
        let entry = SimpleEntry(date: .now, quote: text)
        completion(.init(entries: [entry], policy: .never))
    }
}

// MARK: – Your SwiftUI view
struct DailyQuotesWidgetEntryView: View {
    let entry: SimpleEntry

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

// MARK: – Your widget configuration (NO @main here!)
struct DailyQuotesWidget: Widget {
    let kind: String = "DailyQuotesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DailyQuotesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("ציטוט יומי")
        .description("הצג ציטוט מעורר השראה")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
