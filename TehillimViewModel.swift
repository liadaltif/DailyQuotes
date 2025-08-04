//
//  TehillimViewModel.swift
//  DailyQuotes
//
//  Created by Liad Altif on 06/08/2025.
//


import Foundation

@MainActor
class TehillimViewModel: ObservableObject {
    @Published var verse: String = "לחץ לקבל פסוק אקראי"

    func getRandomVerse() {
        let chapter = Int.random(in: 1...150)
        let urlString = "https://www.sefaria.org/api/texts/Psalms.\(chapter)?lang=he"

        guard let url = URL(string: urlString) else {
            verse = "שגיאה: כתובת URL שגויה"
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let verses = json["he"] as? [String], !verses.isEmpty {
                    
                    let index = Int.random(in: 0..<verses.count)
                    let text = cleanHTML(verses[index])
                    verse = "תהלים \(chapter):\(index + 1) - \(text)"
                } else {
                    verse = "שגיאה: לא נמצאו פסוקים"
                }
            } catch {
                verse = "שגיאה: \(error.localizedDescription)"
            }
        }
    }

    private func cleanHTML(_ html: String) -> String {
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
