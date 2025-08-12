import SwiftUI
import WidgetKit

struct DailyQuotesWidgetView: View {
    var entry: BackgroundEntry

    var body: some View {
        ZStack {
            if let names = entry.profile?.backgroundImages,
               let random = names.randomElement() {
                Image(random)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
            } else if let url = entry.backgroundURL,
                      let uiImage = UIImage(contentsOfFile: url.path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
            } else {
                (entry.profile?.backgroundColor.color ?? Color.black.opacity(0.2))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            Text(entry.quote)
                .font(.system(size: entry.profile?.textSize.size ?? 16))
                .foregroundColor(entry.profile?.textColor.color ?? .white)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
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
