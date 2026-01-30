class Pengaduan {
  final String id;
  final String title;
  final String description;
  final String category; // e.g., 'Fasilitas Umum', 'Pungutan Liar'
  final String reporterUserId; // User ID of masyarakat who reported
  final String reporterName;
  final String reporterNik;
  final String status; // 'Proses', 'Selesai'
  final String? assignedToPetugasId; // User ID of petugas assigned
  final String? assignedToPetugasName;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likes;
  final List<String> likedByUserIds;
  final String? photoUrl;

  Pengaduan({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.reporterUserId,
    required this.reporterName,
    required this.reporterNik,
    required this.status,
    this.assignedToPetugasId,
    this.assignedToPetugasName,
    required this.createdAt,
    this.updatedAt,
    this.likes = 0,
    this.likedByUserIds = const [],
    this.photoUrl,
  });

  Pengaduan copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? reporterUserId,
    String? reporterName,
    String? reporterNik,
    String? status,
    String? assignedToPetugasId,
    String? assignedToPetugasName,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likes,
    List<String>? likedByUserIds,
    String? photoUrl,
  }) {
    return Pengaduan(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      reporterUserId: reporterUserId ?? this.reporterUserId,
      reporterName: reporterName ?? this.reporterName,
      reporterNik: reporterNik ?? this.reporterNik,
      status: status ?? this.status,
      assignedToPetugasId: assignedToPetugasId ?? this.assignedToPetugasId,
      assignedToPetugasName: assignedToPetugasName ?? this.assignedToPetugasName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likes: likes ?? this.likes,
      likedByUserIds: likedByUserIds ?? this.likedByUserIds,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  String toString() =>
      'Pengaduan(id: $id, title: $title, status: $status, category: $category)';
}
