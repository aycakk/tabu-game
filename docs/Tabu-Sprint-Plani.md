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

- [x] `ScoreBoardView`.
- [x] `RoundSummaryView` (doğru/pas/tabu + net puan + skor tablosu + Devam).
- [x] `GameOverView` (kazanan, final skorları, Tekrar Oyna / Ana Menü).
- [x] `ConfettiView` + beraberlik → "Ani ölüm turu" ekran durumu.

> Sprint 4 notu: `matchEndPlaceholder` kaldırıldı. RootView, `lastRoundResult`'ı "Devam" ile onaylanana kadar hem `.preRound` hem `.gameOver` fazında gösterir — kod izlerken bulunan bir hata, önceden son turun özeti hiç gösterilmeden direkt Oyun Sonu'na atlanıyordu. `PreRoundView` artık `isSuddenDeath` bayrağıyla "ANİ ÖLÜM TURU" pill'i gösterebiliyor. `GameOverView` mockup'ta yok; `RoundSummaryView`'daki görsel dille tutarlı tasarlandı.

## Sprint 5 — Kalıcılık, cila & App Store
Hedef: yayına hazır build.

- [x] SwiftData: `SettingsRecord` (son ayarları hatırla), `MatchResult` (maç geçmişi).
- [x] Cila: geçiş animasyonları, son 10 sn kırmızı/nabız, erişilebilirlik (Dynamic Type, VoiceOver etiketleri).
- [x] App Store: ikon, launch screen, gizlilik etiketi (veri toplanmıyor), ad/sürüm.
- [ ] Ekran görüntüleri (App Store Connect'e yüklenecek) — kullanıcı yapmalı.
- [ ] Cihazda test + son düzeltmeler — bu ortamda gerçek cihaz/dokunmatik erişimi yok, kullanıcı yapmalı.

> Sprint 5 notu: `PersistenceTests` SettingsRecord/MatchResult'ın taze bir ModelContainer'la (uygulama yeniden başlatmayı simüle eder) okunabildiğini doğruluyor. `AppTheme.Fonts` artık Dynamic Type'a göre ölçekleniyor (splashTitle ve timer bilinçli olarak sabit boyutta kaldı). AppIcon programatik üretildi (ImageRenderer, tek görsel/3 slot — dark/tinted varyantları v2'ye bırakıldı). Bu ortamda simülatörde dokunmatik/XCUITest erişimi hâlâ yok; tüm görsel doğrulamalar screenshot + statik inceleme + unit/persistence testleriyle yapıldı. Gerçek cihazda uçtan uca oynanış testi ve App Store ekran görüntüleri kullanıcıya kalıyor.

---

## Bağımlılık özeti

- Sprint 0 → 1: motor, modellere ve deste sağlayıcıya dayanır.
- Sprint 1 → 2: oyun ekranı, çalışan motora bağlanır.
- Sprint 2 → 3: akış, oynanabilir oyunu menüye/kuruluma bağlar.
- Sprint 3 → 4: tur arası ve oyun sonu, tam akışı kapatır.
- Sprint 4 → 5: kalıcılık ve cila en sona kalır (yayın hazırlığı).
