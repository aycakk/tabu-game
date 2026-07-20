import SwiftUI

/// Takım kurulumu ekranı (mockup 02·Kurulum) — takım adı/rengi + tur ayarları.
struct TeamSetupView: View {
    var onBack: () -> Void
    var onStart: ([Team], GameSettings) -> Void

    @State private var team1Name = "Kırmızı Takım"
    @State private var team1ColorHex = AppTheme.TeamColors.defaultTeam1
    @State private var team2Name = "Teal Takım"
    @State private var team2ColorHex = AppTheme.TeamColors.defaultTeam2
    @State private var settings = GameSettings()

    private var canStart: Bool {
        !team1Name.trimmingCharacters(in: .whitespaces).isEmpty
            && !team2Name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                VStack(spacing: 14) {
                    teamCard(
                        title: "TAKIM 1",
                        name: $team1Name,
                        selectedColorHex: $team1ColorHex,
                        disabledColorHex: team2ColorHex
                    )
                    teamCard(
                        title: "TAKIM 2",
                        name: $team2Name,
                        selectedColorHex: $team2ColorHex,
                        disabledColorHex: team1ColorHex
                    )
                    settingsCard
                }
                .padding(.horizontal, 20)
                .padding(.top, 4)
                .padding(.bottom, 16)
            }

