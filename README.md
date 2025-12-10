# 🤖 AI Sticker Companion App: Ruphas

Aplikasi companion berbasis chat yang memanfaatkan Large Language Model (LLM) untuk interaksi emosional. Karakter companion Ruphas bereaksi secara visual menggunakan stiker 2D berdasarkan analisis mood pengguna.

---

## ✨ Fitur Utama

* **Integrasi LLM Service (Dio):** Mengirimkan dan menerima respons dari LLM eksternal (menggunakan Dio untuk HTTP request).

* **State Management:** Menggunakan Flutter Riverpod untuk mengelola state chat dan state ekspresi Avatar secara reaktif.

* **Reaksi Emosional 2D (Stiker):** Avatar secara instan mengubah ekspresi visualnya (Senang, Sedih, Bingung, dll.) berdasarkan kata kunci dalam percakapan.

* **Antarmuka Sederhana & Bersih:** Desain chat yang bersih dan minimalis (Warna Pink/Putih) dengan fokus pada interaksi.

---

## ⚙️ Persyaratan Sistem

Untuk menjalankan proyek ini, pastikan Anda telah menginstal:

* **Flutter SDK:** Versi 3.2.0 atau lebih tinggi.
* **Dart SDK:** Versi 3.2.0 atau lebih tinggi.
* **Android Studio atau VS Code** dengan plugin Flutter dan Dart.

---

## 🛠️ Langkah-langkah Setup (Lokal)

1. **Kloning Repositori**

```bash
https://github.com/Lufasu-Adm/AI-Stickers-Companion.git
cd ai_companion_app
```

2. **Dapatkan Dependencies**

Jalankan perintah ini di terminal proyek untuk mengunduh semua paket yang diperlukan (riverpod, dio, dll.):

```bash
flutter pub get
```

3. **Konfigurasi LLM Service**

Aplikasi ini bergantung pada layanan LLM eksternal. Anda harus mengedit file `llm_service.dart` untuk memasukkan URL endpoint API dan API Key Anda:

**File:** `lib/data/services/llm_service.dart`

Pastikan Anda telah mengisi header otorisasi dan endpoint yang benar di dalam class `LlmService`.

4. **Menjalankan Aplikasi**

Pastikan emulator Android/iOS atau perangkat fisik Anda terhubung, lalu jalankan:

```bash
flutter run
```

---

## 🖼️ Struktur Aset Avatar (Stiker 2D)

Avatar companion Ruphas menggunakan stiker 2D untuk reaksi cepat. Semua stiker dimuat dari path berikut:

**Folder**

```
assets/3d/stikcers/
```

Berisi semua file `.png` ekspresi (bingung.png, tertawa.png, dll.).

---

## 📚 Teknologi yang Digunakan

* Flutter & Dart
* Riverpod: State Management
* Dio: HTTP Networking
* Flutter Animate: Efek animasi sederhana (jika digunakan)
