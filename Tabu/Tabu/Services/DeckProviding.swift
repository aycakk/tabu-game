import Foundation

/// Deste kaynağı soyutlaması — v2'de SwiftData destesi aynı protokolü uygular.
protocol DeckProviding {
    func loadDeck() throws -> [WordCard]
}
