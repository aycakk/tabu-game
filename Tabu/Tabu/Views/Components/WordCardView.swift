import SwiftUI

/// Oyun ekranındaki kart — takım rengi başlık şeridinde kelime, altında yasak kelime listesi.
struct WordCardView: View {
    let card: WordCard
    let teamColorHex: String

    var body: some View {
        VStack(spacing: 0) {
            header
            forbiddenList
        }
        .background(AppTheme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.card))
        .shadow(color: .black.opacity(0.4), radius: 30, y: 18)
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("ANLAT")
                .font(AppTheme.Fonts.overline)
                .tracking(2.5)
                .foregroundStyle(AppTheme.Colors.textOnBrand.opacity(0.82))

            Text(card.word.uppercased())
                .font(AppTheme.Fonts.cardWord)
                .foregroundStyle(AppTheme.Colors.textOnBrand)
                .tracking(-1)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .padding(.horizontal, 20)
        .background(AppTheme.Gradients.teamCardHeader(hex: teamColorHex))
    }

    private var forbiddenList: some View {
        VStack(spacing: 0) {
            ForEach(Array(card.forbidden.enumerated()), id: \.offset) { index, word in
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.Colors.dangerBg)
                            .frame(width: 22, height: 22)
                        Text("✕")
                            .font(.system(size: 12, weight: .black))
                            .foregroundStyle(AppTheme.Colors.danger)
                    }
                    .accessibilityHidden(true)

                    Text(word.uppercased())
                        .font(AppTheme.Fonts.nunitoSans(18, weight: .heavy))
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                }
                .padding(.vertical, 11)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Yasak: \(word)")

                if index < card.forbidden.count - 1 {
                    Rectangle()
                        .fill(AppTheme.Colors.divider)
                        .frame(height: 1)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 16)
    }
}

#Preview {
    WordCardView(
        card: WordCard(word: "Plaj", forbidden: ["Kum", "Deniz", "Güneş", "Şemsiye", "Tatil"]),
        teamColorHex: AppTheme.TeamColors.defaultTeam1
    )
    .padding(20)
    .background(AppTheme.Gradients.teamBackground(hex: AppTheme.TeamColors.defaultTeam1))
}
