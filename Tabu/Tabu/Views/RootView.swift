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
    /// "Devam"a basılana kadar hangi tur özetinin gösterildiğini takip eder.
    @State private var acknowledgedRoundResultID: UUID?

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
            if let pending = pendingRoundSummary {
                roundSummaryView(for: pending)
            } else if let team = currentTeam {
                PreRoundView(
                    team: team,
                    isSuddenDeath: gameViewModel.isSuddenDeath,
                    onStart: { gameViewModel.startRound() },
                    onClose: { route = .home }
                )
            }
        case .playing:
            GameplayView(viewModel: gameViewModel)
        case .roundSummary:
            // GameViewModel şu an bu faza hiç geçmiyor (bkz. Tabu-Mimari.md); savunma amaçlı ana menüye dön.
            HomeView(
                onNewGame: { route = .teamSetup },
                onHowToPlay: { route = .howToPlay }
            )
            .onAppear { route = .home }
        case .gameOver:
            // Son turun özeti de "Devam"la onaylanana kadar Oyun Sonu'nun önüne geçer.
            if let pending = pendingRoundSummary {
                roundSummaryView(for: pending)
            } else if let winner = gameViewModel.winner {
                GameOverView(
                    winner: winner,
                    scoreRows: finalScoreRows(winnerID: winner.id),
                    onPlayAgain: {
                        gameViewModel.startNewGame(teams: gameViewModel.teams, settings: gameViewModel.settings)
                    },
                    onHome: { route = .home }
                )
            }
        }
    }

    /// lastRoundResult henüz "Devam" ile onaylanmadıysa (team, result) çiftini döner.
    private var pendingRoundSummary: (team: Team, result: RoundResult)? {
        guard let result = gameViewModel.lastRoundResult,
              result.id != acknowledgedRoundResultID,
              let team = gameViewModel.teams.first(where: { $0.id == result.teamID })
        else { return nil }
        return (team, result)
    }

    @ViewBuilder
    private func roundSummaryView(for pending: (team: Team, result: RoundResult)) -> some View {
        RoundSummaryView(
            team: pending.team,
            result: pending.result,
            scoreRows: roundSummaryRows(playedTeamID: pending.team.id),
            isSuddenDeath: isSuddenDeathRound(pending.result),
            onContinue: { acknowledgedRoundResultID = pending.result.id }
        )
    }

    /// GameViewModel.isSuddenDeath "bundan sonraki tur"u yansıtır; bir sonucun ait olduğu turun
    /// ani ölüme mi denk geldiğini roundIndex'ten türetmek gerekir.
    private func isSuddenDeathRound(_ result: RoundResult) -> Bool {
        result.roundIndex >= gameViewModel.settings.roundCount * gameViewModel.teams.count
    }

    private func roundSummaryRows(playedTeamID: UUID) -> [ScoreBoardView.Row] {
        gameViewModel.teams.map { team in
            let justPlayed = team.id == playedTeamID
            return ScoreBoardView.Row(
                team: team,
                statusText: justPlayed ? "Şimdi anlattı" : "Sırada",
                statusColor: justPlayed ? Color(hex: team.colorHex) : AppTheme.Colors.textMuted,
                isHighlighted: justPlayed
            )
        }
    }

    private func finalScoreRows(winnerID: UUID) -> [ScoreBoardView.Row] {
        gameViewModel.teams.map { team in
            let isWinner = team.id == winnerID
            return ScoreBoardView.Row(
                team: team,
                statusText: isWinner ? "Kazandı 🏆" : "",
                statusColor: isWinner ? Color(hex: team.colorHex) : AppTheme.Colors.textMuted,
                isHighlighted: isWinner
            )
        }
    }
}

#Preview {
    RootView()
}
