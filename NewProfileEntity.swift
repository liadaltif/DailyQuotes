//
//  NewProfileEntity 2.swift
//  DailyQuotes
//
//  Created by Liad Altif on 06/08/2025.
//


import AppIntents

struct NewProfileEntity: AppEntity, Identifiable {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Profile")
    static var defaultQuery = NewProfileEntityQuery()

    let id: UUID
    let name: String
    let isDarkMode: Bool
    let versesPerDay: Int

    init(profile: NewWidgetProfile) {
        self.id = profile.id
        self.name = profile.name
        self.isDarkMode = profile.isDarkMode
        self.versesPerDay = profile.versesPerDay
    }

    var profile: NewWidgetProfile {
        NewWidgetProfile(id: id, name: name, isDarkMode: isDarkMode, versesPerDay: versesPerDay)
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}

struct NewProfileEntityQuery: EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [NewProfileEntity] {
        let profiles = NewProfileManager.load().map(NewProfileEntity.init)
        return profiles.filter { identifiers.contains($0.id) }
    }

    func suggestedEntities() async throws -> [NewProfileEntity] {
        NewProfileManager.load().map(NewProfileEntity.init)
    }
}
