import AppIntents
import WidgetKit

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "הגדר את הווידג'ט"
    
    @Parameter(title: "בחר ציטוט")
    var selectedQuote: QuoteOption?
}

struct UpdateWidgetIntent: AppIntent {
    static var title: LocalizedStringResource = "Update Widget Quote"
    
    @Parameter(title: "New Quote")
    var selectedQuote: QuoteOption
    
    static var openAppWhenRun: Bool = false
    
    func perform() async throws -> some IntentResult {
        // Save the selected quote to shared UserDefaults
        WidgetSharedData.saveQuote(selectedQuote.rawValue)
        
        // Reload all widgets to show the new quote
        WidgetCenter.shared.reloadAllTimelines()
        
        return .result()
    }
}
