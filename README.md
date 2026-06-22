# Tabu

Tek cihazda sırayla oynanan (pass-and-play) Türkçe **Tabu** oyunu. Tamamen çevrimdışı, iPhone için bir iOS uygulaması.

> SwiftUI + MVVM + SwiftData · iOS 16+ · dikey (portrait) · üçüncü parti bağımlılık yok.

## Oyun

- İki takım, tek cihaz — telefon elden ele dolaşır.
- Kurulumda **tur sayısı (N)** seçilir → toplam **2N tur**; her takım eşit sayıda (N kez) anlatır.
- Skor **eksiye düşebilir** (tabu cezası).
- Beraberlikte **ani ölüm turu**, eşitlik bozulana dek tekrarlanır.

## Mimari

Tek bir `GameViewModel` tüm motoru (state + timer + skor + sıra + ani ölüm) yönetir. Views sadece aksiyon yollar ve state çizer. Kelime destesi `DeckProviding` protokolü arkasında — MVP'de JSON'dan okunur, v2'de özel desteler (SwiftData) Views/VM değişmeden eklenebilir.

Detaylar: [`Tabu-Mimari.md`](Tabu-Mimari.md)

## Yol planı

5 sprintlik MVP planı — bkz. [`Tabu-Sprint-Plani.md`](Tabu-Sprint-Plani.md).

- **Sprint 0–1:** İskelet, tema, modeller + testle doğrulanmış oyun motoru.
- **Sprint 2:** Oynanabilir tek tur ekranı.
- **Sprint 3:** Menü → kurulum → oyun tam akışı.
- **Sprint 4:** Tur arası özet + oyun sonu.
- **Sprint 5:** Kalıcılık, cila ve App Store yayını.

## Lisans

Henüz belirlenmedi.
