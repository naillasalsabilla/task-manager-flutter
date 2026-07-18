# Task Manager Flutter

Aplikasi Task Manager berbasis mobile yang dikembangkan menggunakan Flutter dan Dart. Aplikasi ini dibuat untuk membantu pengguna dalam mengelola tugas secara lebih terorganisir.

## 📱 Fitur Aplikasi

* Registrasi pengguna
* Login pengguna
* Menampilkan daftar task
* Menambahkan task
* Mengedit task
* Menghapus task
* Pengelolaan data task
* State management menggunakan Provider
* Firebase Authentication
* Layanan notifikasi

## 🛠️ Teknologi yang Digunakan

* Flutter
* Dart
* Firebase Authentication
* Provider
* Database
* Notification Service

## 📂 Struktur Project

```text
lib/
├── database/
│   └── database_helper.dart
├── providers/
│   ├── task_provider.dart
│   └── auth_provider.dart
├── models/
│   └── task.dart
├── screens/
│   ├── add_task_screen.dart
│   ├── edit_task_screen.dart
│   ├── register_screen.dart
│   ├── login_screen.dart
│   └── home_screen.dart
├── services/
│   └── notification_service.dart
├── widgets/
│   └── task_card.dart
└── main.dart
```

## 🚀 Cara Menjalankan Project

### 1. Clone Repository

```bash
git clone https://github.com/naillasalsabilla/task-manager-flutter.git
```

### 2. Masuk ke Folder Project

```bash
cd task-manager-flutter
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Jalankan Aplikasi

```bash
flutter run
```

## 📝 Alur Penggunaan Aplikasi

1. Pengguna membuka aplikasi.
2. Pengguna melakukan registrasi jika belum memiliki akun.
3. Pengguna melakukan login.
4. Pengguna masuk ke halaman utama.
5. Pengguna dapat menambahkan task.
6. Pengguna dapat mengedit dan menghapus task.
7. Data task dikelola melalui sistem database.

## 🧪 Pengujian

Pengujian aplikasi dilakukan menggunakan metode **Black Box Testing**.

| Fitur            | Status   |
| ---------------- | -------- |
| Registrasi       | Berhasil |
| Login            | Berhasil |
| Menambahkan Task | Berhasil |
| Menampilkan Task | Berhasil |
| Mengedit Task    | Berhasil |
| Menghapus Task   | Berhasil |
| Notifikasi       | Berhasil |

## 📄 Dokumentasi

Dokumentasi dan laporan project tersedia di repository ini dalam bentuk file laporan.

## 👤 Author

**Nailla Salsabilla**

## 📌 Status Project

**Completed**
