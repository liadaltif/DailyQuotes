import Foundation

@MainActor
class TehillimViewModel: ObservableObject {
    @Published var verse: String = "לחץ לקבל פסוק אקראי"

    func getRandomVerse() {
        Task {
            verse = await TehillimService.fetchRandomVerse()
        }
    }
}
