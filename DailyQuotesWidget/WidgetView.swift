import SwiftUI
import WidgetKit

struct DailyQuotesWidgetView: View {
    var entry: BackgroundEntry

    var body: some View {
        ZStack {
            if let url = entry.backgroundURL,
               let uiImage = UIImage(contentsOfFile: url.path) {
               Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } else {
                Color.black.opacity(0.2)
            }
        }
        .ignoresSafeArea()
        .applyWidgetBackground()
    }
}

private extension View {
    @ViewBuilder
    func applyWidgetBackground() -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            self.containerBackground(for: .widget) { Color.clear }
        } else {
            self
        }

    }
}
