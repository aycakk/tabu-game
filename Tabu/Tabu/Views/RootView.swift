import SwiftUI

/// Geçici kök yönlendirme. Sprint 3'te gerçek akışla (home → setup → game) değişecek;
/// şimdilik "Yeni Oyun" sabit iki takımla direkt oyuna sokuyor (Sprint 2 playtest'i için).
struct RootView: View {
    @StateObject private var gameViewModel = GameViewModel()

    private var currentTeam: Team? {
        gameViewModel.teams.indices.contains(gameViewModel.currentTeamIndex)
            ? gameViewModel.teams[gameViewModel.currentTeamIndex]
            : nil
    }

    var body: some View {
        switch gameViewModel.phase {
        case .setup:
            splashView
        case .preRound:
            if let team = currentTeam {
                PreRoundView(
                    team: team,
                    onStart: { gameViewModel.startRound() },
                    onClose: { gameViewModel.phase = .setup }
                )
            } else {
                splashView
            }
        case .playing:
            GameplayView(viewModel: gameViewModel)
        case .roundSummary, .gameOver:
            matchEndPlaceholder
        }
    }

    private var splashView: some View {
        ZStack {
            AppTheme.Gradients.brand
                .ignoresSafeArea()

            decorativeCircles

            VStack {
                Spacer()

                Text("✦")
                    .font(.system(size: 30))
                    .foregroundStyle(AppTheme.Colors.accent)
                    .padding(.bottom, 18)

                Text("TABU")
                    .font(AppTheme.Fonts.splashTitle)
                    .foregroundStyle(AppTheme.Colors.textOnBrand)
                    .shadow(color: .black.opacity(0.18), radius: 15, y: 10)

                Text("Anlat, tahmin et, kazan")
                    .font(AppTheme.Fonts.body)
                    .foregroundStyle(AppTheme.Colors.textOnBrand.opacity(0.82))
                    .padding(.top, 14)

                Spacer()

                VStack(spacing: 14) {
                    Button {
                        gameViewModel.startNewGame(teams: playtestTeams, settings: GameSettings())
                    } label: {
                        Text("Yeni Oyun")
                            .font(AppTheme.Fonts.button)
                            .foregroundStyle(AppTheme.Colors.brandStart)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(AppTheme.Colors.card)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.button))
                            .shadow(color: .black.opacity(0.28), radius: 19, y: 13)
                    }

                    Button {
                        // Sprint 3: nasıl oynanır
                    } label: {
                        Text("Nasıl Oynanır?")
                            .font(AppTheme.Fonts.buttonSmall)
                            .foregroundStyle(AppTheme.Colors.textOnBrand)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(.white.opacity(0.20))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.button))
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 40)
            }
        }
    }

    /// Sprint 4'te RoundSummaryView/GameOverView bunun yerini alacak.
    private var matchEndPlaceholder: some View {
        ZStack {
            AppTheme.Colors.surface.ignoresSafeArea()

            VStack(spacing: 18) {
                Text(gameViewModel.winner != nil ? "Oyun Bitti" : "Tur Bitti")
                    .font(AppTheme.Fonts.fredoka(28))
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                if let winner = gameViewModel.winner {
                    Text("Kazanan: \(winner.name)")
                        .font(AppTheme.Fonts.body)
                        .foregroundStyle(AppTheme.Colors.textMuted)
                }

                ForEach(gameViewModel.teams) { team in
                    Text("\(team.name): \(team.score)")
                        .font(AppTheme.Fonts.bodyBold)
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                }

                Button {
                    gameViewModel.phase = .setup
                } label: {
                    Text("Ana Menü")
                        .font(AppTheme.Fonts.buttonSmall)
                        .foregroundStyle(AppTheme.Colors.textOnBrand)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppTheme.Colors.textPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.button))
                }
                .padding(.top, 12)
            }
            .padding(28)
        }
    }

    private var playtestTeams: [Team] {
        [
            Team(name: "Kırmızı Takım", colorHex: AppTheme.TeamColors.defaultTeam1),
            Team(name: "Teal Takım", colorHex: AppTheme.TeamColors.defaultTeam2)
        ]
    }

    private var decorativeCircles: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .fill(.white.opacity(0.12))
                    .frame(width: 300)
                    .position(x: geo.size.width + 30, y: 60)
                Circle()
                    .fill(.white.opacity(0.10))
                    .frame(width: 200)
                    .position(x: 10, y: 230)
                Circle()
                    .fill(.white.opacity(0.08))
                    .frame(width: 150)
                    .position(x: geo.size.width + 15, y: geo.size.height - 275)
                Circle()
                    .fill(.white.opacity(0.10))
                    .frame(width: 90, height: 90)
                    .position(x: 75, y: geo.size.height - 345)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    RootView()
}
