# Tabu — Mimari Dokümanı

SwiftUI + MVVM + SwiftData ile, tek cihazda sırayla oynanan (pass-and-play) Türkçe Tabu oyunu.

---

## Kararlar

- Pass-and-play, iki takım, tek cihaz, tamamen çevrimdışı.
- Kurulumda **tur sayısı (N)** seçilir → toplam **2N tur**; her takım N kez anlatır (eşit hak).
- Skor **eksiye düşebilir** (tabu cezası uygulanır).
- Beraberlikte **tek ani ölüm turu**; eşitlik bozulana dek tekrarlanır.
- **SwiftData** MVP'de hafif kullanılır: son ayarlar + maç geçmişi. Özel desteler v2'de aynı katmana eklenir.
- Tek `GameViewModel` (kurulum + oyun birlikte).
- Hedef: iOS 26+ (deployment target 26.4), dikey (portrait), iPhone-only. Üçüncü parti bağımlılık yok.
- Bundle ID: `com.aycakayacali.tabu`, personal team imzalama (App Store öncesi gözden geçirilecek).

---

## Klasör yapısı

```
Tabu/
├─ TabuApp.swift                 // @main, ModelContainer kurulumu
├─ Models/
│  ├─ WordCard.swift             // struct, Codable (JSON'dan)
│  ├─ Team.swift                 // struct (id, ad, renk, skor)
│  ├─ GameSettings.swift         // struct (turSayısı, süre, pas, ceza)
│  ├─ GamePhase.swift            // enum (setup/preRound/playing/summary/gameOver)
│  ├─ RoundResult.swift          // struct (tur çıktısı)
│  └─ Persistence/
│     ├─ SettingsRecord.swift    // @Model — son ayarlar
│     └─ MatchResult.swift       // @Model — maç geçmişi
├─ ViewModels/
│  └─ GameViewModel.swift        // motor: state + timer + skor + sıra + ani ölüm
├─ Services/
│  ├─ DeckProviding.swift        // protocol
│  ├─ BundledDeckProvider.swift  // deck_tr.json okur
│  └─ Haptics.swift
├─ Views/
│  ├─ RootView.swift             // ekran yönlendirme
│  ├─ HomeView.swift
│  ├─ TeamSetupView.swift
│  ├─ HowToPlayView.swift
│  ├─ Game/
│  │  ├─ GameView.swift          // phase'e göre alt ekran
│  │  ├─ PreRoundView.swift
│  │  ├─ GameplayView.swift
│  │  ├─ RoundSummaryView.swift
│  │  └─ GameOverView.swift
│  └─ Components/
│     ├─ WordCardView.swift
│     ├─ TimerRingView.swift
│     ├─ ScoreBoardView.swift
│     ├─ ActionButton.swift
│     └─ ConfettiView.swift
├─ Theme/
│  ├─ AppTheme.swift             // renk + gradyan + tipografi token
│  └─ Color+Hex.swift
└─ Resources/
   ├─ deck_tr.json
   └─ Fonts/                     // Fredoka + Nunito Sans (SIL OFL, statik ağırlıklar)
```

