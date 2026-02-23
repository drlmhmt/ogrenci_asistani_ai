# Firebase & Firestore Kurulum Rehberi

Bu rehber, **Bilgi AI / Öğrenci Asistanı** Flutter projesine Firebase ve Cloud Firestore’u hem **Android** hem **iOS** için adım adım bağlamanızı anlatır. Kod yazmıyorsunuz; sadece tarayıcı ve IDE’de yapacağınız işlemler ve ekleyeceğiniz satırlar anlatılmaktadır.

---

## 1. Gereksinimler

- Flutter SDK yüklü ve `flutter doctor` hatasız (veya sadece Xcode/Android lisansı gibi bilinen uyarılar).
- Bir **Google hesabı** (Firebase Console için).
- **Android**: Android Studio veya en azından SDK yüklü.
- **iOS**: Mac ve Xcode (iOS derlemesi için).

Proje yapısı:

- Android: `android/app/build.gradle.kts` (Kotlin DSL)
- iOS: `ios/Runner/` klasörü
- Uygulama adı: `ogrenci_asistani`
- Android paket adı: `com.example.ogrenci_asistani`

---

## 2. Firebase Console’da Proje Oluşturma

1. Tarayıcıda [Firebase Console](https://console.firebase.google.com/) adresine gidin.
2. Google hesabınızla giriş yapın.
3. **“Proje oluştur”** (veya “Create project”) tıklayın.
4. Proje adı girin (örn. **Bilgi AI** veya **Ogrenci Asistani**).
5. İsterseniz Google Analytics’i açın/kapatın; Firestore için zorunlu değil.
6. Proje oluşturulduktan sonra **Proje genel bakış** sayfasına düşeceksiniz.

---

## 3. Android Uygulamasını Firebase’e Ekleme

1. Firebase Console’da projenizi seçin.
2. Genel bakış sayfasında **Android ikonu** (robot) veya **“Android uygulaması ekle”** seçin.
3. **Android paket adı** alanına şunu yazın (projenizdeki ile aynı olmalı):
   ```text
   com.example.ogrenci_asistani
   ```
4. Uygulama takma adı (örn. **Bilgi AI Android**) isteğe bağlıdır.
5. **“Uygulamayı kaydet”** deyin.
6. **google-services.json** dosyasını indirin.
7. Bu dosyayı projenizde **şu klasöre** kopyalayın (üzerine yazın):
   ```text
   android/app/google-services.json
   ```
   - `android/app/` içinde `build.gradle.kts` ile aynı dizinde olmalı.
8. Sonraki adımda **Firebase SDK** kurulumu için “Sonraki” deyip Android tarafını tamamlayın (aşağıda Flutter tarafında paketleri ekleyeceğiz).

Önemli: Paket adını (applicationId) değiştirirseniz, Firebase Console’da da aynı paket adıyla yeni bir Android uygulaması ekleyip yeni `google-services.json` indirip tekrar `android/app/` içine koymalısınız.

---

## 4. iOS Uygulamasını Firebase’e Ekleme

1. Firebase Console’da aynı projede **iOS ikonu** veya **“iOS uygulaması ekle”** seçin.
2. **iOS paket kimliği (Bundle ID)** istenir. Bunu Xcode’dan veya Flutter projesinden bulabilirsiniz:
   - Flutter projesinde: `ios/Runner.xcodeproj` açılır (Xcode ile) → **Runner** target → **Signing & Capabilities** veya **General** → **Bundle Identifier**.
   - Genelde `com.example.ogrenciAsistani` veya `com.example.ogrenci_asistani` gibi bir değer olur. Projenizde ne yazıyorsa **aynısını** Firebase’e yazın.
3. Uygulama takma adı ve App Store ID isteğe bağlı.
4. **“Uygulamayı kaydet”** deyin.
5. **GoogleService-Info.plist** dosyasını indirin.
6. Bu dosyayı projenize ekleyin:
   - **Kopyalayın:** `ios/Runner/GoogleService-Info.plist`
   - Xcode’da **Runner** projesini açın → sol tarafta **Runner** klasörüne sağ tıklayıp **“Add Files to Runner…”** deyin → indirdiğiniz **GoogleService-Info.plist** dosyasını seçin.
   - **“Copy items if needed”** işaretli olsun; hedef grup **Runner** olsun.
7. Sonraki adımlarda **Firebase SDK** kurulumu için “Sonraki” deyip iOS tarafını tamamlayın.

Not: Bundle ID’yi sonradan değiştirirseniz, Firebase’de yeni Bundle ID ile yeni bir iOS uygulaması ekleyip yeni **GoogleService-Info.plist** indirip projeye eklemeniz gerekir.

---

## 5. Firestore Veritabanını Açma

1. Firebase Console’da sol menüden **“Build”** → **“Firestore Database”** (veya “Firestore Database”) seçin.
2. **“Veritabanı oluştur”** / **“Create database”** deyin.
3. **Güvenlik modu** seçin:
   - **Test modu:** Geliştirme için kısa süreli okuma/yazmaya izin verir (bir süre sonra kapanır).
   - **Üretim modu:** Varsayılan kurallar tüm okuma/yazmayı reddeder; sonra kuralları kendiniz yazarsınız.
   Geliştirme için önce test modu seçebilirsiniz; canlıya geçmeden önce mutlaka [güvenlik kurallarını](https://firebase.google.com/docs/firestore/security/get-started) düzenleyin.
4. Konum seçin (örn. **europe-west1**). Sonradan değiştirmek zor olduğu için bölgeyi dikkatli seçin.
5. **Etkinleştir** deyip Firestore’un açılmasını bekleyin.

Bundan sonra Flutter tarafında `cloud_firestore` ile bu veritabanına bağlanacaksınız.

---

## 6. Flutter Projesine Paket Ekleme

1. Proje kök dizininde **pubspec.yaml** dosyasını açın.
2. **dependencies:** bölümüne aşağıdaki satırları ekleyin (mevcut paketlerin altına):
   ```yaml
   firebase_core: ^3.8.1
   cloud_firestore: ^5.6.0
   ```
   Sürüm numaraları zamanla güncellenir; [pub.dev](https://pub.dev/packages/firebase_core) ve [cloud_firestore](https://pub.dev/packages/cloud_firestore) sayfalarından güncel sürümleri kontrol edebilirsiniz.
3. Terminalde proje kökünde:
   ```bash
   flutter pub get
   ```

---

## 7. Android Gradle Yapılandırması

Projeniz **Kotlin DSL** kullanıyor (`build.gradle.kts`). İki dosyada değişiklik yapacaksınız.

### 7.1. settings.gradle.kts (veya kök build.gradle.kts)

**Dosya:** `android/settings.gradle.kts`

- **plugins { … }** bloğunun **içine**, mevcut plugin satırlarının yanına şunu ekleyin:
  ```kotlin
  id("com.google.gms.google-services") version "4.4.2" apply false
  ```
  Sürüm numarasını [Google’ın dokümantasyonundan](https://developers.google.com/android/guides/google-services-plugin) kontrol edebilirsiniz.

### 7.2. Uygulama build dosyası (app/build.gradle.kts)

**Dosya:** `android/app/build.gradle.kts`

- En üstteki **plugins { … }** bloğunun içine şunu ekleyin (diğer id satırlarının altına):
  ```kotlin
  id("com.google.gms.google-services")
  ```

Sonra proje kökünde:

```bash
flutter clean
flutter pub get
```

Android derlemesi artık `google-services.json` dosyasını kullanacaktır.

---

## 8. iOS Yapılandırması

- **GoogleService-Info.plist** dosyasını 4. adımda **Runner** hedefine eklediyseniz, çoğu Flutter projesinde ekstra bir şey yapmanız gerekmez.
- Minimum iOS sürümü: Firebase paketleri genelde **iOS 12** veya üzeri ister. **ios/Podfile** içinde şu satırı kontrol edin:
  ```ruby
  platform :ios, '12.0'
  ```
  Daha düşükse (örn. 11) **12.0** yapıp kaydedin.
- Terminalde:
  ```bash
  cd ios
  pod install
  cd ..
  ```

---

## 9. Uygulama Başlarken Firebase’i Başlatma (main.dart)

Firebase’in çalışması için uygulama açıldığında **bir kez** başlatılması gerekir.

1. **lib/main.dart** dosyasını açın.
2. En üste (import’ların olduğu yere) şunları ekleyin:
   - `import 'package:firebase_core/firebase_core.dart';`
   - (İsterseniz) `import 'package:cloud_firestore/cloud_firestore.dart';`
3. **main** fonksiyonunu **async** yapın ve **runApp**’ten önce Firebase’i başlatın:
   - `WidgetsFlutterBinding.ensureInitialized();`
   - `await Firebase.initializeApp();`
   - Sonra `runApp(...);`

Örnek akış (sadece mantık; kendi kodunuza uyarlayın):

- `void main()` → `Future<void> main() async { … }`
- İlk satırda: `WidgetsFlutterBinding.ensureInitialized();`
- Ardından: `await Firebase.initializeApp();`
- Sonra: `runApp(const BilgiAIApp());`

Böylece hem Android hem iOS’ta Firebase (ve Firestore) kullanıma hazır olur.

---

## 10. Firestore Kullanımı (Kavramsal)

- Veritabanına erişim: `FirebaseFirestore.instance`
- Koleksiyon: `FirebaseFirestore.instance.collection('koleksiyon_adi')`
- Belge ekleme/güncelleme: `doc(...).set(...)` veya `add(...)`
- Okuma: `get()`, `snapshots()` (gerçek zamanlı dinleme)

Güvenlik için Firestore Console’da **Kurallar (Rules)** sekmesinden kurallarınızı yazın; test modunda bırakmayın.

---

## 11. İsteğe Bağlı: FlutterFire CLI

Tüm konfigürasyonu otomatik üretmek isterseniz:

1. FlutterFire CLI’yı yükleyin:
   ```bash
   dart pub global activate flutterfire_cli
   ```
2. Proje kökünde:
   ```bash
   flutterfire configure
   ```
3. Tarayıcıdan Firebase’e giriş yapıp proje seçin; CLI hem Android hem iOS için config dosyalarını ve `lib/firebase_options.dart` dosyasını oluşturur.
4. main.dart’ta `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);` kullanabilirsiniz.

Bu yöntem **google-services.json** ve **GoogleService-Info.plist**’i sizin yerinize ekleyebilir; yine de yukarıdaki adımları bir kez manuel yapmak, nelerin nereye gittiğini anlamanızı kolaylaştırır.

---

## 12. Kontrol Listesi

- [ ] Firebase Console’da proje oluşturuldu.
- [ ] Android uygulaması eklendi; **google-services.json** indirilip `android/app/` içine kondu.
- [ ] iOS uygulaması eklendi; **GoogleService-Info.plist** indirilip **Runner** hedefine eklendi.
- [ ] Firestore veritabanı oluşturuldu ve konum seçildi.
- [ ] **pubspec.yaml**’a `firebase_core` ve `cloud_firestore` eklendi; `flutter pub get` çalıştırıldı.
- [ ] **android/settings.gradle.kts** (veya ilgili build dosyasına) Google Services plugin eklendi.
- [ ] **android/app/build.gradle.kts**’e `id("com.google.gms.google-services")` eklendi.
- [ ] **main.dart**’ta `WidgetsFlutterBinding.ensureInitialized()` ve `await Firebase.initializeApp()` eklendi.
- [ ] iOS için **Podfile**’da minimum sürüm en az 12.0; `pod install` çalıştırıldı.
- [ ] `flutter run` ile Android ve iOS’ta uygulama sorunsuz açılıyor.

Bu adımları tamamladığınızda uygulamanız Firebase ve Firestore’a bağlı olacaktır. Kod yazmadan sadece bu rehberi takip ederek kurulumu yapabilirsiniz.
