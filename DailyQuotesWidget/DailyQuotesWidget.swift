import WidgetKit
import SwiftUI

struct DailyQuotesWidget: Widget {
    let kind: String = "DailyQuotesWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            DailyQuotesWidgetView(entry: entry)
        }
        .configurationDisplayName("Daily Quotes")
        .description("Displays the selected quote over a background image.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

