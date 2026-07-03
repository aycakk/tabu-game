import Foundation

/// Bir tabu kartı: anlatılacak kelime + söylenmesi yasak 5 kelime.
struct WordCard: Identifiable, Equatable, Codable {
    let id: UUID
    let word: String
    let forbidden: [String]

    init(id: UUID = UUID(), word: String, forbidden: [String]) {
        self.id = id
        self.word = word
        self.forbidden = forbidden
    }

    // JSON'da id yok; decode sırasında üretilir.
    private enum CodingKeys: String, CodingKey {
        case word, forbidden
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.word = try container.decode(String.self, forKey: .word)
        self.forbidden = try container.decode([String].self, forKey: .forbidden)
    }
}
