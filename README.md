# Video Demo App :
https://drive.google.com/file/d/17Dc5TvQfVxx2xD2o1Wu5X8c3iNUkpoxU/view?usp=drivesdk

# LaporPak - Platform Pengaduan Masyarakat

**LaporPak** adalah aplikasi Flutter modern untuk manajemen pengaduan masyarakat yang memungkinkan warga untuk melaporkan keluhan mereka dan pemerintah/petugas untuk menangani dan menyelesaikan pengaduan secara efisien.

## 📱 Tentang Aplikasi

LaporPak dirancang sebagai solusi digital yang menghubungkan masyarakat dengan pemerintah/institusi publik. Aplikasi ini menggunakan Flutter untuk memastikan kompatibilitas lintas platform dan memberikan pengalaman pengguna yang seamless.

### Teknologi yang Digunakan

- **Framework**: Flutter (Material Design 3)
- **Language**: Dart (Null-safe)
- **State Management**: setState()
- **Data Storage**: In-memory collections (siap untuk integrasi backend)
- **Desain**: Modern, responsive, user-friendly interface

---

## 👥 Fitur Utama Berdasarkan Role

### 1. **Masyarakat (Laporan)**

#### Dashboard Masyarakat Enhanced
- **Riwayat Pengaduan**: Lihat semua pengaduan yang telah dibuat dengan status real-time
- **Filter & Pencarian**: Filter berdasarkan status (Baru, Proses, Selesai) dan kategori
- **Statistik Pengaduan**: 
  - Total pengaduan dibuat
  - Pengaduan selesai
  - Pengaduan dalam proses
  - Persentase penyelesaian
  
#### Buat Pengaduan Baru (Report Form)
- Form pengaduan dengan kategori lengkap:
  - Fasilitas Umum
  - Pungutan Liar
  - Layanan Publik
  - Infrastruktur
  - Lainnya
- Upload foto/bukti pengaduan
- Input detail lokasi dan deskripsi
- Validasi form otomatis

#### Detail Pengaduan
- Status pengaduan real-time
- Komentar dari petugas/admin
- Lampiran dan bukti visual
- Timeline aktivitas pengaduan
- Like/voting untuk pengaduan

#### Fitur Komunikasi
- Chat dengan petugas yang menangani pengaduan
- Notifikasi update pengaduan
- Riwayat percakapan terorganisir

#### Profil
- Informasi profil pengguna
- Riwayat login
- Pengaturan akun

---

### 2. **Admin (Pengelola)**

#### Dashboard Admin Enhanced
- **Statistik Komprehensif**:
  - Total pengaduan di sistem
  - Pengaduan berdasarkan status (Baru, Proses, Selesai)
  - Pengaduan berdasarkan kategori
  - Tren pengaduan trending
  - Data analitik visualisasi

#### Manajemen Pengaduan
- Lihat semua pengaduan dari seluruh masyarakat
- Filter berdasarkan status, kategori, tanggal
- Pencarian lanjutan (Advanced Search):
  - Pencarian berdasarkan keyword
  - Filter range tanggal
  - Filter kategori spesifik
- Export data pengaduan ke CSV
- Sorting fleksibel (terbaru, trending, kategori)

#### Assigning Petugas
- Halaman khusus untuk assign pengaduan ke petugas
- Tampilkan daftar petugas dan beban kerja mereka
- Assign multiple pengaduan secara efisien
- Tracking assignment status

#### Analitik & Reporting
- Dashboard dengan visualisasi data
- Statistik penyelesaian pengaduan
- Laporan tren pengaduan
- Export bulk data untuk analisis lebih lanjut

#### Notifikasi & Alerts
- Notifikasi pengaduan baru
- Alert pengaduan yang overdue
- Update status pengaduan real-time

#### Manajemen Komentar & Attachment
- Lihat dan kelola komentar dari masyarakat
- Manage file lampiran
- Verifikasi konten pengaduan

---

### 3. **Petugas (Penanganan)**

#### Dashboard Petugas Enhanced
- **Statistik Tugas Personal**:
  - Total tugas yang di-assign
  - Tugas baru yang belum diproses
  - Tugas dalam proses
  - Tugas selesai
  - Completion rate personal

#### Daftar Tugas Terpersonalisasi
- Hanya melihat pengaduan yang di-assign ke petugas tersebut
- Filter status tugas (Baru, Proses, Selesai)
- Sort berdasarkan:
  - Terbaru
  - Status prioritas (Baru → Proses → Selesai)
  - Belum diproses
