import AppIntents
import WidgetKit

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "הגדר את הווידג'ט"

    @Parameter(title: "בחר ציטוט")
    var selectedQuote: QuoteOption?
}
