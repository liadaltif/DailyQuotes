import SwiftUI
import AppIntents
import WidgetKit

struct WidgetSelectionView: View {
    private let quotes = QuoteOption.allCases

    @State private var showSheet = false
    @State private var selected: QuoteOption?

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
        .sheet(isPresented: $showSheet) {
            VStack(spacing: 20) {
                Text("להוסיף / לעדכן את הווידג'ט?")
                    .font(.title2)
                    .multilineTextAlignment(.center)

                Text("השינוי יחול על הווידג'טים שמוגדרים עם הציטוט שנבחר.")
                    .multilineTextAlignment(.center)

                Button("עדכן") {
                    if let selected {
                        WidgetSharedData.save(selected.rawValue, for: selected)
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
