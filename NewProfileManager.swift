//
//  ProfileManager 2.swift
//  DailyQuotes
//
//  Created by Liad Altif on 06/08/2025.
//


import Foundation

struct ProfileManager {
    private static let suiteName = "group.com.liadaltif.DailyQuotes"
    private static let key = "profiles"

    private static var defaults: UserDefaults? {
        UserDefaults(suiteName: suiteName)
    }

    static func load() -> [NewWidgetProfile] {
        guard let data = defaults?.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([NewWidgetProfile].self, from: data)) ?? []
    }

    static func save(_ profiles: [NewWidgetProfile]) {
        guard let data = try? JSONEncoder().encode(profiles) else { return }
        defaults?.set(data, forKey: key)
    }
}
