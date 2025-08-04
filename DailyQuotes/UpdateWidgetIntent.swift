import AppIntents
import WidgetKit

struct UpdateWidgetIntent: AppIntent {
    static var title: LocalizedStringResource = "עדכון וידג'ט"

    // ← Change this from IntentParameter<QuoteOption> to just QuoteOption:
    @Parameter(title: "ציטוט")
    var selectedQuote: QuoteOption

    static var openAppWhenRun = false

    func perform() async throws -> some IntentResult {
        // This reloads all AppIntent‐driven widget timelines
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
