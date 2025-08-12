import Foundation

struct NewWidgetProfile: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var backgroundImage: String?
    var isDarkMode: Bool
    var versesPerDay: Int
}
