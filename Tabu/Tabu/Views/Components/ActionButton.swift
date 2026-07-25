import SwiftUI

/// Oyun ekranındaki Pas / Tabu / Doğru butonları için ortak stil.
/// `subtitle` verilirse iki satırlı (Pas/Tabu), verilmezse tek satır + glyph (Doğru).
struct ActionButton: View {
    /// Her aksiyonun kendine özgü "punch" hareketini belirler (bkz. punchPhases/scale/xOffset/rotation).
    enum Kind {
        case pass, taboo, correct
    }

    var title: String
    var subtitle: String? = nil
    var glyph: String? = nil
    var backgroundColor: Color
    var shadowColor: Color
    var kind: Kind
    var action: () -> Void

    /// Her tıklamada artırılır — PhaseAnimator bu değişimi görüp fazları baştan oynatır.
    @State private var trigger = 0

    var body: some View {
        Button {
            trigger += 1
            action()
        } label: {
            content
                .frame(maxWidth: .infinity)
                .padding(.vertical, subtitle == nil ? 17 : 13)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.button))
                .shadow(color: shadowColor, radius: 14, y: 8)
        }
        .buttonStyle(.pressable)
        .phaseAnimator(punchPhases, trigger: trigger) { view, phase in
            view
                .scaleEffect(scale(for: phase))
                .offset(x: xOffset(for: phase))
                .rotationEffect(.degrees(rotation(for: phase)))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Corner.button)
                        .fill(.white)
                        .opacity(flashOpacity(for: phase))
                        .allowsHitTesting(false)
                )
        } animation: { _ in
            AppTheme.Motion.Spring.snappy
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(subtitle.map { "\(title), \($0)" } ?? title)
        .accessibilityAddTraits(.isButton)
    }

    /// Fazlar (0 = dinlenme) — kind'e göre kaç adımlı ve ne uzunlukta.
    private var punchPhases: [Int] {
        switch kind {
        case .correct: return [0, 1, 0]
        case .pass: return [0, 1, 2, 0]
        case .taboo: return [0, 1, 2, 3, 0]
        }
    }

    /// Doğru — kısa bir "onay" büyümesi.
    private func scale(for phase: Int) -> CGFloat {
        guard kind == .correct else { return 1 }
        return phase == 1 ? 1.18 : 1.0
    }

    /// Pas — ileri fırlatma hissi veren yatay kayma.
    private func xOffset(for phase: Int) -> CGFloat {
        guard kind == .pass else { return 0 }
        switch phase {
        case 1: return 10
        case 2: return -4
        default: return 0
        }
    }

    /// Tabu — buzzer sallanması.
    private func rotation(for phase: Int) -> Double {
        guard kind == .taboo else { return 0 }
        switch phase {
        case 1: return -5
        case 2: return 5
        case 3: return -3
        default: return 0
        }
    }

    /// Tabu — sallanmayla birlikte sönümlenen kısa kırmızı/beyaz flaş.
    private func flashOpacity(for phase: Int) -> Double {
        guard kind == .taboo else { return 0 }
        switch phase {
        case 1: return 0.35
        case 2: return 0.18
        case 3: return 0.06
        default: return 0
        }
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
                kind: .pass,
                action: {}
            )
            ActionButton(
                title: "Tabu",
                subtitle: "−1 puan",
                backgroundColor: AppTheme.Colors.danger,
                shadowColor: AppTheme.Colors.danger.opacity(0.6),
                kind: .taboo,
                action: {}
            )
        }
        ActionButton(
            title: "Doğru",
            glyph: "✓",
            backgroundColor: AppTheme.Colors.success,
            shadowColor: AppTheme.Colors.success.opacity(0.65),
            kind: .correct,
            action: {}
        )
    }
    .padding(20)
    .background(AppTheme.Colors.pageBg)
}
