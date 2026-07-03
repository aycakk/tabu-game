import SwiftUI

/// Tasarım tokenları — kaynak: docs/Tabu Akış.html mockup'ı.
enum AppTheme {

    // MARK: - Renkler

    enum Colors {
        static let pageBg = Color(hex: "E7E5DF")
        static let surface = Color(hex: "F4F5FB")
        static let surfaceAlt = Color(hex: "EDEEF4")
        static let card = Color.white

        static let textPrimary = Color(hex: "1F2937")
        static let textMuted = Color(hex: "6B7280")
        static let textOnBrand = Color.white

        static let accent = Color(hex: "00C2A8")

        static let success = Color(hex: "16A34A")
        static let warning = Color(hex: "F59E0B")
        static let danger = Color(hex: "EF4444")
        static let dangerBg = Color(hex: "FEE2E2")

        static let divider = Color(hex: "EEF0F7")
        static let dividerStrong = Color(hex: "E1E3ED")
        static let handle = Color(hex: "D7D9E3")

        static let brandStart = Color(hex: "FF2D78")
        static let brandMid = Color(hex: "FF7A1A")
        static let brandEnd = Color(hex: "FFC53D")
    }

    // MARK: - Takım renkleri

    enum TeamColors {
        /// Kurulum ekranındaki 6 swatch — Team.colorHex bu değerlerden birini alır.
        static let swatches: [String] = [
            "FF5A5F", // kırmızı
            "00C2A8", // teal
            "7C5CFF", // mor
            "FFB400", // amber
            "19A7FF", // mavi
            "FF4FA3", // pembe
        ]

        static let defaultTeam1 = swatches[0]
        static let defaultTeam2 = swatches[1]
    }

    // MARK: - Gradyanlar

    enum Gradients {
        /// Marka gradyanı (Başla butonu, açılış arka planı vb.) — 135°.
        static let brand = LinearGradient(
            colors: [Colors.brandStart, Colors.brandMid, Colors.brandEnd],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        /// Tur ekranlarının arka planı: takım rengi üstten koyulaşarak iner.
        /// Mockup'taki #FF5A5F → #943437 düşüşü kanal başına ×0.58'e denk gelir.
        static func teamBackground(hex: String) -> LinearGradient {
            LinearGradient(
                colors: [Color(hex: hex), darkened(hex: hex, factor: 0.58)],
                startPoint: .top,
                endPoint: .bottom
            )
        }

        /// Kart başlığındaki takım gradyanı (Anlat şeridi) — 135° diyagonal.
        static func teamCardHeader(hex: String) -> LinearGradient {
            LinearGradient(
                colors: [Color(hex: hex), darkened(hex: hex, factor: 0.58)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }

        private static func darkened(hex: String, factor: Double) -> Color {
            let cleaned = hex.replacingOccurrences(of: "#", with: "")
            var rgb: UInt64 = 0
            Scanner(string: cleaned).scanHexInt64(&rgb)
            return Color(
                .sRGB,
                red: Double((rgb & 0xFF0000) >> 16) / 255 * factor,
                green: Double((rgb & 0x00FF00) >> 8) / 255 * factor,
                blue: Double(rgb & 0x0000FF) / 255 * factor,
                opacity: 1
            )
        }
    }

    // MARK: - Tipografi

    enum Fonts {
        // PostScript adları (gwfh static extraction'ı ad ailesini böyle üretiyor;
        // dosyaların içeriği doğru ağırlıklarda).
        private static let fredokaSemiBold = "FredokaLight-SemiBold"
        private static let fredokaBold = "FredokaLight-Bold"
        private static let nunitoSemiBold = "NunitoSans12ptExtraLight12pt-SemiBold"
        private static let nunitoBold = "NunitoSans12ptExtraLight12pt-Bold"
        private static let nunitoExtraBold = "NunitoSans12ptExtraLight12pt-ExtraBold"
        private static let nunitoBlack = "NunitoSans12ptExtraLight12pt-Black"

        /// Başlık ailesi — Fredoka.
        static func fredoka(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
            .custom(weight == .semibold ? fredokaSemiBold : fredokaBold, size: size)
        }

        /// Gövde ailesi — Nunito Sans.
        static func nunitoSans(_ size: CGFloat, weight: Font.Weight = .semibold) -> Font {
            let name: String
            switch weight {
            case .black: name = nunitoBlack
            case .heavy: name = nunitoExtraBold
            case .bold: name = nunitoBold
            default: name = nunitoSemiBold
            }
            return .custom(name, size: size)
        }

        // Semantik roller — mockup'taki kullanım noktaları.
        static let splashTitle = fredoka(96)             // TABU
        static let roundTeamTitle = fredoka(60)          // "Kırmızı Takım" (Sıra Sizde)
        static let cardWord = fredoka(48)                // PLAJ
        static let scoreHuge = fredoka(64)               // +8 puan
        static let scoreBig = fredoka(32)                // skor tablosu rakamı
        static let screenTitle = fredoka(21, weight: .semibold)
        static let button = fredoka(22)
        static let buttonSmall = fredoka(20)
        static let timer = fredoka(24)

        static let body = nunitoSans(16)
        static let bodyBold = nunitoSans(15, weight: .heavy)
        static let caption = nunitoSans(12, weight: .heavy)
        static let overline = nunitoSans(11, weight: .heavy)  // + tracking(1.5)
    }

    // MARK: - Köşe yarıçapları

    enum Corner {
        static let card: CGFloat = 28
        static let button: CGFloat = 22
        static let tile: CGFloat = 18
        static let chip: CGFloat = 14
    }
}
