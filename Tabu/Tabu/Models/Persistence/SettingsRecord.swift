import Foundation
import SwiftData

/// Son kullanılan oyun ayarları — tek kayıt, her maç sonunda üzerine yazılır.
@Model
final class SettingsRecord {
    var roundCount: Int
    var roundDuration: Int
    var passLimit: Int
    var tabooPenalty: Int

    init(roundCount: Int, roundDuration: Int, passLimit: Int, tabooPenalty: Int) {
        self.roundCount = roundCount
        self.roundDuration = roundDuration
        self.passLimit = passLimit
        self.tabooPenalty = tabooPenalty
    }

    convenience init(from settings: GameSettings) {
        self.init(
            roundCount: settings.roundCount,
            roundDuration: settings.roundDuration,
            passLimit: settings.passLimit,
            tabooPenalty: settings.tabooPenalty
        )
    }

    var asGameSettings: GameSettings {
        GameSettings(
            roundCount: roundCount,
            roundDuration: roundDuration,
            passLimit: passLimit,
            tabooPenalty: tabooPenalty
        )
    }
}
