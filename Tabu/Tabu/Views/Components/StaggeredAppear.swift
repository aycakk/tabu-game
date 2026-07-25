import SwiftUI

/// Bir koleksiyondaki elemanı `index`e göre kademeli gecikmeyle açılışta belirtir —
/// HowToPlayView satırları, TeamSetupView swatch'ları, ScoreBoardView satırları,
/// RoundSummaryView istatistik karoları gibi küçük/sabit boyutlu koleksiyonlar için.
private struct StaggeredAppear: ViewModifier {
    let index: Int
    @State private var hasAppeared = false

    func body(content: Content) -> some View {
        content
            .opacity(hasAppeared ? 1 : 0)
            .offset(y: hasAppeared ? 0 : 6)
            .onAppear {
                withAnimation(AppTheme.Motion.Curve.quick.delay(AppTheme.Motion.staggerDelay(index: index))) {
                    hasAppeared = true
                }
            }
    }
}

extension View {
    func staggerAppear(index: Int) -> some View {
        modifier(StaggeredAppear(index: index))
    }
}
