import SwiftUI

/// Tek seferlik konfeti animasyonu — Oyun Sonu ekranında kazananı kutlar.
struct ConfettiView: View {
    private struct Piece: Identifiable {
        let id = UUID()
        let color: Color
        let xFraction: CGFloat
        /// Reduce Motion açıkken düşme yerine bu sabit yükseklikte, sadece fade-in ile belirir.
        let restingYFraction: CGFloat
        let size: CGFloat
        let delay: Double
        let duration: Double
        let rotation: Double
    }

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pieces: [Piece] = ConfettiView.makePieces()
    @State private var animate = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(pieces) { piece in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(piece.color)
                        .frame(width: piece.size, height: piece.size * 0.4)
                        .position(
                            x: piece.xFraction * geo.size.width,
                            y: reduceMotion
                                ? piece.restingYFraction * geo.size.height
                                : (animate ? geo.size.height + 40 : -40)
                        )
                        .rotationEffect(.degrees(reduceMotion ? 0 : (animate ? piece.rotation : 0)))
                        .opacity(reduceMotion ? (animate ? 1 : 0) : 1)
                        .animation(
                            reduceMotion
                                ? AppTheme.Motion.Curve.gentle.delay(piece.delay)
                                : .easeIn(duration: piece.duration).delay(piece.delay),
                            value: animate
                        )
                }
            }
            .drawingGroup()
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .onAppear { animate = true }
    }

    private static let colors: [Color] = [
        AppTheme.Colors.brandStart,
        AppTheme.Colors.brandMid,
        AppTheme.Colors.brandEnd,
        AppTheme.Colors.accent,
        AppTheme.Colors.success,
        Color(hex: "7C5CFF")
    ]

    private static func makePieces(count: Int = 28) -> [Piece] {
        (0..<count).map { index in
            Piece(
                color: colors[index % colors.count],
                xFraction: CGFloat.random(in: 0...1),
                restingYFraction: CGFloat.random(in: 0.05...0.6),
                size: CGFloat.random(in: 6...12),
                delay: Double.random(in: AppTheme.Motion.Confetti.delayRange),
                duration: Double.random(in: AppTheme.Motion.Confetti.durationRange),
                rotation: Double.random(in: 180...720)
            )
        }
    }
}

#Preview {
    ZStack {
        AppTheme.Colors.surface.ignoresSafeArea()
        ConfettiView()
    }
}
