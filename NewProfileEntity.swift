//
//  ProfileEntity 2.swift
//  DailyQuotes
//
//  Created by Liad Altif on 06/08/2025.
//


import AppIntents
import SwiftUI

struct ProfileEntity: AppEntity, Identifiable {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Profile")
    static var defaultQuery = ProfileEntityQuery()

    let id: UUID
    let name: String
    let color: CodableColor
    let textSize: Double

    init(profile: NewWidgetProfile) {
        self.id = profile.id
        self.name = profile.name
        self.color = profile.color
        self.textSize = profile.textSize
    }

    var profile: NewWidgetProfile {
        NewWidgetProfile(id: id, name: name, color: color, textSize: textSize)
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
