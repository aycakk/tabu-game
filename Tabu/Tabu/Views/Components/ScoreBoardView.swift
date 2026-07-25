import SwiftUI

/// Takım + skor listesi — Tur Sonu ve Oyun Sonu ekranlarında ortak kullanılır.
struct ScoreBoardView: View {
    struct Row: Identifiable {
        let team: Team
        let statusText: String
        let statusColor: Color
        let isHighlighted: Bool

        var id: UUID { team.id }
    }

    let rows: [Row]
    /// Verilirse satırlar bu namespace üzerinden matchedGeometryEffect kullanır — Tur Sonu'ndan
    /// Oyun Sonu'na geçerken aynı takımın satırı "uçarak" devam ediyormuş hissi verir.
    var namespace: Namespace.ID? = nil

    var body: some View {
        VStack(spacing: 10) {
            ForEach(rows) { row in
                rowView(row)
            }
        }
    }

    @ViewBuilder
    private func rowView(_ row: Row) -> some View {
        if let namespace {
            rowContent(row).matchedGeometryEffect(id: row.team.id, in: namespace)
        } else {
            rowContent(row)
        }
    }

    private func rowContent(_ row: Row) -> some View {
        let teamColor = Color(hex: row.team.colorHex)

        return HStack(spacing: 14) {
            Circle()
                .fill(teamColor)
                .frame(width: 14, height: 14)

            VStack(alignment: .leading, spacing: 2) {
                Text(row.team.name)
                    .font(AppTheme.Fonts.nunitoSans(15, weight: .heavy))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text(row.statusText)
                    .font(AppTheme.Fonts.nunitoSans(11, weight: .bold))
                    .foregroundStyle(row.statusColor)
            }

            Spacer(minLength: 8)

            Text("\(row.team.score)")
                .font(AppTheme.Fonts.fredoka(32))
                .foregroundStyle(teamColor)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(AppTheme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.tile))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.Corner.tile)
                .stroke(row.isHighlighted ? teamColor : .clear, lineWidth: 2)
        )
        .shadow(
            color: row.isHighlighted ? teamColor.opacity(0.4) : .black.opacity(0.08),
            radius: row.isHighlighted ? 17 : 14,
            y: row.isHighlighted ? 8 : 6
        )
    }
}

#Preview {
    ScoreBoardView(rows: [
        .init(
            team: Team(name: "Kırmızı Takım", colorHex: AppTheme.TeamColors.defaultTeam1, score: 22),
            statusText: "Şimdi anlattı",
            statusColor: Color(hex: AppTheme.TeamColors.defaultTeam1),
            isHighlighted: true
        ),
        .init(
            team: Team(name: "Teal Takım", colorHex: AppTheme.TeamColors.defaultTeam2, score: 11),
            statusText: "Sırada",
            statusColor: AppTheme.Colors.textMuted,
            isHighlighted: false
        )
    ])
    .padding(20)
    .background(AppTheme.Colors.surface)
}
