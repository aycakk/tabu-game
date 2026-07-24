import AVFoundation

/// Kısa ses efektleri — Haptics'in sesli karşılığı. .ambient kategori kullanır,
/// bu yüzden cihazın sessiz anahtarına saygı gösterir (çalar/medya kesintiye uğramaz).
enum SoundEffects {
    static func tick() {
        play(tickPlayer)
    }

    static func pass() {
        play(passPlayer)
    }

    static func correct() {
        play(correctPlayer)
    }

    static func roundEnd() {
        play(roundEndPlayer)
    }

    static func taboo() {
        play(tabooPlayer)
    }

    private static let sessionConfigured: Bool = {
        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
        return true
    }()

    private static let tickPlayer = makePlayer(fileName: "tick")
    private static let passPlayer = makePlayer(fileName: "pass_whoosh")
    private static let correctPlayer = makePlayer(fileName: "correct_ding")
    private static let roundEndPlayer = makePlayer(fileName: "round_end")
    private static let tabooPlayer = makePlayer(fileName: "taboo_buzz")

    private static func play(_ player: AVAudioPlayer?) {
        _ = sessionConfigured
        guard let player else { return }
        player.currentTime = 0
        player.play()
    }

    private static func makePlayer(fileName: String) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "wav") else {
            return nil
        }
        let player = try? AVAudioPlayer(contentsOf: url)
        player?.prepareToPlay()
        return player
    }
}
