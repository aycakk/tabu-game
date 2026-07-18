import SwiftUI
import SwiftData

@main
struct TabuApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [SettingsRecord.self, MatchResult.self])
    }
}
