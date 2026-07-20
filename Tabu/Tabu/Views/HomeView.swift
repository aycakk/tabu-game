import SwiftUI

/// Açılış / ana menü ekranı (mockup 01·Açılış).
struct HomeView: View {
    var onNewGame: () -> Void
    var onHowToPlay: () -> Void

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

                    Button(action: onHowToPlay) {
                        Text("Nasıl Oynanır?")
                            .font(AppTheme.Fonts.buttonSmall)
                            .foregroundStyle(AppTheme.Colors.textOnBrand)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(.white.opacity(0.20))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.button))
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 40)
            }
        }
    }

    private var decorativeCircles: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .fill(.white.opacity(0.12))
                    .frame(width: 300)
                    .position(x: geo.size.width + 30, y: 60)
                Circle()
                    .fill(.white.opacity(0.10))
                    .frame(width: 200)
                    .position(x: 10, y: 230)
                Circle()
                    .fill(.white.opacity(0.08))
                    .frame(width: 150)
                    .position(x: geo.size.width + 15, y: geo.size.height - 275)
                Circle()
                    .fill(.white.opacity(0.10))
                    .frame(width: 90, height: 90)
                    .position(x: 75, y: geo.size.height - 345)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView(onNewGame: {}, onHowToPlay: {})
}
