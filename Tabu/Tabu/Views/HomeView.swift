import SwiftUI

/// Açılış / ana menü ekranı (mockup 01·Açılış).
struct HomeView: View {
    var onNewGame: () -> Void
    var onHowToPlay: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var sparkleRotation = false
    @State private var sparklePulse = false
    @State private var circlesDrifting = false
    @State private var isButtonPulsing = false

    var body: some View {
        ZStack {
            AppTheme.Gradients.brand
                .ignoresSafeArea()

            decorativeCircles

            VStack {
                Spacer()

                Text("✦")
                    .font(.system(size: 30))
                    .foregroundStyle(AppTheme.Colors.accent)
                    .padding(.bottom, 18)
                    .scaleEffect(sparklePulse ? 1.2 : 0.85)
                    .rotationEffect(.degrees(sparkleRotation ? 360 : 0))

                Text("TABU")
                    .font(AppTheme.Fonts.splashTitle)
                    .foregroundStyle(AppTheme.Colors.textOnBrand)
                    .shadow(color: .black.opacity(0.18), radius: 15, y: 10)

                Text("Anlat, tahmin et, kazan")
                    .font(AppTheme.Fonts.body)
                    .foregroundStyle(AppTheme.Colors.textOnBrand.opacity(0.82))
                    .padding(.top, 14)

                Spacer()

                VStack(spacing: 14) {
                    Button(action: onNewGame) {
                        Text("Yeni Oyun")
                            .font(AppTheme.Fonts.button)
                            .foregroundStyle(AppTheme.Colors.brandStart)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(AppTheme.Colors.card)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.button))
                            .shadow(color: .black.opacity(0.28), radius: 19, y: 13)
                    }
                    .buttonStyle(.pressable)
                    .scaleEffect(isButtonPulsing ? 1.035 : 1.0)

                    Button(action: onHowToPlay) {
                        Text("Nasıl Oynanır?")
                            .font(AppTheme.Fonts.buttonSmall)
                            .foregroundStyle(AppTheme.Colors.textOnBrand)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(.white.opacity(0.20))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.button))
                    }
                    .buttonStyle(.pressable)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            // Reduce Motion açıkken hiçbiri tetiklenmiyor — @State'ler false'ta kalıp
            // view'lar zaten statik/dinlenme görünümlerinde render oluyor.
            guard !reduceMotion else { return }
            withAnimation(AppTheme.Motion.Ambient.sparkleRotation) {
                sparkleRotation = true
            }
            withAnimation(AppTheme.Motion.Ambient.sparklePulse) {
                sparklePulse = true
            }
            withAnimation(AppTheme.Motion.Ambient.ctaPulse) {
                isButtonPulsing = true
            }
            // Her dairenin kendi .animation(_:value:) modifier'ı farklı süreyle çalışıyor,
            // burada sadece tetikliyoruz.
            circlesDrifting = true
        }
    }

    private var decorativeCircles: some View {
        GeometryReader { geo in
            ZStack {
                driftingCircle(size: 300, opacity: 0.12, x: geo.size.width + 30, y: 60, duration: 6)
                driftingCircle(size: 200, opacity: 0.10, x: 10, y: 230, duration: 7.5)
                driftingCircle(size: 150, opacity: 0.08, x: geo.size.width + 15, y: geo.size.height - 275, duration: 5.5)
                driftingCircle(size: 90, opacity: 0.10, x: 75, y: geo.size.height - 345, duration: 8)
            }
        }
        .ignoresSafeArea()
    }

    private func driftingCircle(size: CGFloat, opacity: Double, x: CGFloat, y: CGFloat, duration: Double) -> some View {
        Circle()
            .fill(.white.opacity(opacity))
            .frame(width: size)
            .position(x: x, y: y)
            .offset(y: circlesDrifting ? -14 : 14)
            .animation(.easeInOut(duration: duration).repeatForever(autoreverses: true), value: circlesDrifting)
    }
}

#Preview {
    HomeView(onNewGame: {}, onHowToPlay: {})
}