- Card tugas dengan detail ringkas

#### Tab Performa
- Visualisasi progress completion rate dengan circular progress indicator
- Metrics personal:
  - Total tugas
  - Tugas selesai
  - Tugas dalam proses
- Tips meningkatkan performa
- Tracking KPI personal

#### Tab Aktivitas
- Timeline riwayat semua tugas yang ditangani
- Visualisasi timeline dengan status updates
- Tracking progress per pengaduan
- Sorted by date (terbaru di atas)

#### Manajemen Detail Pengaduan
- Update status pengaduan (Baru → Proses → Selesai)
- Tambah komentar untuk masyarakat
- Upload bukti penyelesaian
- Attach file/dokumentasi
- Komunikasi langsung dengan pelapor

---

## 🏠 Landing Page (Home Screen)

### Fitur Home Screen
- **Hero Section**: Branding dan value proposition aplikasi
- **Statistik Platform Real-time**:
  - Total pengaduan di sistem
  - Pengaduan terselesaikan
  - Pengaduan dalam proses
  - Jumlah kategori
- **Breakdown Kategori**: Daftar semua kategori pengaduan dengan jumlah
- **Fitur Unggulan**:
  - Aman & Terpercaya
  - Respons Cepat
  - Transparan
  - Dukungan 24/7
- **Call-to-Action**: Tombol Login dan Register
- **Footer**: Informasi kontak

---

## 🎨 Desain UI/UX

### Fitur Desain
- **Modern Login/Register Screen**
  - Gradient background (blue theme)
  - Centered card design
  - Demo account info untuk testing
  - Form validation real-time
  
