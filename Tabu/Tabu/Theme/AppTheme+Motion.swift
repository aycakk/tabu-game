import SwiftUI

/// Hareket token'ları — süre/eğri/spring sabitleri artık ekran başına tekrarlanmıyor,
/// tek bir yerden anlamlarına göre seçiliyor (bkz. her kategorinin doc-comment'i).
extension AppTheme {
    enum Motion {

        // MARK: - Süreler

        enum Duration {
            static let instant: Double = 0.10
            static let fast: Double = 0.18
            static let base: Double = 0.25
            static let slow: Double = 0.40
            static let deliberate: Double = 0.6
        }

        // MARK: - Eğriler

        enum Curve {
            /// Ekran/route geçişleri.
            static let standard: Animation = .easeInOut(duration: Duration.base)
            /// Kısa, anlık geri bildirimler (stagger reveal adımları gibi).
            static let quick: Animation = .easeOut(duration: Duration.fast)
            /// Daha büyük/ağır içerik geçişleri.
            static let gentle: Animation = .easeInOut(duration: Duration.slow)
        }

        // MARK: - Spring'ler

        enum Spring {
            /// Mikro-etkileşimler: buton basma, swatch seçimi, stepper.
            static let snappy: Animation = .spring(response: 0.28, dampingFraction: 0.7)
            /// Kart fiziği (WordCardView giriş/çıkış).
            static let card: Animation = .spring(response: 0.35, dampingFraction: 0.85)
            /// Kutlama anları (kazanan girişi vb.).
            static let bouncy: Animation = .spring(response: 0.55, dampingFraction: 0.62)
            /// Daha yumuşak, az-overshoot geçişler.
            static let gentle: Animation = .spring(response: 0.45, dampingFraction: 0.9)
        }

        // MARK: - Ambient / sürekli döngüler

        /// Sürekli çalışan (repeatForever) "boşta" animasyonları — hepsi aynı isimle
        /// birden fazla ekranda kullanılıyor, buradan tek noktadan yönetiliyor.
        enum Ambient {
            /// HomeView'daki sparkle ikonunun 360° dönüşü.
            static let sparkleRotation: Animation = .linear(duration: 5).repeatForever(autoreverses: false)
            /// HomeView'daki sparkle ikonunun nabız (scale) efekti.
            static let sparklePulse: Animation = .easeInOut(duration: 1.1).repeatForever(autoreverses: true)
            /// Ana CTA nabzı — HomeView "Yeni Oyun" ve PreRoundView "Başla" ortak kullanır
            /// (öncesinde 0.9s/0.8s olarak ayrışmıştı, tek 0.9s değere birleştirildi).
            static let ctaPulse: Animation = .easeInOut(duration: 0.9).repeatForever(autoreverses: true)
            /// TimerRingView son 10 saniyedeki aciliyet nabzı.
            static let timerUrgencyPulse: Animation = .easeInOut(duration: 0.5).repeatForever(autoreverses: true)
        }

        // MARK: - Zamanlamaya bağlı, "feel" değil "domain" süresi

        /// TimerRingView'ın halka sweep'i — gerçek saniyeyi takip ediyor, bu yüzden
        /// diğer token'ların aksine "hissi iyileştirmek" için DEĞİŞTİRİLMEMELİ.
        static let timerTickSweep: Animation = .linear(duration: 1)

        // MARK: - Konfeti

        enum Confetti {
            static let delayRange: ClosedRange<Double> = 0...0.4
            static let durationRange: ClosedRange<Double> = 1.6...2.6
        }

        // MARK: - Staggered reveal

        /// Bir koleksiyondaki `index`'inci elemanın gecikmesini hesaplar.
        /// `cap`, çok uzun listelerde toplam gecikmenin makul kalmasını sağlar.
        static func staggerDelay(index: Int, step: Double = 0.05, cap: Double = 0.4) -> Double {
            min(Double(index) * step, cap)
        }

        // MARK: - Reduce Motion

        /// reduceMotion açıkken orijinal transition yerine sade bir opacity cross-fade döner.
        static func transition(_ full: AnyTransition, reduceMotion: Bool) -> AnyTransition {
            reduceMotion ? .opacity : full
        }

        /// reduceMotion açıkken orijinal animasyon yerine kısa, sade bir fade döner.
        static func animation(_ full: Animation, reduceMotion: Bool) -> Animation {
            reduceMotion ? .easeInOut(duration: Duration.fast) : full
        }
    }
}
