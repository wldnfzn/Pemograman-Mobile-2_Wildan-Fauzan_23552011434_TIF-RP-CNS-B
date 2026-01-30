import 'package:laporpak/models/pengaduan.dart';
import 'dart:math';

class PengaduanService {
  static final PengaduanService _instance = PengaduanService._internal();

  factory PengaduanService() {
    return _instance;
  }

  PengaduanService._internal();

  // Simulated database
  final List<Pengaduan> pengaduans = [];

  // Initialize with dummy data
  void initializeDummyPengaduans() {
    if (pengaduans.isEmpty) {
      final now = DateTime.now();
      pengaduans.addAll([
        Pengaduan(
          id: _generateId(),
          title: 'Jalan berlubang di Jl. Merdeka',
          description:
              'Jalan di depan kantor kelurahan berlubang dan berbahaya bagi pengendara. Sudah ada yang celaka.',
          category: 'Fasilitas Umum',
          reporterUserId: 'user_demo_1',
          reporterName: 'Budi Santoso',
          reporterNik: '1234567890123456',
          status: 'Proses',
          createdAt: now.subtract(Duration(days: 5)),
          likes: 23,
          likedByUserIds: [],
        ),
        Pengaduan(
          id: _generateId(),
          title: 'Tarif angkot tidak resmi di Halte Blok M',
          description:
              'Sopir angkot mengenakan tarif melebihi ketentuan resmi. Pengguna diminta membayar Rp 10.000 padahal seharusnya Rp 5.000.',
          category: 'Pungutan Liar',
          reporterUserId: 'user_demo_1',
          reporterName: 'Budi Santoso',
          reporterNik: '1234567890123456',
          status: 'Selesai',
          createdAt: now.subtract(Duration(days: 10)),
          likes: 15,
          likedByUserIds: [],
        ),
        Pengaduan(
          id: _generateId(),
          title: 'Lampu jalan tidak menyala di Jl. Sudirman',
          description: 'Lampu jalan tidak berfungsi di beberapa titik, membuat area gelap dan tidak aman.',
          category: 'Fasilitas Umum',
          reporterUserId: 'user_demo_2',
          reporterName: 'Siti Nurhaliza',
          reporterNik: '1234567890123459',
          status: 'Proses',
          createdAt: now.subtract(Duration(days: 3)),
          likes: 31,
          likedByUserIds: [],
        ),
        Pengaduan(
          id: _generateId(),
          title: 'Bak sampah penuh dan tidak dikosongkan',
          description: 'Bak sampah di taman kota penuh dengan sampah dan tidak dikosongkan selama berhari-hari.',
          category: 'Fasilitas Umum',
          reporterUserId: 'user_demo_3',
          reporterName: 'Rahmat Ibrahim',
          reporterNik: '1234567890123460',
          status: 'Selesai',
          createdAt: now.subtract(Duration(days: 7)),
          likes: 8,
          likedByUserIds: [],
        ),
        Pengaduan(
          id: _generateId(),
          title: 'Pajak resmi untuk layanan parkir yang tidak resmi',
          description:
              'Ada petugas yang meminta bayaran untuk layanan parkir yang tidak resmi. Jika tidak bayar, kendaraan akan dikunci.',
          category: 'Pungutan Liar',
          reporterUserId: 'user_demo_4',
          reporterName: 'Dewi Lestari',
          reporterNik: '1234567890123461',
          status: 'Proses',
          createdAt: now.subtract(Duration(days: 2)),
          likes: 42,
          likedByUserIds: [],
        ),
      ]);
    }
  }

  // Create new pengaduan
  Future<Pengaduan?> createPengaduan({
    required String title,
    required String description,
    required String category,
    required String reporterUserId,
    required String reporterName,
    required String reporterNik,
    String? photoUrl,
  }) async {
    await Future.delayed(Duration(milliseconds: 500));

    try {
      final newPengaduan = Pengaduan(
        id: _generateId(),
        title: title,
        description: description,
        category: category,
        reporterUserId: reporterUserId,
        reporterName: reporterName,
        reporterNik: reporterNik,
        status: 'Proses',
        createdAt: DateTime.now(),
        photoUrl: photoUrl,
      );

      pengaduans.add(newPengaduan);
      return newPengaduan;
    } catch (e) {
      return null;
    }
  }

