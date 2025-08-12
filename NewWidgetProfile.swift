import SwiftUI
import UIKit

struct CodableColor: Codable, Hashable {
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double

    init(_ color: Color) {
        let ui = UIColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        ui.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.red = Double(r)
        self.green = Double(g)
        self.blue = Double(b)
        self.opacity = Double(a)
    }

    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}

struct NewWidgetProfile: Identifiable, Codable, Hashable {
    enum TextSize: String, Codable, CaseIterable, Hashable {
        case small
        case medium
        case large

        var size: CGFloat {
            switch self {
            case .small: return 14
            case .medium: return 18
            case .large: return 24
            }
        }
    }

    var id: UUID = UUID()
    var name: String
    var textColor: CodableColor
    var backgroundColor: CodableColor
    var textSize: TextSize
    var rotation: Int
}
