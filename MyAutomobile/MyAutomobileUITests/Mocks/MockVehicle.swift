import SwiftUI

struct MockVehicle {
    let plate: String
    let locationInfo: String // state or region
    let make: String
    let model: String
    let colorHex: String

    var displayName: String {
        "\(make) \(model)"
    }

    var fullDescription: String {
        "\(make) \(model) (\(plate))"
    }

    // Convert hex color to SwiftUI Color for actual app usage if needed
    var color: Color {
        Color(hex: colorHex) ?? .gray
    }
}

private extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
