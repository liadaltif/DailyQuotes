import SwiftUI
import WidgetKit

struct WidgetSelectionView: View {
    private let quotes = [
        "צדק צדק תרדוף",
        "תן בראש היום!",
        "שקט זה כוח.",
        "הגלים שרים שיר",
        "יאללה, מתחילים 😄"
    ]

    @State private var showSheet = false
    @State private var selected = ""

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
                            WidgetPreviewCard(quote: quote)
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

                Text("השינוי יחול על כל העתקי הווידג'ט במכשיר.")
                    .multilineTextAlignment(.center)

                Button("עדכן") {
                    WidgetSharedData.save(selected)
                    WidgetCenter.shared.reloadAllTimelines()
                    showSheet = false
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
