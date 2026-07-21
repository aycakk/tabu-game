import XCTest
import SwiftData
@testable import Tabu

/// SettingsRecord/MatchResult'ın gerçekten diske yazılıp yeni bir ModelContainer
/// (uygulama yeniden başlatmayı simüle eder) tarafından okunabildiğini doğrular.
@MainActor
final class PersistenceTests: XCTestCase {
    private func makeContainer(at url: URL) throws -> ModelContainer {
        let schema = Schema([SettingsRecord.self, MatchResult.self])
        let configuration = ModelConfiguration(schema: schema, url: url)
        return try ModelContainer(for: schema, configurations: [configuration])
    }

    private func temporaryStoreURL() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("PersistenceTests-\(UUID().uuidString).store")
    }

    func testSettingsRecordSurvivesFreshContainer() throws {
        let storeURL = temporaryStoreURL()
        defer { try? FileManager.default.removeItem(at: storeURL) }

        do {
            let container = try makeContainer(at: storeURL)
            let context = container.mainContext
            context.insert(SettingsRecord(roundCount: 7, roundDuration: 45, passLimit: 2, tabooPenalty: 3))
            try context.save()
        }

        // Taze bir container — ayrı bir uygulama oturumunu simüle eder.
        let reopened = try makeContainer(at: storeURL)
        let fetched = try reopened.mainContext.fetch(FetchDescriptor<SettingsRecord>())

        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.roundCount, 7)
        XCTAssertEqual(fetched.first?.roundDuration, 45)
        XCTAssertEqual(fetched.first?.passLimit, 2)
        XCTAssertEqual(fetched.first?.tabooPenalty, 3)
    }

    func testMatchResultSurvivesFreshContainer() throws {
        let storeURL = temporaryStoreURL()
        defer { try? FileManager.default.removeItem(at: storeURL) }

        do {
            let container = try makeContainer(at: storeURL)
            let context = container.mainContext
            context.insert(MatchResult(
                team1Name: "Kırmızı Takım",
                team2Name: "Teal Takım",
                team1Score: 34,
                team2Score: 27,
                winnerName: "Kırmızı Takım"
            ))
            try context.save()
        }

        let reopened = try makeContainer(at: storeURL)
        let fetched = try reopened.mainContext.fetch(FetchDescriptor<MatchResult>())

        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.team1Score, 34)
        XCTAssertEqual(fetched.first?.winnerName, "Kırmızı Takım")
    }
}
