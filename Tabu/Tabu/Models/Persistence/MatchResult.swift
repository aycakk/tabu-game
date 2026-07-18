import Foundation
import SwiftData

/// Biten bir maçın kaydı — maç geçmişi listesi (v2 ekranı) için.
@Model
final class MatchResult {
    var date: Date
    var team1Name: String
    var team2Name: String
    var team1Score: Int
    var team2Score: Int
    /// Beraberlik ani ölümle bozulduğu için normalde hep dolu; güvenlik payı olarak opsiyonel.
    var winnerName: String?

    init(
        date: Date = .now,
        team1Name: String,
        team2Name: String,
        team1Score: Int,
        team2Score: Int,
        winnerName: String?
    ) {
        self.date = date
        self.team1Name = team1Name
        self.team2Name = team2Name
        self.team1Score = team1Score
        self.team2Score = team2Score
        self.winnerName = winnerName
    }
}
