import SwiftUI
import AppIntents
import WidgetKit

struct WidgetSelectionView: View {
    private let quotes = QuoteOption.allCases

    @State private var showSheet = false
    @State private var selected: QuoteOption?
    @State private var widgetQuote: QuoteOption?

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 160), spacing: 16)],
                    spacing: 16
                ) {
                    ForEach(quotes, id: \.self) { quote in
                        Button {
                            selected = quote
                            showSheet = true
                        } label: {
                            WidgetPreviewCard(quote: quote.rawValue)
                        }
                    }
                }
                .padding()
                .navigationTitle("בחר ציטוט לווידג'ט")
            }
        }
        .onContinueUserActivity(ConfigurationAppIntent.self) { intent in
            widgetQuote = intent.selectedQuote
        }
        .sheet(isPresented: $showSheet) {
            VStack(spacing: 20) {
                Text("להוסיף / לעדכן את הווידג'ט?")
                    .font(.title2)
                    .multilineTextAlignment(.center)

                Text("השינוי יחול על הווידג'ט שנפתח.")
                    .multilineTextAlignment(.center)

                Button("עדכן") {
                    if let selected {
                        let target = widgetQuote ?? selected
                        WidgetSharedData.save(selected.rawValue, for: target)
                        WidgetCenter.shared.reloadTimelines(ofKind: "DailyQuotesWidget")
                    }
                    showSheet = false
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