            startButton
        }
        .background(AppTheme.Colors.surface.ignoresSafeArea())
    }

    private var header: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .frame(width: 38, height: 38)
                    .background(AppTheme.Colors.card)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: .black.opacity(0.25), radius: 10, y: 4)
            }

            Spacer()

            Text("Oyun Kurulumu")
                .font(AppTheme.Fonts.screenTitle)
                .foregroundStyle(AppTheme.Colors.textPrimary)

            Spacer()

            Color.clear.frame(width: 38, height: 38)
        }
        .padding(.horizontal, 20)
        .padding(.top, 6)
        .padding(.bottom, 14)
    }

    private func teamCard(
        title: String,
        name: Binding<String>,
        selectedColorHex: Binding<String>,
        disabledColorHex: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(AppTheme.Fonts.overline)
                .tracking(1.5)
                .foregroundStyle(AppTheme.Colors.textMuted)
                .padding(.bottom, 8)

            HStack(spacing: 10) {
                Circle()
                    .fill(Color(hex: selectedColorHex.wrappedValue))
                    .frame(width: 14, height: 14)

                TextField("Takım adı", text: name)
                    .font(AppTheme.Fonts.fredoka(26, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
            }
            .padding(.bottom, 10)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(AppTheme.Colors.divider)
                    .frame(height: 2)
            }
            .padding(.bottom, 16)

            HStack {
                ForEach(AppTheme.TeamColors.swatches, id: \.self) { hex in
                    swatch(
                        hex: hex,
                        isSelected: hex == selectedColorHex.wrappedValue,
                        isDisabled: hex == disabledColorHex
                    )
                    .onTapGesture {
                        guard hex != disabledColorHex else { return }
                        selectedColorHex.wrappedValue = hex
                    }
                }
            }
        }
        .padding(18)
        .background(AppTheme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.card))
        .shadow(color: .black.opacity(0.10), radius: 18, y: 10)
    }

    private func swatch(hex: String, isSelected: Bool, isDisabled: Bool) -> some View {
        ZStack {
            Circle()
                .fill(Color(hex: hex))
                .frame(width: 36, height: 36)
                .opacity(isDisabled ? 0.25 : 1)

            if isSelected {
                Circle()
                    .strokeBorder(.white, lineWidth: 3)
                    .frame(width: 36, height: 36)
            }
        }
        .shadow(color: isSelected ? Color(hex: hex).opacity(0.8) : .clear, radius: 8, y: 4)
    }

    private var settingsCard: some View {
        VStack(spacing: 0) {
            stepperRow(
                title: "Tur sayısı",
                subtitle: "Her takım kaç kez anlatır",
                value: settings.roundCount,
                range: GameSettings.roundCountRange,
                step: 1,
                showsDivider: true
            ) { settings.roundCount = $0 }

            stepperRow(
                title: "Tur süresi (sn)",
                subtitle: "Anlatım süresi",
                value: settings.roundDuration,
                range: GameSettings.roundDurationRange,
                step: GameSettings.roundDurationStep,
                showsDivider: true
            ) { settings.roundDuration = $0 }

            stepperRow(
                title: "Pas hakkı",
                subtitle: "Tur başına atlama",
                value: settings.passLimit,
                range: GameSettings.passLimitRange,
                step: 1,
                showsDivider: true
            ) { settings.passLimit = $0 }

            stepperRow(
                title: "Tabu cezası",
                subtitle: "Yasaklıya değince puan",
                value: settings.tabooPenalty,
                range: GameSettings.tabooPenaltyRange,
                step: 1,
                showsDivider: false
            ) { settings.tabooPenalty = $0 }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 6)
        .background(AppTheme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.card))
        .shadow(color: .black.opacity(0.10), radius: 18, y: 10)
    }

    private func stepperRow(
        title: String,
        subtitle: String,
        value: Int,
        range: ClosedRange<Int>,
        step: Int,
        showsDivider: Bool,
        onChange: @escaping (Int) -> Void
    ) -> some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(AppTheme.Fonts.nunitoSans(15, weight: .heavy))
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                    Text(subtitle)
                        .font(AppTheme.Fonts.nunitoSans(11))
                        .foregroundStyle(AppTheme.Colors.textMuted)
                }

                Spacer()

                HStack(spacing: 12) {
                    stepperButton(
                        glyph: "–",
                        foregroundColor: AppTheme.Colors.textMuted,
                        backgroundColor: AppTheme.Colors.surface,
                        isEnabled: value > range.lowerBound
                    ) {
                        onChange(max(range.lowerBound, value - step))
                    }

                    Text("\(value)")
                        .font(AppTheme.Fonts.fredoka(22))
                        .foregroundStyle(AppTheme.Colors.accent)
                        .frame(minWidth: 34)

                    stepperButton(
                        glyph: "+",
                        foregroundColor: AppTheme.Colors.accent,
                        backgroundColor: AppTheme.Colors.accent.opacity(0.12),
                        isEnabled: value < range.upperBound
                    ) {
                        onChange(min(range.upperBound, value + step))
                    }
                }
            }
            .padding(.vertical, 15)

            if showsDivider {
                Rectangle()
                    .fill(AppTheme.Colors.divider)
                    .frame(height: 1)
            }
        }
    }

    private func stepperButton(
        glyph: String,
        foregroundColor: Color,
        backgroundColor: Color,
        isEnabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(glyph)
                .font(AppTheme.Fonts.fredoka(20, weight: .semibold))
                .foregroundStyle(foregroundColor)
                .frame(width: 32, height: 32)
                .background(backgroundColor)
                .clipShape(Circle())
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.4)
    }

    private var startButton: some View {
        Button {
            let teams = [
                Team(name: team1Name.trimmingCharacters(in: .whitespaces), colorHex: team1ColorHex),
                Team(name: team2Name.trimmingCharacters(in: .whitespaces), colorHex: team2ColorHex)
            ]
            onStart(teams, settings)
        } label: {
            Text("Başla")
                .font(AppTheme.Fonts.button)
                .tracking(0.4)
                .foregroundStyle(AppTheme.Colors.textOnBrand)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(AppTheme.Gradients.brand)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.button))
                .shadow(color: AppTheme.Colors.brandMid.opacity(0.55), radius: 17, y: 9)
        }
        .disabled(!canStart)
        .opacity(canStart ? 1 : 0.5)
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 26)
    }
}

#Preview {
    TeamSetupView(onBack: {}, onStart: { _, _ in })
}
