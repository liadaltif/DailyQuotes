import SwiftUI
import WidgetKit

struct MyWidgetView: View {
    var entry: Provider.Entry

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

@main
struct MyWidget: Widget {
    let kind: String = "MyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MyWidgetView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("Shows a background image from the app group container.")
    }
}
