import SwiftUI

/// "Nasıl Oynanır" sayfası — sheet stili, mockup 06.
struct HowToPlayView: View {
    var onClose: () -> Void

    private struct Item {
        let icon: String
        let title: String
        let description: String
        let tintHex: String
    }

    private let items: [Item] = [
        Item(icon: "🎯", title: "Amaç", description: "Karttaki ana kelimeyi takımına anlat — ama doğrudan söyleme.", tintHex: "FF2D78"),
        Item(icon: "🚫", title: "Yasak", description: "Listedeki kelimelerden birini söylersen Tabu olur.", tintHex: "EF4444"),
        Item(icon: "✅", title: "Doğru", description: "Takımın bildiğinde +1 puan, yeni karta geç.", tintHex: "16A34A"),
        Item(icon: "↷", title: "Pas", description: "Zor kelimeyi atla — ama pas hakkın sınırlı.", tintHex: "F59E0B"),
        Item(icon: "⏱️", title: "Süre", description: "Tur süre sınırlı; bitince sıra diğer takıma geçer.", tintHex: "00C2A8"),
        Item(icon: "🏆", title: "Kazanan", description: "Tüm turlar bitince en yüksek skor kazanır; beraberlikte ani ölüm turu.", tintHex: "7C5CFF")
    ]

    var body: some View {
        ZStack(alignment: .top) {
            AppTheme.Colors.surfaceAlt.ignoresSafeArea()

            sheet
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 8)
        }
    }

    private var sheet: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(AppTheme.Colors.handle)
                .frame(width: 38, height: 5)
                .padding(.top, 10)

            HStack {
                Text("Nasıl Oynanır")
                    .font(AppTheme.Fonts.fredoka(26))
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                Spacer()

                Button("Kapat", action: onClose)
                    .font(AppTheme.Fonts.nunitoSans(14, weight: .heavy))
                    .foregroundStyle(AppTheme.Colors.accent)
            }
            .padding(.horizontal, 22)
            .padding(.top, 14)
            .padding(.bottom, 16)

            ScrollView {
                VStack(spacing: 6) {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        row(for: item, showsDivider: index < items.count - 1)
                    }
                }
            }
            .padding(.horizontal, 22)

            Button(action: onClose) {
                Text("Anladım")
                    .font(AppTheme.Fonts.fredoka(20))
                    .foregroundStyle(AppTheme.Colors.textOnBrand)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .background(AppTheme.Gradients.brand)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Corner.button))
                    .shadow(color: AppTheme.Colors.brandMid.opacity(0.55), radius: 16, y: 8)
            }
            .padding(.horizontal, 22)
            .padding(.top, 12)
            .padding(.bottom, 26)
        }
        .background(AppTheme.Colors.card)
        .clipShape(
            UnevenRoundedRectangle(topLeadingRadius: 28, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 28)
        )
    }

    private func row(for item: Item, showsDivider: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 14) {
                Text(item.icon)
                    .font(.system(size: 21))
                    .frame(width: 42, height: 42)
                    .background(Color(hex: item.tintHex).opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(AppTheme.Fonts.nunitoSans(15, weight: .heavy))
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                    Text(item.description)
                        .font(AppTheme.Fonts.nunitoSans(13))
                        .foregroundStyle(AppTheme.Colors.textMuted)
                        .lineSpacing(3)
                }
            }
            .padding(.vertical, 13)

            if showsDivider {
                Rectangle()
                    .fill(AppTheme.Colors.divider)
                    .frame(height: 1)
            }
        }
    }
}

#Preview {
    HowToPlayView(onClose: {})
}
