import Foundation

/// Tek turun çıktısı: sayaçlar + net puan.
struct RoundResult: Identifiable, Equatable {
    let id: UUID
    let teamID: UUID
    /// 0 tabanlı tur sırası (toplam 2N tur içinde).
    let roundIndex: Int
    let correct: Int
    let passes: Int
    let taboos: Int
    /// Tabu başına düşülen puan (o anki ayardan gelir).
    let tabooPenalty: Int

    init(
        id: UUID = UUID(),
        teamID: UUID,
        roundIndex: Int,
        correct: Int,
        passes: Int,
        taboos: Int,
        tabooPenalty: Int
    ) {
        self.id = id
        self.teamID = teamID
        self.roundIndex = roundIndex
        self.correct = correct
        self.passes = passes
        self.taboos = taboos
        self.tabooPenalty = tabooPenalty
    }

    /// Tur net puanı — eksiye düşebilir.
    var netScore: Int {
        correct - taboos * tabooPenalty
    }
}
