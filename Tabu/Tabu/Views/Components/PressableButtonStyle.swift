import SwiftUI

/// Buton basma geri bildirimi — dokunulduğunda hafif küçülme (`AppTheme.Motion.Spring.snappy`).
/// Uygulamadaki hiçbir buton daha önce basma anında hareket etmiyordu, bu ortak stil o boşluğu kapatıyor.
struct PressableButtonStyle: ButtonStyle {
    var scale: CGFloat = 0.96

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .animation(AppTheme.Motion.Spring.snappy, value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PressableButtonStyle {
    /// Standart butonlar (CTA'lar, metin butonları).
    static var pressable: PressableButtonStyle { PressableButtonStyle() }

    /// Küçük dairesel ikon butonları ("✕", chevron) — küçük dokunma alanında
    /// daha belirgin okunması için biraz daha büyük bir sıkışma kullanır.
    static var circularIcon: PressableButtonStyle { PressableButtonStyle(scale: 0.90) }
}
