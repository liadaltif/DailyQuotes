import SwiftUI
import WidgetKit

struct DailyQuotesWidgetView: View {
    var entry: BackgroundEntry

    var body: some View {
        ZStack {
            if let url = entry.backgroundURL,
               let uiImage = UIImage(contentsOfFile: url.path) {
                if #available(iOSApplicationExtension 17.0, *) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .containerBackground(for: .widget) { Color.clear }
                } else {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                }
            } else {
                Color.black.opacity(0.2)
            }
        }
    }
}
