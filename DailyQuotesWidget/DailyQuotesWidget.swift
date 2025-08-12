import WidgetKit
import SwiftUI

struct DailyQuotesWidget: Widget {
    let kind: String = "DailyQuotesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DailyQuotesWidgetView(entry: entry)
        }
        .configurationDisplayName("Daily Quotes")
        .description("Displays a background image from the shared app group container.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

