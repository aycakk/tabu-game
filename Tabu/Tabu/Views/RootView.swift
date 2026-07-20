import SwiftUI

/// Kök yönlendirme: home → kurulum → oyun → (kapat/ana menü ile) çıkış.
struct RootView: View {
    private enum Route {
        case home
        case teamSetup
        case howToPlay
        case game
    }

    @StateObject private var gameViewModel = GameViewModel()
    @State private var route: Route = .home

    private var currentTeam: Team? {
        gameViewModel.teams.indices.contains(gameViewModel.currentTeamIndex)
            ? gameViewModel.teams[gameViewModel.currentTeamIndex]
            : nil
    }

    var body: some View {
        switch route {
        case .home:
            HomeView(
                onNewGame: { route = .teamSetup },
                onHowToPlay: { route = .howToPlay }
            )
        case .teamSetup:
            TeamSetupView(
                onBack: { route = .home },
                onStart: { teams, settings in
                    gameViewModel.startNewGame(teams: teams, settings: settings)
                    route = .game
                }
            )
        case .howToPlay:
            HowToPlayView(onClose: { route = .home })
        case .game:
            gameContent
        }
    }

    @ViewBuilder
    private var gameContent: some View {
        switch gameViewModel.phase {
        case .setup:
            // startNewGame doğrulaması başarısız olduysa (ör. boş deste) buraya düşer.
            HomeView(
                onNewGame: { route = .teamSetup },
                onHowToPlay: { route = .howToPlay }
            )
            .onAppear { route = .home }
        case .preRound:
            if let team = currentTeam {
                PreRoundView(
                    team: team,
                    onStart: { gameViewModel.startRound() },
                    onClose: { route = .home }
                )
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
                    route = .home
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
}

#Preview {
    RootView()
}
