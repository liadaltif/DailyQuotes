import SwiftUI

@main
struct DailyQuotesApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false

    init() {
        print("🚀 App started")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
            if hasSeenOnboarding {
                ContentView()
            } else {
                OnboardingView()
            }
        }
    }
}