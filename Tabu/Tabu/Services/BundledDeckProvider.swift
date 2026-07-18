import Foundation

/// Bundle'daki deck_tr.json'ı okur.
struct BundledDeckProvider: DeckProviding {
    enum DeckError: Error, LocalizedError {
        case fileNotFound(String)

        var errorDescription: String? {
            switch self {
            case .fileNotFound(let name):
                return "Deste dosyası bundle'da bulunamadı: \(name)"
            }
        }
    }

    private struct DeckFile: Decodable {
        let version: Int
        let language: String
        let cards: [WordCard]
    }

    let fileName: String
    let bundle: Bundle

    init(fileName: String = "deck_tr", bundle: Bundle = .main) {
        self.fileName = fileName
        self.bundle = bundle
    }

    func loadDeck() throws -> [WordCard] {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw DeckError.fileNotFound("\(fileName).json")
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(DeckFile.self, from: data).cards
    }
}
