import SwiftUI

/// Geçici kök yönlendirme. Sprint 3'te gerçek akışla (home → setup → game) değişecek;
/// şimdilik "Yeni Oyun" sabit iki takımla direkt oyuna sokuyor (Sprint 2 playtest'i için).
struct RootView: View {
    @StateObject private var gameViewModel = GameViewModel()

    private var currentTeam: Team? {
        gameViewModel.teams.indices.contains(gameViewModel.currentTeamIndex)
            ? gameViewModel.teams[gameViewModel.currentTeamIndex]
            : nil
    }

    var body: some View {
        switch gameViewModel.phase {
        case .setup:
            HomeView(
                onNewGame: { gameViewModel.startNewGame(teams: playtestTeams, settings: GameSettings()) },
                onHowToPlay: { /* Sprint 3 Adım 4'te bağlanacak */ }
            )
        case .preRound:
            if let team = currentTeam {
                PreRoundView(
                    team: team,
                    onStart: { gameViewModel.startRound() },
                    onClose: { gameViewModel.phase = .setup }
                )
            } else {
                HomeView(onNewGame: {}, onHowToPlay: {})
            }
        case .playing:
            GameplayView(viewModel: gameViewModel)
        case .roundSummary, .gameOver:
            matchEndPlaceholder
        }
    }

    /// Sprint 4'te RoundSummaryView/GameOverView bunun yerini alacak.
    private var matchEndPlaceholder: some View {
        ZStack {
            AppTheme.Colors.surface.ignoresSafeArea()

            VStack(spacing: 18) {
                Text(gameViewModel.winner != nil ? "Oyun Bitti" : "Tur Bitti")
                    .font(AppTheme.Fonts.fredoka(28))
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                if let winner = gameViewModel.winner {
                    Text("Kazanan: \(winner.name)")
                        .font(AppTheme.Fonts.body)
                        .foregroundStyle(AppTheme.Colors.textMuted)
                }

                ForEach(gameViewModel.teams) { team in
                    Text("\(team.name): \(team.score)")
                        .font(AppTheme.Fonts.bodyBold)
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                }

                Button {
                    gameViewModel.phase = .setup
                } label: {
                    Text("Ana Menü")
                        .font(AppTheme.Fonts.buttonSmall)
                        .foregroundStyle(AppTheme.Colors.textOnBrand)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppTheme.Colors.textPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.button))
                }
                .padding(.top, 12)
            }
            .padding(28)
        }
    }

    private var playtestTeams: [Team] {
        [
            Team(name: "Kırmızı Takım", colorHex: AppTheme.TeamColors.defaultTeam1),
            Team(name: "Teal Takım", colorHex: AppTheme.TeamColors.defaultTeam2)
        ]
    }

}

#Preview {
    RootView()
}
