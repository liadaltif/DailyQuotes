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
                (entry.profile?.backgroundColor.color ?? Color.black.opacity(0.2))
            }

            Text(entry.quote)
                .font(.system(size: entry.profile?.textSize.size ?? 16))
                .foregroundColor(entry.profile?.textColor.color ?? .white)
                .multilineTextAlignment(.center)
                .padding()
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