- **Color Scheme**
  - Primary: Blue (#0A84FF) - untuk masyarakat
  - Secondary: Orange - untuk petugas
  - Success: Green - untuk status selesai
  - Warning: Orange - untuk status proses
  - Info: Purple - untuk status baru

- **Responsive Layout**
  - Mobile-first design
  - Adaptive untuk tablet
  - Bottom navigation untuk navigasi utama
  - Drawer/menu untuk opsi tambahan

---

## 📁 Struktur Project

```
lib/
├── main.dart                           # Entry point aplikasi
├── models/
│   ├── user.dart                      # Model user (masyarakat, admin, petugas)
│   ├── pengaduan.dart                 # Model pengaduan/laporan
│   ├── notification.dart              # Model notifikasi & comment & attachment
├── services/
│   ├── auth_service.dart              # Authentication & user management
│   ├── pengaduan_service.dart         # Pengaduan management & analytics
│   ├── chat_service.dart              # Chat/messaging service
│   ├── notification_service.dart      # Notification & comment management
├── screens/
│   ├── home_screen.dart               # Landing page
│   ├── login_screen_v2.dart           # Modern login screen
│   ├── register_screen_v2.dart        # Modern register screen
│   ├── masyarakat_dashboard_enhanced_screen.dart
│   ├── admin_dashboard_enhanced_screen.dart
│   ├── petugas_dashboard_enhanced_screen.dart
│   ├── pengaduan_detail_screen.dart   # Detail pengaduan
│   ├── report_form_screen.dart        # Form buat pengaduan
│   ├── notification_screen.dart       # Notification list
│   ├── chat_screen.dart               # Chat interface
│   ├── profile_screen.dart            # User profile
│   ├── admin_assign_petugas_screen.dart
├── widgets/
│   ├── custom_button.dart             # Reusable button widget
│   ├── custom_text_field.dart         # Reusable text field
│   ├── custom_app_bar.dart            # Custom app bar
│   ├── pengaduan_card.dart            # Pengaduan list item
│   ├── comment_card.dart              # Comment display
│   ├── attachment_widget.dart         # File attachment display
│   ├── statistics_card.dart           # Stats visualization
│   ├── chat_bubble.dart               # Chat message bubble
│   └── loading_dialog.dart            # Loading indicator
```

---

## 🚀 Cara Menjalankan

### Prerequisites
- Flutter SDK (latest stable)
- Dart SDK
- VS Code atau Android Studio

### Installation

```bash
# 1. Clone repository
git clone <repository-url>
cd laporpak

# 2. Get dependencies
flutter pub get

# 3. Run aplikasi
flutter run -d chrome          # Web
flutter run -d android         # Android
flutter run -d ios             # iOS

# 4. Build APK/IPA
flutter build apk              # Android APK
flutter build ios              # iOS app
```

---

## 🧪 Demo Account

Gunakan akun berikut untuk testing:

| Role | Email | Password |
|------|-------|----------|
| **Masyarakat** | masyarakat@example.com | masyarakat123 |
| **Admin** | admin@example.com | admin123 |
| **Petugas** | petugas@example.com | petugas123 |

---

## 🔮 Pengembangan Masa Depan

### 1. **Backend Integration**
- Implementasi REST API / GraphQL
- Database integration (Firebase, PostgreSQL, MongoDB)
- Cloud storage untuk file uploads
- Real-time synchronization dengan Firestore/Realtime Database

### 2. **Authentication & Security**
- OAuth 2.0 / Social login (Google, GitHub)
- Two-factor authentication (2FA)
- JWT token management
- Biometric authentication (fingerprint, face recognition)
- Role-based access control (RBAC) yang lebih sophisticated

### 3. **Notification System**
- Push notification real-time
- Email notifications
- SMS alerts untuk pengaduan urgent
- FCM (Firebase Cloud Messaging) integration
- In-app notification center

### 4. **Analytics & Dashboard**
- Advanced analytics dashboard
- Data visualization (charts, graphs, heatmaps)
- Report generation (PDF export)
- Business intelligence dashboard
- Predictive analytics untuk trending issues

### 5. **Fitur Komunitas**
- Discussion forum per kategori pengaduan
- Rating/review petugas
- Upvote/downvote untuk trending issues
- Leaderboard petugas terbaik
- Community badges & achievements

### 6. **Location & Mapping**
- Google Maps integration
- Geolocation tagging untuk pengaduan
- Heat map pengaduan berdasarkan area
- Route optimization untuk petugas
- Location-based notifications

### 7. **Advanced Search & Filter**
- Full-text search
- Filter by multiple criteria
- Saved searches
- Smart recommendations
- Search history

### 8. **Workflow & Automation**
- Automated status transitions
- SLA management (Service Level Agreement)
- Escalation rules
- Batch operations
- Scheduled reports

### 9. **Integration Features**
- WhatsApp Business API integration
- Telegram bot untuk notifications
- Email integration untuk auto-reply
- Calendar integration untuk scheduling
- CRM system integration

### 10. **Performance & Offline**
- Offline-first architecture
- Local caching dengan Hive/SQLite
- Background sync
- Progressive Web App (PWA) features
- Performance optimization

### 11. **Accessibility & Localization**
- Multi-language support (Indonesia, English, etc)
- Dark mode theme
- Accessibility features (screen reader support)
- High contrast mode
- Font size customization

### 12. **Admin Features**
- User management dashboard
- Role and permission management
- System settings configuration
- Audit logs
- System health monitoring
- Bulk operations (import/export)

### 13. **Petugas Features**
- Mobile app native (Android/iOS)
- Offline task access
- Camera integration untuk foto langsung
- GPS tracking untuk field operations
- Time tracking untuk setiap tugas
- Performance metrics personal

### 14. **Masyarakat Features**
- Follow notification untuk kategori tertentu
- Bookmark pengaduan penting
- Share pengaduan ke social media
- Newsletter/digest mingguan
- Feedback ratings untuk pengaduan selesai

### 15. **DevOps & Deployment**
- CI/CD pipeline (GitHub Actions, GitLab CI)
- Docker containerization
- Kubernetes orchestration
- Load balancing
- Auto-scaling
- Health checks & monitoring

---

## 📝 Catatan Teknis

### Data Persistence
Saat ini aplikasi menggunakan in-memory data storage. Untuk production, implementasi backend API dan database adalah prioritas utama.

### State Management
Aplikasi saat ini menggunakan `setState()`. Untuk scalability, pertimbangkan migrasi ke:
- Provider package
- Riverpod
- BLoC pattern
- GetX

### Testing
Tambahkan comprehensive testing:
- Unit tests
- Widget tests
- Integration tests
- E2E tests

---

## 🤝 Kontribusi

Untuk pengembangan lebih lanjut:
1. Fork repository
2. Buat feature branch
3. Commit changes
4. Push ke branch
5. Create Pull Request

---

## 📄 Lisensi

Project ini open source dan dapat digunakan untuk keperluan pendidikan dan development.

---

## 📞 Support

Untuk pertanyaan atau bug report:
- Email: qildanfauzan266@gmail.coom

---

**Dibuat dengan ❤️ menggunakan Flutter**

Terakhir diupdate: January 30, 2026
