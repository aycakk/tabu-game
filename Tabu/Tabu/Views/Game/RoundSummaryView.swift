import SwiftUI

/// Tur sonu özeti (mockup 05·Tur Sonu) — istatistikler, net puan, skor tablosu.
struct RoundSummaryView: View {
    let team: Team
    let result: RoundResult
    let scoreRows: [ScoreBoardView.Row]
    var isSuddenDeath: Bool = false
    /// Oyun Sonu'na geçerken skor satırlarının sürekliliğini sağlayan paylaşılan namespace.
    var scoreNamespace: Namespace.ID? = nil
    var onContinue: () -> Void
    var onClose: () -> Void

    private var teamColor: Color { Color(hex: team.colorHex) }
    private var netScoreColor: Color { result.netScore >= 0 ? AppTheme.Colors.success : AppTheme.Colors.danger }

    var body: some View {
        ZStack {
            AppTheme.Colors.surface.ignoresSafeArea()

            VStack(spacing: 0) {
                closeButtonRow

                ScrollView {
                    VStack(spacing: 0) {
                        header

                        statTiles
                            .padding(.top, 22)

                        netScoreSection
                            .padding(.top, 24)

                        Rectangle()
                            .fill(AppTheme.Colors.dividerStrong)
                            .frame(height: 1)
                            .padding(.vertical, 18)
                            .padding(.horizontal, 4)

                        scoreBoardSection
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 18)
                }

                continueButton
            }
        }
    }

    private var closeButtonRow: some View {
        HStack {
            Button(action: onClose) {
                Text("✕")
                    .font(.system(size: 14, weight: .heavy))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .frame(width: 32, height: 32)
                    .background(AppTheme.Colors.card)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.10), radius: 8, y: 4)
            }
            .buttonStyle(.circularIcon)
            .accessibilityLabel("Kapat")

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 22)
        .padding(.top, 14)
    }

    private var header: some View {
        VStack(spacing: 0) {
            Text(isSuddenDeath ? "ANİ ÖLÜM" : "TUR BİTTİ")
                .font(AppTheme.Fonts.nunitoSans(10, weight: .black))
                .tracking(1.8)
                .foregroundStyle(AppTheme.Colors.textMuted)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(AppTheme.Colors.textPrimary.opacity(0.06))
                .clipShape(Capsule())
                .padding(.bottom, 10)

            Text(team.name)
                .font(AppTheme.Fonts.fredoka(34))
                .foregroundStyle(teamColor)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 6)
    }

    private var statTiles: some View {
        HStack(spacing: 10) {
            statTile(value: result.correct, label: "DOĞRU", color: AppTheme.Colors.success)
                .staggerAppear(index: 0)
            statTile(value: result.passes, label: "PAS", color: AppTheme.Colors.warning)
                .staggerAppear(index: 1)
            statTile(value: result.taboos, label: "TABU", color: AppTheme.Colors.danger)
                .staggerAppear(index: 2)
        }
    }

    private func statTile(value: Int, label: String, color: Color) -> some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(color)
                .frame(height: 4)

            VStack(spacing: 6) {
                Text("\(value)")
                    .font(AppTheme.Fonts.fredoka(30))
                    .foregroundStyle(color)
                Text(label)
                    .font(AppTheme.Fonts.nunitoSans(10, weight: .heavy))
                    .tracking(0.8)
                    .foregroundStyle(AppTheme.Colors.textMuted)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
        .background(AppTheme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.tile))
        .shadow(color: .black.opacity(0.08), radius: 13, y: 8)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
        .accessibilityValue("\(value)")
    }

    private var netScoreSection: some View {
        VStack(spacing: 2) {
            Text(result.netScore >= 0 ? "+\(result.netScore) puan" : "\(result.netScore) puan")
                .font(AppTheme.Fonts.fredoka(64))
                .foregroundStyle(netScoreColor)
            Text("bu tur")
                .font(AppTheme.Fonts.nunitoSans(13, weight: .heavy))
                .foregroundStyle(AppTheme.Colors.textMuted)
        }
        .frame(maxWidth: .infinity)
    }

    private var scoreBoardSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SKOR TABLOSU")
                .font(AppTheme.Fonts.overline)
                .tracking(1.5)
                .foregroundStyle(AppTheme.Colors.textMuted)

            ScoreBoardView(rows: scoreRows, namespace: scoreNamespace)
        }
    }

    private var continueButton: some View {
        Button(action: onContinue) {
            Text("Devam")
                .font(AppTheme.Fonts.fredoka(21))
                .foregroundStyle(AppTheme.Colors.textOnBrand)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(AppTheme.Colors.textPrimary)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.button))
                .shadow(color: AppTheme.Colors.textPrimary.opacity(0.55), radius: 16, y: 8)
        }
        .buttonStyle(.pressable)
        .padding(.horizontal, 22)
        .padding(.top, 14)
        .padding(.bottom, 28)
    }
}

#Preview {
    let team1 = Team(name: "Kırmızı Takım", colorHex: AppTheme.TeamColors.defaultTeam1, score: 22)
    let team2 = Team(name: "Teal Takım", colorHex: AppTheme.TeamColors.defaultTeam2, score: 11)

    RoundSummaryView(
        team: team1,
        result: RoundResult(teamID: team1.id, roundIndex: 1, correct: 9, passes: 2, taboos: 1, tabooPenalty: 1),
        scoreRows: [
            .init(team: team1, statusText: "Şimdi anlattı", statusColor: Color(hex: team1.colorHex), isHighlighted: true),
            .init(team: team2, statusText: "Sırada", statusColor: AppTheme.Colors.textMuted, isHighlighted: false)
        ],
        onContinue: {},
        onClose: {}
    )
}
