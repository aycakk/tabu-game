import SwiftUI

/// Dairesel süre göstergesi — mockup 04·Oyun header'ındaki 62×62 halka.
/// Son 10 saniyede kırmızıya döner ve nabız gibi büyür/küçülür.
struct TimerRingView: View {
    let secondsRemaining: Int
    let totalSeconds: Int

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isPulsing = false

    private var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return Double(secondsRemaining) / Double(totalSeconds)
    }

    private var isUrgent: Bool { secondsRemaining <= 10 }

    private var ringColor: Color {
        isUrgent ? AppTheme.Colors.danger : AppTheme.Colors.textOnBrand
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(.white.opacity(0.28), lineWidth: 7)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(ringColor, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(AppTheme.Motion.timerTickSweep, value: progress)

            Text("\(secondsRemaining)")
                .font(AppTheme.Fonts.timer)
                .foregroundStyle(ringColor)
        }
        .frame(width: 62, height: 62)
        .scaleEffect(isUrgent && isPulsing ? 1.12 : 1.0)
        .onAppear { updatePulseState() }
        .onChange(of: secondsRemaining) { updatePulseState() }
    }

    private func updatePulseState() {
        // Sweep (progress) ve kırmızı renk değişimi bilgi taşıyor, dekoratif değil —
        // sadece bu döngüsel nabız Reduce Motion ile gate ediliyor.
        guard isUrgent, !reduceMotion else {
            isPulsing = false
            return
        }
        guard !isPulsing else { return }
        withAnimation(AppTheme.Motion.Ambient.timerUrgencyPulse) {
            isPulsing = true
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        TimerRingView(secondsRemaining: 38, totalSeconds: 60)
        TimerRingView(secondsRemaining: 7, totalSeconds: 60)
    }
    .padding(40)
    .background(AppTheme.Gradients.teamBackground(hex: AppTheme.TeamColors.defaultTeam1))
}
