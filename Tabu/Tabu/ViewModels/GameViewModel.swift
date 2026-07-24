import Combine
import Foundation

@MainActor
final class GameViewModel: ObservableObject {
    @Published var phase: GamePhase = .setup
    @Published var settings = GameSettings()
    @Published var teams: [Team] = []
    @Published var currentTeamIndex = 0
    @Published var currentRoundIndex = 0
    @Published var activeCard: WordCard?
    @Published var secondsRemaining = 0
    @Published var currentCorrect = 0
    @Published var currentPasses = 0
    @Published var currentTaboos = 0
    @Published var lastRoundResult: RoundResult?
    @Published var winner: Team?
    @Published var isSuddenDeath = false
    @Published var errorMessage: String?

    private let deckProvider: DeckProviding
    private let shuffleDeckOnStart: Bool
    private let automaticallyRunsTimer: Bool
    private var deck: [WordCard] = []
    private var drawIndex = 0
    private var timer: Timer?
    private var suddenDeathTurnsPlayed = 0

    init(
        deckProvider: DeckProviding = BundledDeckProvider(),
        shuffleDeckOnStart: Bool = true,
        automaticallyRunsTimer: Bool = true
    ) {
        self.deckProvider = deckProvider
        self.shuffleDeckOnStart = shuffleDeckOnStart
        self.automaticallyRunsTimer = automaticallyRunsTimer
    }

    deinit {
        timer?.invalidate()
    }

    func startNewGame(teams newTeams: [Team], settings newSettings: GameSettings) {
        stopTimer()
        errorMessage = nil
        winner = nil
        lastRoundResult = nil
        activeCard = nil
        isSuddenDeath = false
        suddenDeathTurnsPlayed = 0
        currentTeamIndex = 0
        currentRoundIndex = 0
        secondsRemaining = 0
        self.settings = newSettings

        guard newTeams.count == 2 else {
            failSetup(with: "MVP icin tam olarak iki takim gerekli.")
            return
        }

        do {
            deck = try deckProvider.loadDeck()
        } catch {
            failSetup(with: error.localizedDescription)
            return
        }

        guard !deck.isEmpty else {
            failSetup(with: "Deste bos.")
            return
        }

        if shuffleDeckOnStart {
            deck.shuffle()
        }
        drawIndex = 0
        teams = newTeams.map { team in
            Team(id: team.id, name: team.name, colorHex: team.colorHex, score: 0)
        }
        resetRoundCounters()
        phase = .preRound
    }

    /// Devam eden maçı iptal eder — geri sayım durur, ana menüye dönmek güvenli hale gelir.
    /// (Aksi halde arka planda çalışan timer sessizce tick/endRound tetikleyip state değiştirmeye devam ederdi.)
    func abandonGame() {
        stopTimer()
        phase = .setup
        activeCard = nil
        lastRoundResult = nil
        winner = nil
    }

    func startRound() {
        guard phase == .preRound, teams.indices.contains(currentTeamIndex), !deck.isEmpty else {
            return
        }

        resetRoundCounters()
        secondsRemaining = settings.roundDuration
        drawCard()
        phase = .playing
        startTimerIfNeeded()
    }

    func drawCard() {
        guard !deck.isEmpty else {
            activeCard = nil
            return
        }

        if drawIndex >= deck.count {
            drawIndex = 0
            if shuffleDeckOnStart {
                deck.shuffle()
            }
        }

        activeCard = deck[drawIndex]
        drawIndex += 1
    }

    func markCorrect() {
        guard phase == .playing else {
            return
        }

        currentCorrect += 1
        drawCard()
    }

    @discardableResult
    func pass() -> Bool {
        guard phase == .playing, currentPasses < settings.passLimit else {
            return false
        }

        currentPasses += 1
        drawCard()
        return true
    }

    func markTaboo() {
        guard phase == .playing else {
            return
        }

        currentTaboos += 1
        drawCard()
    }

    func tick() {
        guard phase == .playing else {
            return
        }

        if secondsRemaining > 0 {
            secondsRemaining -= 1
        }

        if secondsRemaining == 0 {
            endRound()
        }
    }

    func endRound() {
        guard phase == .playing, teams.indices.contains(currentTeamIndex) else {
            return
        }

        stopTimer()

        let result = RoundResult(
            teamID: teams[currentTeamIndex].id,
            roundIndex: currentRoundIndex,
            correct: currentCorrect,
            passes: currentPasses,
            taboos: currentTaboos,
            tabooPenalty: settings.tabooPenalty
        )

        teams[currentTeamIndex].score += result.netScore
        lastRoundResult = result
        activeCard = nil

        if isSuddenDeath {
            advanceSuddenDeath()
        } else {
            advanceNormalMatch()
        }
    }

    private var totalNormalRounds: Int {
        settings.roundCount * teams.count
    }

    private func advanceNormalMatch() {
        currentRoundIndex += 1

        if currentRoundIndex >= totalNormalRounds {
            resolveMatchOrStartSuddenDeath()
            return
        }

        currentTeamIndex = currentRoundIndex % teams.count
        phase = .preRound
    }

    private func advanceSuddenDeath() {
        currentRoundIndex += 1
        suddenDeathTurnsPlayed += 1

        if suddenDeathTurnsPlayed < teams.count {
            currentTeamIndex = (currentTeamIndex + 1) % teams.count
            phase = .preRound
            return
        }

        resolveMatchOrStartSuddenDeath()
    }

    private func resolveMatchOrStartSuddenDeath() {
        if let leadingTeam = uniqueLeader() {
            winner = leadingTeam
            isSuddenDeath = false
            suddenDeathTurnsPlayed = 0
            phase = .gameOver
        } else {
            beginSuddenDeath()
        }
    }

    private func beginSuddenDeath() {
        winner = nil
        isSuddenDeath = true
        suddenDeathTurnsPlayed = 0
        currentTeamIndex = 0
        phase = .preRound
    }

    private func uniqueLeader() -> Team? {
        guard let bestScore = teams.map(\.score).max() else {
            return nil
        }

        let leaders = teams.filter { $0.score == bestScore }
        return leaders.count == 1 ? leaders[0] : nil
    }

    private func resetRoundCounters() {
        currentCorrect = 0
        currentPasses = 0
        currentTaboos = 0
    }

    private func startTimerIfNeeded() {
        guard automaticallyRunsTimer else {
            return
        }

        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func failSetup(with message: String) {
        errorMessage = message
        teams = []
        deck = []
        drawIndex = 0
        phase = .setup
    }
}
