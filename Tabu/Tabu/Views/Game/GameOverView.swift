import SwiftUI

/// Oyun sonu ekranı — kazanan, final skorları, Tekrar Oyna / Ana Menü.
/// Mockup'ta ayrı bir ekran yok; RoundSummaryView'daki görsel dille (pill, ScoreBoardView, marka gradyanlı CTA) tutarlı tasarlandı.
struct GameOverView: View {
    let winner: Team
    let scoreRows: [ScoreBoardView.Row]
    /// RoundSummaryView'daki skor satırlarıyla süreklilik kurmak için paylaşılan namespace.
    var scoreNamespace: Namespace.ID? = nil
    var onPlayAgain: () -> Void
    var onHome: () -> Void

    private var winnerColor: Color { Color(hex: winner.colorHex) }

    private var shareText: String {
        let scoresText = scoreRows
            .map { "\($0.team.name): \($0.team.score)" }
            .joined(separator: " · ")
        return "🏆 Tabu'da \(winner.name) kazandı!\n\(scoresText)\n\nSen de arkadaşlarınla oyna! 🎯"
    }

    var body: some View {
        ZStack {
            AppTheme.Colors.surface.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        header
                        scoreBoardSection
                            .padding(.top, 28)
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 40)
                }

                buttons
            }

            ConfettiView()
        }
    }

    private var header: some View {
        VStack(spacing: 14) {
            Text("🏆")
                .font(.system(size: 48))
                .accessibilityHidden(true)

            Text("OYUN BİTTİ")
                .font(AppTheme.Fonts.nunitoSans(10, weight: .black))
                .tracking(1.8)
                .foregroundStyle(AppTheme.Colors.textMuted)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(AppTheme.Colors.textPrimary.opacity(0.06))
                .clipShape(Capsule())

            Text(winner.name)
                .font(AppTheme.Fonts.fredoka(40))
                .foregroundStyle(winnerColor)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.5)

            Text("kazandı!")
                .font(AppTheme.Fonts.nunitoSans(16, weight: .bold))
                .foregroundStyle(AppTheme.Colors.textMuted)
        }
        .frame(maxWidth: .infinity)
    }

    private var scoreBoardSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("FİNAL SKORLARI")
                .font(AppTheme.Fonts.overline)
                .tracking(1.5)
                .foregroundStyle(AppTheme.Colors.textMuted)

            ScoreBoardView(rows: scoreRows, namespace: scoreNamespace, staggersAppearance: false)
        }
    }

    private var buttons: some View {
        VStack(spacing: 6) {
            Button(action: onPlayAgain) {
                Text("Tekrar Oyna")
                    .font(AppTheme.Fonts.button)
                    .foregroundStyle(AppTheme.Colors.textOnBrand)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(AppTheme.Gradients.brand)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.button))
                    .shadow(color: AppTheme.Colors.brandMid.opacity(0.55), radius: 17, y: 9)
            }
            .buttonStyle(.pressable)

            ShareLink(item: shareText) {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Sonucu Paylaş")
                }
                .font(AppTheme.Fonts.buttonSmall)
                .foregroundStyle(AppTheme.Colors.accent)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppTheme.Colors.accent.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.button))
            }
            .buttonStyle(.pressable)

            Button(action: onHome) {
                Text("Ana Menü")
                    .font(AppTheme.Fonts.buttonSmall)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .buttonStyle(.pressable)
        }
        .padding(.horizontal, 22)
        .padding(.top, 14)
        .padding(.bottom, 28)
    }
}

#Preview {
    let winner = Team(name: "Kırmızı Takım", colorHex: AppTheme.TeamColors.defaultTeam1, score: 34)
    let runnerUp = Team(name: "Teal Takım", colorHex: AppTheme.TeamColors.defaultTeam2, score: 27)

    GameOverView(
        winner: winner,
        scoreRows: [
            .init(team: winner, statusText: "Kazandı 🏆", statusColor: Color(hex: winner.colorHex), isHighlighted: true),
            .init(team: runnerUp, statusText: "", statusColor: AppTheme.Colors.textMuted, isHighlighted: false)
        ],
        onPlayAgain: {},
        onHome: {}
    )
}
