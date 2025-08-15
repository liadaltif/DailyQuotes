// WidgetSelectionView.swift

import SwiftUI
import WidgetKit

struct WidgetSelectionView: View {
    private let quotes = QuoteOption.allCases

    @State private var showSheet = false
    @State private var selected: QuoteOption?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 16)], spacing: 16) {
                    ForEach(quotes, id: \.self) { quote in
                        Button {
                            selected = quote
                            showSheet = true
                            print("🐛 [App] tapped preview for “\(quote.rawValue)”")
                        } label: {
                            WidgetPreviewCard(quote: quote.rawValue)
                        }
                    }
                }
                .padding()
                .navigationTitle("בחר ציטוט לווידג'ט")
            }
        }
        // deep-link from your .widgetURL(...)
        .onOpenURL { url in
            guard url.scheme == "dailyquotes", url.host == "configure" else { return }
            // Pre‐load the current quote so the user sees it in the sheet
            if let raw = WidgetSharedData.load(),
               let existing = QuoteOption(rawValue: raw) {
                selected = existing
            } else {
                selected = .tzedek
            }
            showSheet = true
            print("🐛 [App] onOpenURL → showing sheet with selected = \(selected!.rawValue)")
        }
        .sheet(isPresented: $showSheet) {
            VStack(spacing: 20) {
                Text("להוסיף / לעדכן את הווידג'ט?")
                    .font(.title2)
                    .multilineTextAlignment(.center)

                // show current selection
                if let sel = selected {
                    Text("הציטוט הנוכחי הוא:\n“\(sel.rawValue)”")
                        .multilineTextAlignment(.center)
                }

                Button("עדכן") {
                    guard let newQuote = selected else { return }
                    print("🐛 [App] saving new quote “\(newQuote.rawValue)”")
                    WidgetSharedData.save(newQuote.rawValue)
                    WidgetCenter.shared.reloadTimelines(ofKind: "DailyQuotesWidget")
                    showSheet = false
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
