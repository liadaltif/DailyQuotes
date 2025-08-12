//
//  NewProfileEntity 2.swift
//  DailyQuotes
//
//  Created by Liad Altif on 06/08/2025.
//


import AppIntents
import SwiftUI

struct NewProfileEntity: AppEntity, Identifiable {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Profile")
    static var defaultQuery = NewProfileEntityQuery()

    let id: UUID
    let name: String
    let textColor: CodableColor
    let backgroundColor: CodableColor
    let backgroundImages: [String]?
    let textSize: NewWidgetProfile.TextSize
    let rotation: Int

    init(profile: NewWidgetProfile) {
        self.id = profile.id
        self.name = profile.name
        self.textColor = profile.textColor
        self.backgroundColor = profile.backgroundColor
        self.backgroundImages = profile.backgroundImages
        self.textSize = profile.textSize
        self.rotation = profile.rotation
    }

    var profile: NewWidgetProfile {
        NewWidgetProfile(id: id, name: name, textColor: textColor, backgroundColor: backgroundColor, backgroundImages: backgroundImages, textSize: textSize, rotation: rotation)
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
