import AppIntents
import WidgetKit

struct UpdateWidgetIntent: AppIntent {
    static var title: LocalizedStringResource = "עדכון וידג'ט"

    @Parameter(title: "ציטוט")
    var selectedQuote: QuoteOption

    static var openAppWhenRun = false

    func perform() async throws -> some IntentResult {
        WidgetSharedData.save(selectedQuote.rawValue, for: selectedQuote)
        WidgetCenter.shared.reloadTimelines(ofKind: "DailyQuotesWidget")
        return .result()
    }
}
