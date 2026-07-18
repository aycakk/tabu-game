import Foundation

/// Kurulum ekranındaki ayarlar. Varsayılanlar mockup'la aynı.
struct GameSettings: Equatable {
    /// Her takımın anlatma sayısı (N) → toplam 2N tur.
    var roundCount: Int = 5
    /// Tur süresi (saniye).
    var roundDuration: Int = 60
    /// Tur başına pas hakkı.
    var passLimit: Int = 3
    /// Yasak kelimeye değince düşülen puan.
    var tabooPenalty: Int = 1

    static let roundCountRange = 1...10
    static let roundDurationRange = 30...120
    static let roundDurationStep = 15
    static let passLimitRange = 0...5
    static let tabooPenaltyRange = 0...3
}
