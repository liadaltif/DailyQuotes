import WidgetKit
import SwiftUI

struct DailyQuotesWidget: Widget {
    let kind: String = "DailyQuotesWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            DailyQuotesWidgetView(entry: entry)
        }
        .configurationDisplayName("Daily Quotes")
        .description("Displays the selected quote.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

