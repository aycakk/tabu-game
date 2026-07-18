import Foundation

/// Takım: ad, swatch rengi (hex) ve canlı skor. Skor eksiye düşebilir.
struct Team: Identifiable, Equatable {
    let id: UUID
    var name: String
    var colorHex: String
    var score: Int

    init(
        id: UUID = UUID(),
        name: String,
        colorHex: String,
        score: Int = 0
    ) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
        self.score = score
    }
}
