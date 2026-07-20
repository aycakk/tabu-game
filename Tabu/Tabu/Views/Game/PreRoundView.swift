import SwiftUI

/// "Sıra Sizde" ekranı — turu başlatacak takımı gösterir, Başla'ya basınca oyun başlar.
struct PreRoundView: View {
    let team: Team
    var onStart: () -> Void
    var onClose: () -> Void

    @State private var isPulsing = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            AppTheme.Gradients.teamBackground(hex: team.colorHex)
                .ignoresSafeArea()

            closeButton
                .padding(.top, 44)
                .padding(.leading, 22)

            VStack(spacing: 0) {
                Spacer()

                centerContent
                    .padding(.horizontal, 36)

                Spacer()

                startButton
                    .padding(.horizontal, 28)
                    .padding(.bottom, 44)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }

    private var centerContent: some View {
        VStack(spacing: 0) {
            Text("SIRA SİZDE")
                .font(AppTheme.Fonts.overline)
                .tracking(2.5)
                .foregroundStyle(AppTheme.Colors.textOnBrand)
                .padding(.horizontal, 16)
                .padding(.vertical, 7)
                .background(.white.opacity(0.20))
                .clipShape(Capsule())

            Text(team.name)
                .font(AppTheme.Fonts.roundTeamTitle)
                .foregroundStyle(AppTheme.Colors.textOnBrand)
                .multilineTextAlignment(.center)
                .tracking(-1.5)
                .shadow(color: .black.opacity(0.18), radius: 15, y: 10)
                .padding(.top, 22)

            Text("Telefonu anlatıcıya ver,\nhazır olunca başla")
                .font(AppTheme.Fonts.nunitoSans(16, weight: .semibold))
                .foregroundStyle(AppTheme.Colors.textOnBrand.opacity(0.85))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.top, 18)
        }
    }

    private var closeButton: some View {
        Button(action: onClose) {
            Text("✕")
                .font(.system(size: 20, weight: .heavy))
                .foregroundStyle(AppTheme.Colors.textOnBrand)
                .frame(width: 40, height: 40)
                .background(.white.opacity(0.20))
                .clipShape(Circle())
        }
    }

    private var startButton: some View {
        Button(action: onStart) {
            Text("Başla")
                .font(AppTheme.Fonts.button)
                .tracking(0.3)
                .foregroundStyle(Color(hex: team.colorHex))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 22)
                .background(AppTheme.Colors.card)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.button))
        }
        .scaleEffect(isPulsing ? 1.035 : 1.0)
    }
}

#Preview {
    PreRoundView(
        team: Team(name: "Kırmızı Takım", colorHex: AppTheme.TeamColors.defaultTeam1),
        onStart: {},
        onClose: {}
    )
}
