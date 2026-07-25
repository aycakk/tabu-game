import SwiftUI
import SwiftData

/// Kök yönlendirme: home → kurulum → oyun → (kapat/ana menü ile) çıkış.
struct RootView: View {
    private enum Route: Equatable {
        case home
        case teamSetup
        case game
    }

    @Environment(\.modelContext) private var modelContext
    @StateObject private var gameViewModel = GameViewModel()
    @State private var route: Route = .home
    /// "Devam"a basılana kadar hangi tur özetinin gösterildiğini takip eder.
    @State private var acknowledgedRoundResultID: UUID?
    /// Bu maç için MatchResult zaten kaydedildi mi (Tekrar Oyna'da yeniden false'a döner).
    @State private var didSaveMatchResult = false
    /// Nasıl Oynanır artık ayrı bir "sayfa" değil — mevcut ekranın üzerinde native sheet olarak açılır.
    @State private var isShowingHowToPlay = false

    private var currentTeam: Team? {
        gameViewModel.teams.indices.contains(gameViewModel.currentTeamIndex)
            ? gameViewModel.teams[gameViewModel.currentTeamIndex]
            : nil
    }

    var body: some View {
        Group {
            switch route {
            case .home:
                HomeView(
                    onNewGame: { route = .teamSetup },
                    onHowToPlay: { isShowingHowToPlay = true }
                )
            case .teamSetup:
                TeamSetupView(
                    onBack: { route = .home },
                    onStart: { teams, settings in
                        didSaveMatchResult = false
                        gameViewModel.startNewGame(teams: teams, settings: settings)
                        route = .game
                    }
                )
            case .game:
                gameContent
            }
        }
        .animation(AppTheme.Motion.Curve.standard, value: route)
        .sheet(isPresented: $isShowingHowToPlay) {
            HowToPlayView(onClose: { isShowingHowToPlay = false })
        }
    }

    /// Faz + tur-özeti-onay durumunu tek bir Equatable anahtarda birleştirir (gameContent'in
    /// aynı .preRound/.gameOver faz değeri içindeki iç geçişlerini de animasyonla tetiklemek için).
    private var gameContentAnimationKey: String {
        "\(gameViewModel.phase)-\(acknowledgedRoundResultID?.uuidString ?? "none")"
    }

    @ViewBuilder
    private var gameContent: some View {
        Group {
            gameContentSwitch
        }
        .animation(AppTheme.Motion.Curve.standard, value: gameContentAnimationKey)
    }

    @ViewBuilder
    private var gameContentSwitch: some View {
        switch gameViewModel.phase {
        case .setup:
            // startNewGame doğrulaması başarısız olduysa (ör. boş deste) buraya düşer.
            HomeView(
                onNewGame: { route = .teamSetup },
                onHowToPlay: { isShowingHowToPlay = true }
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
                    onClose: { exitToHome() }
                )
            }
        case .playing:
            GameplayView(viewModel: gameViewModel, onClose: { exitToHome() })
        case .roundSummary:
            // GameViewModel şu an bu faza hiç geçmiyor (bkz. Tabu-Mimari.md); savunma amaçlı ana menüye dön.
            HomeView(
                onNewGame: { route = .teamSetup },
                onHowToPlay: { isShowingHowToPlay = true }
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
                        didSaveMatchResult = false
                        gameViewModel.startNewGame(teams: gameViewModel.teams, settings: gameViewModel.settings)
                    },
                    onHome: { route = .home }
                )
                .onAppear { saveMatchResultIfNeeded(winner: winner) }
            }
        }
    }

    private func saveMatchResultIfNeeded(winner: Team) {
        guard !didSaveMatchResult, gameViewModel.teams.count == 2 else { return }
        didSaveMatchResult = true
        let team1 = gameViewModel.teams[0]
        let team2 = gameViewModel.teams[1]
        modelContext.insert(
            MatchResult(
                team1Name: team1.name,
                team2Name: team2.name,
                team1Score: team1.score,
                team2Score: team2.score,
                winnerName: winner.name
            )
        )
        try? modelContext.save()
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
            onContinue: { acknowledgedRoundResultID = pending.result.id },
            onClose: { exitToHome() }
        )
    }

    /// Devam eden maçı güvenli şekilde iptal edip ana menüye döner (timer'ı durdurur).
    private func exitToHome() {
        gameViewModel.abandonGame()
        route = .home
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
        .modelContainer(for: [SettingsRecord.self, MatchResult.self], inMemory: true)
}
