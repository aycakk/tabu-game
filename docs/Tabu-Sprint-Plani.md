# Tabu — Sprint Planı (MVP)

Sıralı — her sprint bir öncekine dayanır. Tek geliştirici için milestone gibi düşün.

**Kilometre taşları:** Sprint 2 sonunda oynanabilir tek tur · Sprint 4 sonunda tam maç.

---

## Sprint 0 — İskelet & temel
Hedef: derlenen boş kabuk + tüm veri ve tema hazır.

- [x] Xcode projesi: iOS 26+ (26.4), SwiftUI, SwiftData; klasör yapısı.
- [x] Fontlar (Fredoka, Nunito Sans) + `Color+Hex` + `AppTheme` (palet, gradyan, tipografi).
- [x] Modeller: `WordCard`, `Team`, `GameSettings`, `GamePhase`, `RoundResult`.
- [x] `deck_tr.json` (10 kartla başlandı; ≥50'ye genişletme kullanıcıda) + `DeckProviding` + `BundledDeckProvider`.
- [x] `Haptics` + boş `RootView`.

> Sprint 0 kararları: deployment target 26.4 · bundle ID `com.aycakayacali.tabu` (personal team) · MVP light-only · palet ve tipografi `docs/Tabu Akış.html` mockup'ından (`AppTheme.swift`).

## Sprint 1 — Oyun motoru
Hedef: UI olmadan, testle doğrulanmış çekirdek mantık.

- [x] `GameViewModel`: state + `startNewGame` / `startRound`.
- [x] `drawCard`, `markCorrect` / `pass` / `markTaboo` (pas limiti).
- [x] Timer + `endRound` + skorlama (eksiye düşebilir).
- [x] Sıra döndürme + 2N tur bitişi + kazanan.
- [x] Ani ölüm mod bayrağı (eşitlik bozulana dek).
- [x] Unit testler: skorlama, tur bitişi, beraberlik.

## Sprint 2 — Oyun ekranı (oynanabilir)
Hedef: tek turu baştan sona oynayabiliyorsun.

- [x] `TimerRingView`, `WordCardView`, `ActionButton`.
- [x] `GameplayView`: kart + doğru sayacı + tur göstergesi (Tur 2/5) + Doğru/Pas/Tabu.
- [x] `PreRoundView` (Sıra sizde → Başla).
- [x] Kart geçiş animasyonu + haptik bağlama.

> Sprint 2 notu: `RootView`'daki "Yeni Oyun" geçici olarak sabit 2 takımla (Kırmızı/Teal, varsayılan ayarlar) direkt oyuna giriyor — gerçek `TeamSetupView` akışı Sprint 3'te bunun yerini alacak. PreRoundView/GameplayView'in simülatörde dokunmatik testi bu ortamda otomatikleştirilemedi (Simulator erişimi + XCUITest sandbox engeli); kullanıcı elle doğrulamalı.

## Sprint 3 — Akış & kurulum
Hedef: menüden başlayıp oyuna giren tam akış.

- [x] `RootView` yönlendirme (home → setup → game → çıkış).
- [x] `HomeView` (Yeni Oyun, Nasıl Oynanır).
- [x] `TeamSetupView` (takım adı + renk swatch'ı; stepper'lar: tur sayısı / süre / pas / ceza).
- [x] `HowToPlayView`.

> Sprint 3 notu: Sprint 2'nin geçici sabit-takım hack'i kaldırıldı; artık gerçek `Route` enum'u (home/teamSetup/howToPlay/game) ile yönlendiriliyor. TeamSetupView'da bir takımın seçtiği renk diğer takımda devre dışı bırakılıyor. `matchEndPlaceholder` hâlâ geçici — Sprint 4'te `RoundSummaryView`/`GameOverView` bunun yerini alacak.

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