  // Get all pengaduans
  List<Pengaduan> getAllPengaduans() {
    return pengaduans.toList();
  }

  // Get pengaduan by ID
  Pengaduan? getPengaduanById(String id) {
    try {
      return pengaduans.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get pengaduans by reporter
  List<Pengaduan> getPengaduansByReporter(String reporterUserId) {
    return pengaduans.where((p) => p.reporterUserId == reporterUserId).toList();
  }

  // Get pengaduans assigned to petugas
  List<Pengaduan> getPengaduansByPetugas(String petugasUserId) {
    return pengaduans.where((p) => p.assignedToPetugasId == petugasUserId).toList();
  }

  // Update pengaduan status
  Future<Pengaduan?> updateStatus({
    required String pengaduanId,
    required String newStatus,
  }) async {
    await Future.delayed(Duration(milliseconds: 300));

    try {
      final index = pengaduans.indexWhere((p) => p.id == pengaduanId);
      if (index == -1) {
        throw Exception('Pengaduan tidak ditemukan');
      }

      final updated = pengaduans[index].copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );

      pengaduans[index] = updated;
      return updated;
    } catch (e) {
      return null;
    }
  }

  // Assign pengaduan to petugas
  Future<Pengaduan?> assignToPetugas({
    required String pengaduanId,
    required String petugasUserId,
    required String petugasName,
  }) async {
    await Future.delayed(Duration(milliseconds: 300));

    try {
      final index = pengaduans.indexWhere((p) => p.id == pengaduanId);
      if (index == -1) {
        throw Exception('Pengaduan tidak ditemukan');
      }

      final updated = pengaduans[index].copyWith(
        assignedToPetugasId: petugasUserId,
        assignedToPetugasName: petugasName,
        updatedAt: DateTime.now(),
      );

      pengaduans[index] = updated;
      return updated;
    } catch (e) {
      return null;
    }
  }

  // Like/Unlike pengaduan
  Future<Pengaduan?> toggleLike({
    required String pengaduanId,
    required String userId,
  }) async {
    await Future.delayed(Duration(milliseconds: 200));

    try {
      final index = pengaduans.indexWhere((p) => p.id == pengaduanId);
      if (index == -1) {
        throw Exception('Pengaduan tidak ditemukan');
      }

      final pengaduan = pengaduans[index];
      final likedByUserIds = List<String>.from(pengaduan.likedByUserIds);
      final isLiked = likedByUserIds.contains(userId);

      if (isLiked) {
        likedByUserIds.remove(userId);
      } else {
        likedByUserIds.add(userId);
      }

      final updated = pengaduan.copyWith(
        likes: likedByUserIds.length,
        likedByUserIds: likedByUserIds,
      );

      pengaduans[index] = updated;
      return updated;
    } catch (e) {
      return null;
    }
  }

  // Search and filter pengaduans
  List<Pengaduan> searchAndFilter({
    String? searchQuery,
    String? category,
    String? status,
    String? nik,
  }) {
    var results = pengaduans.toList();

    if (searchQuery != null && searchQuery.isNotEmpty) {
      results = results.where((p) {
        return p.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            p.description.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    if (category != null && category.isNotEmpty) {
      results = results.where((p) => p.category == category).toList();
    }

    if (status != null && status.isNotEmpty) {
      results = results.where((p) => p.status == status).toList();
    }

    if (nik != null && nik.isNotEmpty) {
      results = results.where((p) => p.reporterNik == nik).toList();
    }

    // Sort by newest first
    results.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return results;
  }

  // Get available categories
  List<String> getCategories() {
    final categories = <String>{};
    for (var p in pengaduans) {
      categories.add(p.category);
    }
    return categories.toList()..sort();
  }

  // Get reports by date range
  List<Pengaduan> getReportsByDateRange(DateTime startDate, DateTime endDate) {
    return pengaduans
        .where((p) =>
            p.createdAt.isAfter(startDate) && p.createdAt.isBefore(endDate))
        .toList();
  }

  // Get reports statistics
  Map<String, dynamic> getStatistics() {
    final stats = {
      'total': pengaduans.length,
      'selesai': pengaduans.where((p) => p.status == 'Selesai').length,
      'proses': pengaduans.where((p) => p.status == 'Proses').length,
      'menunggu': pengaduans.where((p) => p.status == 'Menunggu').length,
      'categories': <String, int>{},
      'topReports': <Map<String, dynamic>>[],
    };

    // Count by category
    for (var p in pengaduans) {
      final categories = stats['categories'] as Map<String, int>;
      categories[p.category] = (categories[p.category] ?? 0) + 1;
    }

    // Get top 5 most liked reports
    final topReports = List<Pengaduan>.from(pengaduans)
      ..sort((a, b) => b.likes.compareTo(a.likes));
    stats['topReports'] = topReports
        .take(5)
        .map((p) => {'id': p.id, 'title': p.title, 'likes': p.likes})
        .toList();

    return stats;
  }

  // Get trending reports (most liked in last 7 days)
  List<Pengaduan> getTrendingReports() {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(Duration(days: 7));

    final trending = pengaduans
        .where((p) => p.createdAt.isAfter(sevenDaysAgo))
        .toList();
    trending.sort((a, b) => b.likes.compareTo(a.likes));
    return trending.take(10).toList();
  }

  // Export report data as CSV format
  String exportReportsAsCSV(List<Pengaduan> reports) {
    StringBuffer csv = StringBuffer();
    csv.writeln('ID,Judul,Deskripsi,Kategori,Status,Reporter,Tanggal,Like');

    for (var report in reports) {
      csv.writeln(
          '"${report.id}","${report.title}","${report.description}","${report.category}","${report.status}","${report.reporterName}","${report.createdAt}",${report.likes}');
    }

    return csv.toString();
  }

  // Get user's created reports
  List<Pengaduan> getUserReports(String userId) {
    return pengaduans
        .where((p) => p.reporterUserId == userId)
        .toList();
  }

  // Bulk update reports status
  Future<bool> bulkUpdateStatus(
      List<String> reportIds, String newStatus) async {
    await Future.delayed(Duration(milliseconds: 300));

    try {
      for (var id in reportIds) {
        final index = pengaduans.indexWhere((p) => p.id == id);
        if (index != -1) {
          pengaduans[index] = pengaduans[index].copyWith(status: newStatus);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // Search with advanced filters
  List<Pengaduan> advancedSearch({
    String? keyword,
    String? category,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    String? sortBy = 'date',
  }) {
    var results = List<Pengaduan>.from(pengaduans);

    // Filter by keyword
    if (keyword != null && keyword.isNotEmpty) {
      final query = keyword.toLowerCase();
      results = results.where((p) {
        return p.title.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query) ||
            p.reporterName.toLowerCase().contains(query);
      }).toList();
    }

    // Filter by category
    if (category != null && category.isNotEmpty) {
      results = results.where((p) => p.category == category).toList();
    }

    // Filter by status
    if (status != null && status.isNotEmpty) {
      results = results.where((p) => p.status == status).toList();
    }

    // Filter by date range
    if (startDate != null && endDate != null) {
      results = results
          .where((p) =>
              p.createdAt.isAfter(startDate) && p.createdAt.isBefore(endDate))
          .toList();
    }

    // Sort
    switch (sortBy) {
      case 'likes':
        results.sort((a, b) => b.likes.compareTo(a.likes));
        break;
      case 'newest':
        results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        results.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      default:
        results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return results;
  }

  // Generate unique ID
  String _generateId() {
    return 'pengaduan_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }
}
