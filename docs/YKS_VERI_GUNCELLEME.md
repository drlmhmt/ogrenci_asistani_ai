# YKS Veri Güncelleme Rehberi

Bu doküman, uygulamadaki YKS (TYT/AYT) sınav verilerinin her yıl nasıl güncelleneceğini açıklar.

## Veri Yapısı Özeti

```
YksExamSeason (2025)
├── TYT (120 soru)
│   ├── Türkçe (40 soru) → Konular (ortalama soru sayısı ile)
│   ├── Matematik (40 soru) → Konular
│   ├── Sosyal Bilimler: Tarih(5), Coğrafya(5), Felsefe(5), Din(5)
│   └── Fen Bilimleri: Fizik(7), Kimya(7), Biyoloji(6)
└── AYT (160 soru)
    ├── Sayısal: Matematik, Fizik, Kimya, Biyoloji
    ├── Eşit Ağırlık: Matematik, Edebiyat, Tarih, Coğrafya
    └── Sözel: Edebiyat, Tarih, Coğrafya, Tarih-2, Coğrafya-2, Felsefe, Din
```

## Güncel Veri Kaynakları

### 1. ÖSYM (Resmi)
- **Adres:** https://www.osym.gov.tr → Sınav Soru ve Cevapları
- **Ne verir:** Sadece soru kitapçıkları ve cevap anahtarları
- **Konu dağılımı:** ÖSYM konu bazlı dağılım yayınlamaz

### 2. Konu Bazlı Analiz (3. parti)
ÖSYM soru kitapçıklarından manuel analiz yapan siteler:
- [Koçum be!](https://www.kocumbe.com/konu-dagilimlari) – TYT/AYT konu dağılımı
- [Rehberim Sensin](https://www.rehberimsensin.com/yks-konulari-ve-soru-dagilimi)
- [Özel Ders Alanı](https://www.ozeldersalani.com/yks-tyt---ayt-soru-dagilimi)

Bu siteler genelde **son 5 yıl** ortalaması verir. Her yıl sınav sonrası güncellenir.

---

## Güncelleme Yöntemleri

### Yöntem 1: JSON Dosyası (Basit, Uygulama Güncellemesi Gerekir)

**Ne zaman:** Her yıl sınav sonrası (Haziran–Temmuz)

**Adımlar:**
1. `assets/data/yks_2025_example.json` dosyasını kopyala → `yks_2026_example.json`
2. Yeni yılın konu–soru dağılımını yukarıdaki sitelerden al
3. JSON’u güncelle
4. `YksDataService` içinde varsayılan dosya adını değiştir
5. Uygulama güncellemesi yayınla

**Artı:** Basit, offline çalışır  
**Eksi:** Her yıl yeni sürüm gerekir

---

### Yöntem 2: Firebase Firestore (Önerilen, Uzaktan Güncelleme)

**Ne zaman:** İstediğiniz zaman, uygulama güncellemesi gerekmez

**Adımlar:**

1. **Firestore yapısı:**
   ```
   koleksiyon: yks_exam_data
   belge: current
   alanlar: year, updatedAt, exams (array)
   ```

2. **Güncelleme seçenekleri:**
   - **Firebase Console:** Firestore → `yks_exam_data` → `current` → Düzenle
   - **Admin script:** Aşağıdaki örnek script ile JSON’u Firestore’a yükle
   - **Admin paneli:** İleride web paneli ile yönetim

3. **Örnek güncelleme scripti (Node.js):**
   ```javascript
   const admin = require('firebase-admin');
   const fs = require('fs');
   
   admin.initializeApp({ credential: admin.credential.applicationDefault() });
   const db = admin.firestore();
   
   const data = JSON.parse(fs.readFileSync('yks_2026.json', 'utf8'));
   db.collection('yks_exam_data').doc('current').set(data);
   ```

4. **Flutter tarafı:** `YksDataService` önce Firestore’a bakar, veri yoksa assets’e düşer.

**Artı:** Uzaktan güncelleme, anında yansır  
**Eksi:** Firebase kullanımı gerekir

---

### Yöntem 3: Firebase Storage + JSON

**Ne zaman:** Firestore kullanmak istemiyorsanız

**Adımlar:**
1. `yks_current.json` dosyasını Firebase Storage’a yükle
2. Flutter’da `firebase_storage` ile indir
3. Parse edip `YksExamSeason` olarak kullan

**Artı:** Basit, Firestore maliyeti yok  
**Eksi:** Cache stratejisi kendiniz yazmalısınız

---

## Yıllık Güncelleme Takvimi

| Dönem        | Yapılacaklar |
|-------------|--------------|
| **Haziran** | ÖSYM sınavı yapılır |
| **Temmuz**  | 3. parti siteler konu analizini yayınlar |
| **Ağustos** | JSON/Firestore verisini güncelle |
| **Eylül**   | Yeni dönem öğrencileri güncel veriyle başlar |

---

## Veri Toplama İpuçları

1. **Ortalama soru sayısı:** Tek yıl yerine son 3–5 yıl ortalaması daha tutarlıdır.
2. **MEB müfredatı:** Konu isimleri MEB müfredatıyla uyumlu olmalı.
3. **Geometri:** 2025’ten itibaren TYT/AYT’de geometri matematik testine dahil.
4. **YDT:** İngilizce vb. dil sınavı ayrı; bu model sadece TYT–AYT için.

---

## Örnek: Yeni Yıl JSON Oluşturma

`assets/data/` altında `yks_2026_example.json` oluştururken:

1. `year`: `"2026"`
2. `updatedAt`: Güncel tarih (ISO 8601)
3. `exams`: TYT ve AYT için `subjects` ve `topics` dizileri
4. Her konu: `id`, `name`, `averageQuestionCount`, `order`

Referans: `yks_2025_example.json`
