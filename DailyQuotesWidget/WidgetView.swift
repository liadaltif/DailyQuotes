import SwiftUI
import WidgetKit

struct DailyQuotesWidgetView: View {
    var entry: BackgroundEntry

    var body: some View {
        Text(entry.quote)
            .foregroundColor(entry.profile?.isDarkMode ?? false ? .white : .black)
            .multilineTextAlignment(.center)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background((entry.profile?.isDarkMode ?? false ? Color.black : Color.white))
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
