import XCTest
@testable import Tabu

@MainActor
final class TabuTests: XCTestCase {
    func testStartNewGameSetsPreRoundAndResetsScores() {
        let viewModel = makeViewModel()
        var teams = makeTeams()
        teams[0].score = 12
        teams[1].score = -3
        let settings = GameSettings(roundCount: 3, roundDuration: 45, passLimit: 2, tabooPenalty: 2)

        viewModel.startNewGame(teams: teams, settings: settings)

        XCTAssertEqual(viewModel.phase, .preRound)
        XCTAssertEqual(viewModel.settings, settings)
        XCTAssertEqual(viewModel.teams.map(\.score), [0, 0])
        XCTAssertEqual(viewModel.currentTeamIndex, 0)
        XCTAssertEqual(viewModel.currentRoundIndex, 0)
        XCTAssertNil(viewModel.winner)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testStartRoundSetsCardTimerAndCounters() {
        let viewModel = makeStartedGame(settings: GameSettings(roundCount: 3, roundDuration: 45, passLimit: 2, tabooPenalty: 1))

        viewModel.startRound()

        XCTAssertEqual(viewModel.phase, .playing)
        XCTAssertEqual(viewModel.secondsRemaining, 45)
        XCTAssertEqual(viewModel.activeCard?.word, "Plaj")
        XCTAssertEqual(viewModel.currentCorrect, 0)
        XCTAssertEqual(viewModel.currentPasses, 0)
        XCTAssertEqual(viewModel.currentTaboos, 0)
    }

    func testActionsUpdateCountersAndCards() {
        let viewModel = makeStartedGame(settings: GameSettings(roundCount: 3, roundDuration: 60, passLimit: 2, tabooPenalty: 1))
        viewModel.startRound()

        viewModel.markCorrect()
        XCTAssertEqual(viewModel.currentCorrect, 1)
        XCTAssertEqual(viewModel.activeCard?.word, "Doktor")

        XCTAssertTrue(viewModel.pass())
        XCTAssertEqual(viewModel.currentPasses, 1)
        XCTAssertEqual(viewModel.activeCard?.word, "Futbol")

        viewModel.markTaboo()
        XCTAssertEqual(viewModel.currentTaboos, 1)
        XCTAssertEqual(viewModel.activeCard?.word, "Cay")
    }

    func testPassLimitStopsExtraPassAndKeepsCurrentCard() {
        let viewModel = makeStartedGame(settings: GameSettings(roundCount: 3, roundDuration: 60, passLimit: 1, tabooPenalty: 1))
        viewModel.startRound()

        XCTAssertTrue(viewModel.pass())
        let cardAfterAllowedPass = viewModel.activeCard

        XCTAssertFalse(viewModel.pass())
        XCTAssertEqual(viewModel.currentPasses, 1)
        XCTAssertEqual(viewModel.activeCard, cardAfterAllowedPass)
    }

    func testEndRoundAppliesNetScoreAndAllowsNegativeScore() {
        let viewModel = makeStartedGame(settings: GameSettings(roundCount: 3, roundDuration: 60, passLimit: 3, tabooPenalty: 2))
        viewModel.startRound()

        viewModel.markTaboo()
        viewModel.markTaboo()
        viewModel.endRound()

        XCTAssertEqual(viewModel.lastRoundResult?.netScore, -4)
        XCTAssertEqual(viewModel.teams[0].score, -4)
        XCTAssertEqual(viewModel.currentTeamIndex, 1)
        XCTAssertEqual(viewModel.phase, .preRound)
    }

    func testTeamsAlternateDuringNormalRounds() {
        let viewModel = makeStartedGame(settings: GameSettings(roundCount: 2, roundDuration: 60, passLimit: 3, tabooPenalty: 1))

        viewModel.startRound()
        viewModel.endRound()
        XCTAssertEqual(viewModel.currentTeamIndex, 1)
        XCTAssertEqual(viewModel.currentRoundIndex, 1)

        viewModel.startRound()
        viewModel.endRound()
        XCTAssertEqual(viewModel.currentTeamIndex, 0)
        XCTAssertEqual(viewModel.currentRoundIndex, 2)
        XCTAssertEqual(viewModel.phase, .preRound)
    }

    func testRoundCountOneFinishesAfterTwoRoundsWithWinner() {
        let viewModel = makeStartedGame(settings: GameSettings(roundCount: 1, roundDuration: 60, passLimit: 3, tabooPenalty: 1))

        viewModel.startRound()
        viewModel.markCorrect()
        viewModel.markCorrect()
        viewModel.endRound()

        viewModel.startRound()
        viewModel.markCorrect()
        viewModel.endRound()

        XCTAssertEqual(viewModel.phase, .gameOver)
        XCTAssertEqual(viewModel.winner?.name, "Kirmizi Takim")
        XCTAssertFalse(viewModel.isSuddenDeath)
    }

    func testTieStartsSuddenDeath() {
        let viewModel = makeStartedGame(settings: GameSettings(roundCount: 1, roundDuration: 60, passLimit: 3, tabooPenalty: 1))

        viewModel.startRound()
        viewModel.markCorrect()
        viewModel.endRound()

        viewModel.startRound()
        viewModel.markCorrect()
        viewModel.endRound()

        XCTAssertEqual(viewModel.phase, .preRound)
        XCTAssertTrue(viewModel.isSuddenDeath)
        XCTAssertNil(viewModel.winner)
        XCTAssertEqual(viewModel.currentTeamIndex, 0)
    }

    func testSuddenDeathRepeatsUntilTieBreaks() {
        let viewModel = makeStartedGame(settings: GameSettings(roundCount: 1, roundDuration: 60, passLimit: 3, tabooPenalty: 1))
        playRound(on: viewModel, correct: 1)
        playRound(on: viewModel, correct: 1)
        XCTAssertTrue(viewModel.isSuddenDeath)

        playRound(on: viewModel, correct: 1)
        XCTAssertTrue(viewModel.isSuddenDeath)
        XCTAssertEqual(viewModel.currentTeamIndex, 1)

        playRound(on: viewModel, correct: 1)
        XCTAssertTrue(viewModel.isSuddenDeath)
        XCTAssertEqual(viewModel.currentTeamIndex, 0)

        playRound(on: viewModel, correct: 2)
        playRound(on: viewModel, correct: 1)

        XCTAssertEqual(viewModel.phase, .gameOver)
        XCTAssertEqual(viewModel.winner?.name, "Kirmizi Takim")
        XCTAssertFalse(viewModel.isSuddenDeath)
        XCTAssertEqual(viewModel.teams.map(\.score), [4, 3])
    }

    func testTickEndsRoundAtZero() {
        let viewModel = makeStartedGame(settings: GameSettings(roundCount: 2, roundDuration: 2, passLimit: 3, tabooPenalty: 1))
        viewModel.startRound()

        viewModel.tick()
        XCTAssertEqual(viewModel.secondsRemaining, 1)
        XCTAssertEqual(viewModel.phase, .playing)

        viewModel.tick()
        XCTAssertEqual(viewModel.secondsRemaining, 0)
        XCTAssertEqual(viewModel.phase, .preRound)
        XCTAssertNotNil(viewModel.lastRoundResult)
    }

    func testAbandonGameStopsRoundAndIgnoresLateTicks() {
        let viewModel = makeStartedGame(settings: GameSettings(roundCount: 3, roundDuration: 60, passLimit: 3, tabooPenalty: 1))
        viewModel.startRound()
        viewModel.markCorrect()

        viewModel.abandonGame()

        XCTAssertEqual(viewModel.phase, .setup)
        XCTAssertNil(viewModel.activeCard)
        XCTAssertNil(viewModel.lastRoundResult)
        XCTAssertNil(viewModel.winner)

        // Terk edildikten sonra gelecek gecikmiş bir tick (arka planda kalmış bir timer'dan)
        // sessizce state değiştirmemeli — RootView'ın "kapat" butonundan sonra bunu bekliyoruz.
        let secondsBefore = viewModel.secondsRemaining
        viewModel.tick()
        XCTAssertEqual(viewModel.secondsRemaining, secondsBefore)
        XCTAssertEqual(viewModel.phase, .setup)
    }

    private func playRound(on viewModel: GameViewModel, correct: Int = 0, taboos: Int = 0) {
        viewModel.startRound()
        for _ in 0..<correct {
            viewModel.markCorrect()
        }
        for _ in 0..<taboos {
            viewModel.markTaboo()
        }
        viewModel.endRound()
    }

    private func makeStartedGame(settings: GameSettings) -> GameViewModel {
        let viewModel = makeViewModel()
        viewModel.startNewGame(teams: makeTeams(), settings: settings)
        return viewModel
    }

    private func makeViewModel(cards: [WordCard]? = nil) -> GameViewModel {
        GameViewModel(
            deckProvider: StubDeckProvider(cards: cards ?? Self.testCards()),
            shuffleDeckOnStart: false,
            automaticallyRunsTimer: false
        )
    }

    private func makeTeams() -> [Team] {
        [
            Team(name: "Kirmizi Takim", colorHex: AppTheme.TeamColors.defaultTeam1),
            Team(name: "Teal Takim", colorHex: AppTheme.TeamColors.defaultTeam2)
        ]
    }

    private static func testCards() -> [WordCard] {
        [
            WordCard(word: "Plaj", forbidden: ["Kum", "Deniz", "Gunes", "Semsiye", "Tatil"]),
            WordCard(word: "Doktor", forbidden: ["Hastane", "Hasta", "Muayene", "Recete", "Igne"]),
            WordCard(word: "Futbol", forbidden: ["Top", "Gol", "Saha", "Takim", "Mac"]),
            WordCard(word: "Cay", forbidden: ["Bardak", "Demlik", "Sicak", "Icecek", "Kahvalti"]),
            WordCard(word: "Ay", forbidden: ["Gokyuzu", "Gece", "Dunya", "Yildiz", "Dolunay"])
        ]
    }
}

private struct StubDeckProvider: DeckProviding {
    let cards: [WordCard]

    func loadDeck() throws -> [WordCard] {
        cards
    }
}
