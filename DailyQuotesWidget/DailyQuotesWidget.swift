import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let verse: String
    let profile: NewWidgetProfile
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        let sample = NewWidgetProfile(name: "דוגמה", textColor: CodableColor(.primary), backgroundColor: CodableColor(.white), backgroundImages: nil, textSize: .medium, rotation: 1)
        return SimpleEntry(date: .now, verse: "פסוק לדוגמה", profile: sample)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let verse = await NewTehillimService.fetchRandomVerse()
        let profile = configuration.profile?.profile ?? NewWidgetProfile(name: "ברירת מחדל", textColor: CodableColor(.primary), backgroundColor: CodableColor(.white), backgroundImages: nil, textSize: .medium, rotation: 1)
        return SimpleEntry(date: .now, verse: verse, profile: profile)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let profile = configuration.profile?.profile ?? NewWidgetProfile(name: "ברירת מחדל", textColor: CodableColor(.primary), backgroundColor: CodableColor(.white), backgroundImages: nil, textSize: .medium, rotation: 1)
        let rotations = max(profile.rotation, 1)
        let interval: TimeInterval = 86400 / Double(rotations)
        var entries: [SimpleEntry] = []
        let currentDate = Date()

        for i in 0..<rotations {
            let verse = await NewTehillimService.fetchRandomVerse()
            let entryDate = currentDate.addingTimeInterval(Double(i) * interval)
            entries.append(SimpleEntry(date: entryDate, verse: verse, profile: profile))
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct DailyQuotesWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
         ZStack {
            if let images = entry.profile.backgroundImages, !images.isEmpty {
                TabView {
                    ForEach(images, id: \.self) { name in
                        Image(name)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                    }
                }
                .tabViewStyle(PageTabViewStyle())
            } else {
                entry.profile.backgroundColor.color
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(entry.verse)
                    .font(.system(size: entry.profile.textSize.size))
                    .foregroundColor(entry.profile.textColor.color)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
        }
        .containerBackground(.clear, for: .widget)
    }
}

struct DailyQuotesWidget: Widget {
    let kind: String = "DailyQuotesWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            DailyQuotesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("פסוק יומי")
        .description("הצג פסוק מתהילים לפי פרופיל")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
