import Foundation

enum TehillimService {
    static func fetchRandomVerse() async -> String {
        let chapter = Int.random(in: 1...150)
        let urlString = "https://www.sefaria.org/api/texts/Psalms.\(chapter)?lang=he"
        guard let url = URL(string: urlString) else {
            return "שגיאה: כתובת URL שגויה"
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let verses = json["he"] as? [String], !verses.isEmpty {
                let index = Int.random(in: 0..<verses.count)
                let text = cleanHTML(verses[index])
                return "תהלים \(chapter):\(index + 1) - \(text)"
            } else {
                return "שגיאה: לא נמצאו פסוקים"
            }
        } catch {
            return "שגיאה: \(error.localizedDescription)"
        }
    }

    private static func cleanHTML(_ html: String) -> String {
        var cleaned = html
        cleaned = cleaned.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: "&nbsp;", with: " ")
        cleaned = cleaned.replacingOccurrences(of: "&quot;", with: "\"")
        cleaned = cleaned.replacingOccurrences(of: "&lt;", with: "<")
        cleaned = cleaned.replacingOccurrences(of: "&gt;", with: ">")
        cleaned = cleaned.replacingOccurrences(of: "&amp;", with: "&")
        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
