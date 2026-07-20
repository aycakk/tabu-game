import SwiftUI

/// Dairesel süre göstergesi — mockup 04·Oyun header'ındaki 62×62 halka.
struct TimerRingView: View {
    let secondsRemaining: Int
    let totalSeconds: Int

    private var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return Double(secondsRemaining) / Double(totalSeconds)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(.white.opacity(0.28), lineWidth: 7)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(.white, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: progress)

            Text("\(secondsRemaining)")
                .font(AppTheme.Fonts.timer)
                .foregroundStyle(AppTheme.Colors.textOnBrand)
        }
        .frame(width: 62, height: 62)
    }
}

#Preview {
    TimerRingView(secondsRemaining: 38, totalSeconds: 60)
        .padding(40)
        .background(AppTheme.Gradients.teamBackground(hex: AppTheme.TeamColors.defaultTeam1))
}
