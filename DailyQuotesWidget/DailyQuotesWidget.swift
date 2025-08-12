import WidgetKit
import SwiftUI

struct DailyQuotesWidget: Widget {
    let kind: String = "DailyQuotesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DailyQuotesWidgetView(entry: entry)
        }
        .configurationDisplayName("Daily Quotes")
        .description("Shows a background image from the app group container.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