Not: `Info.plist` xcodeproj yanında açık dosya olarak durur (`UIAppFonts` için; kalan key'ler `GENERATE_INFOPLIST_FILE` ile üretilir).

---

## Katmanlar ve sorumluluklar

### Models — bellekte, değer tipleri
Oyun boyunca yaşar, kaydedilmez.

- `WordCard` — ana kelime + yasak kelimeler.
- `Team` — ad, renk, skor.
- `GameSettings` — tur sayısı (N), süre, pas hakkı, tabu cezası.
- `GamePhase` — faz enum'u (`setup`, `preRound`, `playing`, `roundSummary`, `gameOver`).
- `RoundResult` — turun doğru/pas/tabu sayıları + net puan.

### Persistence — SwiftData `@Model`
Uygulama kapanınca hatırlanması gerekenler.

- `SettingsRecord` — son kullanılan ayarlar; açılışta geri yüklenir.
- `MatchResult` — biten maç (takım adları, skorlar, kazanan, tarih).

### ViewModel
`GameViewModel` (`ObservableObject`, `@MainActor`) — tek motor. Tüm kurallar burada:

- Oyunu / turu başlat.
- `markCorrect()` / `pass()` / `markTaboo()`.
- Turu bitir + skorla (eksiye düşebilir).
- Sırayı döndür.
- 2N tur bitince kazananı belirle.
- Eşitlikte ani ölüm.

Timer ve aktif kart/sayaç state'i bu sınıfta yaşar.

### Services
- `DeckProviding` protokolü (`loadDeck() -> [WordCard]`).
- `BundledDeckProvider` — şimdilik `deck_tr.json` okur. v2'de SwiftData destesi aynı protokolü uygular; Views ve VM değişmez.
- `Haptics` — geri bildirim.

### Views / Theme
Views "aptal" katmandır: aksiyon yollar, state çizer. Theme renk/gradyan/tipografi token'larını tutar.

---

## Tasarım sistemi

Kaynak: `docs/Tabu Akış.html` mockup'ı; token'lar `Theme/AppTheme.swift` içinde.

- **Fontlar:** Fredoka (SemiBold/Bold — başlık, buton, skor) + Nunito Sans (SemiBold/Bold/ExtraBold/Black — gövde, etiket).
- **Palet:** pageBg `#E7E5DF` · surface `#F4F5FB` · textPrimary `#1F2937` · textMuted `#6B7280` · accent `#00C2A8` · success `#16A34A` · warning `#F59E0B` · danger `#EF4444`.
- **Marka gradyanı:** `#FF2D78 → #FF7A1A → #FFC53D` (135°).
- **Takım swatch'ları (6):** `#FF5A5F` `#00C2A8` `#7C5CFF` `#FFB400` `#19A7FF` `#FF4FA3`. Tur ekranı arka planı takım renginden ×0.58 koyulaştırmayla türetilir.
- **Köşeler:** kart 28 · buton 22 · tile 18 · chip 14.
- MVP light-only; dark mode v2.

## Deste JSON şeması

```json
{ "version": 1, "language": "tr",
  "cards": [
    { "word": "Plaj", "forbidden": ["Kum", "Deniz", "Güneş", "Şemsiye", "Tatil"] }
  ]}
```

Kart `id`'si JSON'da tutulmaz; decode sırasında üretilir. Yasak kelime sayısı 5 sabittir. MVP 10 kartla başlar; içerik genişletme kullanıcıda.

## SwiftData şeması

- `SettingsRecord(roundCount, roundDuration, passLimit, tabooPenalty)` — tek kayıt, üzerine yazılır.
- `MatchResult(date, teamNames, scores, winnerName)` — her maç bir kayıt; geçmiş listesi (v2 ekranı).

---

## Veri akışı

1. `RootView`, `ModelContainer`'ı kurar, `GameViewModel`'i `@StateObject` tutar, `SettingsRecord`'dan son ayarları yükler.
2. Kurulum ekranı takım/ayarları VM'e yazar → "Başla" → `startNewGame()` (deste `DeckProviding`'den yüklenir ve karılır).
3. Oyun ekranı butonları VM'e aksiyon yollar → VM `@Published` state'i günceller → View yeniden çizilir.
4. Süre 0 → VM turu bitirir, `RoundResult` üretir, skoru ekler, sırayı döndürür.
5. 2N tur bitince kazananı belirler; eşitse `suddenDeath` modunu açıp berabere takımlarla eşitlik bozulana dek ek tur oynatır.
6. Oyun sonunda ayarları (`SettingsRecord`) ve maçı (`MatchResult`) `ModelContext`'e kaydeder.

---

## Notlar

- **Ani ölüm ayrı bir faz değil** — motorda bir mod bayrağı (`isSuddenDeath` + berabere takım listesi). Böylece fazlar sade kalır; ani ölüm normal tur döngüsünü yeniden kullanır.
- **Deck protokolü** sayesinde v2 özel desteleri Views/VM'i hiç değiştirmeden devreye girer.

---

## Yol haritası (v2+)

- Kendi kelime destesini oluşturma (SwiftData).
- Kategori paketleri (film, spor, bilim…).
- Ses efektleri.
- Maç geçmişi / Game Center.
- Çoklu dil, iPad düzeni.
