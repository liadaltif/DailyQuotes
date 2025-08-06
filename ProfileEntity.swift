import AppIntents
import SwiftUI

struct ProfileEntity: AppEntity, Identifiable {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Profile")
    static var defaultQuery = ProfileEntityQuery()

    let id: UUID
    let name: String
    let color: CodableColor
    let textSize: Double

    init(profile: WidgetProfile) {
        self.id = profile.id
        self.name = profile.name
        self.color = profile.color
        self.textSize = profile.textSize
    }

    var profile: WidgetProfile {
        WidgetProfile(id: id, name: name, color: color, textSize: textSize)
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}

struct ProfileEntityQuery: EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [ProfileEntity] {
        let profiles = ProfileManager.load().map(ProfileEntity.init)
        return profiles.filter { identifiers.contains($0.id) }
    }

    func suggestedEntities() async throws -> [ProfileEntity] {
        ProfileManager.load().map(ProfileEntity.init)
    }
}
