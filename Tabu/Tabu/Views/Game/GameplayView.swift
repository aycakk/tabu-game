import SwiftUI

/// Aktif tur ekranı — süre, kart, Pas/Tabu/Doğru aksiyonları.
struct GameplayView: View {
    @ObservedObject var viewModel: GameViewModel
    var onClose: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var currentTeam: Team? {
        viewModel.teams.indices.contains(viewModel.currentTeamIndex) ? viewModel.teams[viewModel.currentTeamIndex] : nil
    }

    /// Takımın kendi anlatma sırası (1-tabanlı) / toplam tur sayısı — "Tur 2/5".
    private var teamTurnNumber: Int {
        guard !viewModel.teams.isEmpty else { return 1 }
        return viewModel.currentRoundIndex / viewModel.teams.count + 1
    }

    var body: some View {
        ZStack {
            AppTheme.Gradients.teamBackground(hex: currentTeam?.colorHex ?? AppTheme.TeamColors.defaultTeam1)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                closeButtonRow
                header
                cardArea
                actionButtons
            }
            .padding(.horizontal, 18)
            .padding(.top, 6)
            .padding(.bottom, 18)
        }
        .onChange(of: viewModel.secondsRemaining) {
            switch viewModel.secondsRemaining {
            case 1...10:
                SoundEffects.tick()
            case 0:
                SoundEffects.roundEnd()
            default:
                break
            }
        }
    }

    private var closeButtonRow: some View {
        HStack {
            Button(action: onClose) {
                Text("✕")
                    .font(.system(size: 14, weight: .heavy))
                    .foregroundStyle(AppTheme.Colors.textOnBrand)
                    .frame(width: 28, height: 28)
                    .background(.white.opacity(0.20))
                    .clipShape(Circle())
            }
            .buttonStyle(.circularIcon)
            .accessibilityLabel("Oyunu kapat")

            Spacer(minLength: 0)
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            TimerRingView(secondsRemaining: viewModel.secondsRemaining, totalSeconds: viewModel.settings.roundDuration)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Kalan süre")
                .accessibilityValue("\(viewModel.secondsRemaining) saniye")

            VStack(alignment: .leading, spacing: 3) {
                Text(currentTeam?.name ?? "")
                    .font(AppTheme.Fonts.fredoka(19, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.textOnBrand)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text("Tur \(teamTurnNumber)/\(viewModel.settings.roundCount)")
                    .font(AppTheme.Fonts.nunitoSans(12, weight: .heavy))
                    .foregroundStyle(AppTheme.Colors.textOnBrand.opacity(0.78))
            }

            Spacer(minLength: 0)

            VStack(spacing: 2) {
                Text("\(viewModel.currentCorrect)")
                    .font(AppTheme.Fonts.fredoka(24))
                    .foregroundStyle(AppTheme.Colors.textOnBrand)
                Text("DOĞRU")
                    .font(AppTheme.Fonts.nunitoSans(9, weight: .heavy))
                    .tracking(1)
                    .foregroundStyle(AppTheme.Colors.textOnBrand.opacity(0.78))
            }
            .frame(minWidth: 54)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.white.opacity(0.20))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Doğru sayısı")
            .accessibilityValue("\(viewModel.currentCorrect)")
        }
    }

    private var cardArea: some View {
        Group {
            if let card = viewModel.activeCard {
                WordCardView(card: card, teamColorHex: currentTeam?.colorHex ?? AppTheme.TeamColors.defaultTeam1)
                    .id(card.id)
                    .transition(AppTheme.Motion.transition(
                        .asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ),
                        reduceMotion: reduceMotion
                    ))
            }
        }
        .frame(maxHeight: .infinity)
        .animation(AppTheme.Motion.animation(AppTheme.Motion.Spring.card, reduceMotion: reduceMotion), value: viewModel.activeCard?.id)
    }

    private var actionButtons: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                ActionButton(
                    title: "Pas",
                    subtitle: "\(viewModel.settings.passLimit - viewModel.currentPasses) kaldı",
                    backgroundColor: AppTheme.Colors.warning,
                    shadowColor: AppTheme.Colors.warning.opacity(0.6),
                    kind: .pass,
                    action: {
                        Haptics.selection()
                        SoundEffects.pass()
                        viewModel.pass()
                    }
                )
                .disabled(viewModel.currentPasses >= viewModel.settings.passLimit)

                ActionButton(
                    title: "Tabu",
                    subtitle: "−\(viewModel.settings.tabooPenalty) puan",
                    backgroundColor: AppTheme.Colors.danger,
                    shadowColor: AppTheme.Colors.danger.opacity(0.6),
                    kind: .taboo,
                    action: {
                        Haptics.error()
                        SoundEffects.taboo()
                        viewModel.markTaboo()
                    }
                )
            }

            ActionButton(
                title: "Doğru",
                glyph: "✓",
                backgroundColor: AppTheme.Colors.success,
                shadowColor: AppTheme.Colors.success.opacity(0.65),
                kind: .correct,
                action: {
                    Haptics.success()
                    SoundEffects.correct()
                    viewModel.markCorrect()
                }
            )
        }
    }
}

#Preview {
    let vm = GameViewModel(automaticallyRunsTimer: false)
    vm.startNewGame(
        teams: [
            Team(name: "Kırmızı Takım", colorHex: AppTheme.TeamColors.defaultTeam1),
            Team(name: "Teal Takım", colorHex: AppTheme.TeamColors.defaultTeam2)
        ],
        settings: GameSettings()
    )
    vm.startRound()
    return GameplayView(viewModel: vm, onClose: {})
}
