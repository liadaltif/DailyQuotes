import SwiftUI

struct WidgetPreviewCard: View {
    let quote: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(radius: 4)

            Text("“\(quote)”")
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(height: 140)
    }
}
