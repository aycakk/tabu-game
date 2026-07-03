import Foundation

/// Oyunun akış fazları. Ani ölüm ayrı faz değil — GameViewModel'de mod bayrağı.
enum GamePhase: Equatable {
    case setup
    case preRound
    case playing
    case roundSummary
    case gameOver
}
