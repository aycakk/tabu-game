import SwiftUI

/// Oyun ekranındaki Pas / Tabu / Doğru butonları için ortak stil.
/// `subtitle` verilirse iki satırlı (Pas/Tabu), verilmezse tek satır + glyph (Doğru).
struct ActionButton: View {
    var title: String
    var subtitle: String? = nil
    var glyph: String? = nil
    var backgroundColor: Color
    var shadowColor: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            content
                .frame(maxWidth: .infinity)
                .padding(.vertical, subtitle == nil ? 17 : 13)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.button))
                .shadow(color: shadowColor, radius: 14, y: 8)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(subtitle.map { "\(title), \($0)" } ?? title)
        .accessibilityAddTraits(.isButton)
    }

    @ViewBuilder
    private var content: some View {
        if let subtitle {
            VStack(spacing: 3) {
                Text(title)
                    .font(AppTheme.Fonts.buttonSmall)
                Text(subtitle)
                    .font(AppTheme.Fonts.caption)
                    .opacity(0.9)
            }
            .foregroundStyle(AppTheme.Colors.textOnBrand)
        } else {
            HStack(spacing: 10) {
                if let glyph {
                    Text(glyph)
                        .font(.system(size: 22, weight: .black))
                }
                Text(title)
                    .font(AppTheme.Fonts.button)
            }
            .foregroundStyle(AppTheme.Colors.textOnBrand)
        }
    }
}

#Preview {
    VStack(spacing: 10) {
        HStack(spacing: 10) {
            ActionButton(
                title: "Pas",
                subtitle: "2 kaldı",
                backgroundColor: AppTheme.Colors.warning,
                shadowColor: AppTheme.Colors.warning.opacity(0.6),
                action: {}
            )
            ActionButton(
                title: "Tabu",
                subtitle: "−1 puan",
                backgroundColor: AppTheme.Colors.danger,
                shadowColor: AppTheme.Colors.danger.opacity(0.6),
                action: {}
            )
        }
        ActionButton(
            title: "Doğru",
            glyph: "✓",
            backgroundColor: AppTheme.Colors.success,
            shadowColor: AppTheme.Colors.success.opacity(0.65),
            action: {}
        )
    }
    .padding(20)
    .background(AppTheme.Colors.pageBg)
}
