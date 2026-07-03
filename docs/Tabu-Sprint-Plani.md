# Tabu — Sprint Planı (MVP)

Sıralı — her sprint bir öncekine dayanır. Tek geliştirici için milestone gibi düşün.

**Kilometre taşları:** Sprint 2 sonunda oynanabilir tek tur · Sprint 4 sonunda tam maç.

---

## Sprint 0 — İskelet & temel
Hedef: derlenen boş kabuk + tüm veri ve tema hazır.

- [ ] Xcode projesi: iOS 16+, SwiftUI, SwiftData; klasör yapısı.
- [ ] Fontlar (Fredoka, Nunito) + `Color+Hex` + `AppTheme` (palet, gradyan, tipografi).
- [ ] Modeller: `WordCard`, `Team`, `GameSettings`, `GamePhase`, `RoundResult`.
- [ ] `deck_tr.json` (≥50 kart) + `DeckProviding` + `BundledDeckProvider`.
- [ ] `Haptics` + boş `RootView`.

## Sprint 1 — Oyun motoru
Hedef: UI olmadan, testle doğrulanmış çekirdek mantık.

- [ ] `GameViewModel`: state + `startNewGame` / `startRound`.
- [ ] `drawCard`, `markCorrect` / `pass` / `markTaboo` (pas limiti).
- [ ] Timer + `endRound` + skorlama (eksiye düşebilir).
- [ ] Sıra döndürme + 2N tur bitişi + kazanan.
- [ ] Ani ölüm mod bayrağı (eşitlik bozulana dek).
- [ ] Unit testler: skorlama, tur bitişi, beraberlik.

## Sprint 2 — Oyun ekranı (oynanabilir)
Hedef: tek turu baştan sona oynayabiliyorsun.

- [ ] `TimerRingView`, `WordCardView`, `ActionButton`.
- [ ] `GameplayView`: kart + doğru sayacı + tur göstergesi (Tur 2/5) + Doğru/Pas/Tabu.
- [ ] `PreRoundView` (Sıra sizde → Başla).
- [ ] Kart geçiş animasyonu + haptik bağlama.

## Sprint 3 — Akış & kurulum
Hedef: menüden başlayıp oyuna giren tam akış.

- [ ] `RootView` yönlendirme (home → setup → game → çıkış).
- [ ] `HomeView` (Yeni Oyun, Nasıl Oynanır).
- [ ] `TeamSetupView` (takım adı + renk swatch'ı; stepper'lar: tur sayısı / süre / pas / ceza).
- [ ] `HowToPlayView`.

## Sprint 4 — Tur arası & oyun sonu
Hedef: tam maç döngüsü uçtan uca (beraberlik dahil).

- [ ] `ScoreBoardView`.
- [ ] `RoundSummaryView` (doğru/pas/tabu + net puan + skor tablosu + Devam).
- [ ] `GameOverView` (kazanan, final skorları, Tekrar Oyna / Ana Menü).
- [ ] `ConfettiView` + beraberlik → "Ani ölüm turu" ekran durumu.

## Sprint 5 — Kalıcılık, cila & App Store
Hedef: yayına hazır build.

- [ ] SwiftData: `SettingsRecord` (son ayarları hatırla), `MatchResult` (maç geçmişi).
- [ ] Cila: geçiş animasyonları, son 10 sn kırmızı/nabız, erişilebilirlik (Dynamic Type, VoiceOver etiketleri).
- [ ] App Store: ikon, launch screen, gizlilik etiketi (veri toplanmıyor), ad/sürüm, ekran görüntüleri.
- [ ] Cihazda test + son düzeltmeler.

---

## Bağımlılık özeti

- Sprint 0 → 1: motor, modellere ve deste sağlayıcıya dayanır.
- Sprint 1 → 2: oyun ekranı, çalışan motora bağlanır.
- Sprint 2 → 3: akış, oynanabilir oyunu menüye/kuruluma bağlar.
- Sprint 3 → 4: tur arası ve oyun sonu, tam akışı kapatır.
- Sprint 4 → 5: kalıcılık ve cila en sona kalır (yayın hazırlığı).
