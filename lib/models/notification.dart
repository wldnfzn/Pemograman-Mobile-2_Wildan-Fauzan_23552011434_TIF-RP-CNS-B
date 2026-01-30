class Notifikasi {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type; // 'report', 'assignment', 'message', 'update'
  final String? relatedId; // pengaduan_id or message_id
  final DateTime createdAt;
  final bool isRead;

  Notifikasi({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.relatedId,
    required this.createdAt,
    this.isRead = false,
  });

  Notifikasi copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    String? type,
    String? relatedId,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return Notifikasi(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      relatedId: relatedId ?? this.relatedId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

class Comment {
  final String id;
  final String pengaduanId;
  final String authorId;
  final String authorName;
  final String authorRole;
  final String content;
  final DateTime createdAt;
  final List<String> likes;

  Comment({
    required this.id,
    required this.pengaduanId,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.content,
    required this.createdAt,
    this.likes = const [],
  });

  Comment copyWith({
    String? id,
    String? pengaduanId,
    String? authorId,
    String? authorName,
    String? authorRole,
    String? content,
    DateTime? createdAt,
    List<String>? likes,
  }) {
    return Comment(
      id: id ?? this.id,
      pengaduanId: pengaduanId ?? this.pengaduanId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorRole: authorRole ?? this.authorRole,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
    );
  }
}

class Attachment {
  final String id;
  final String pengaduanId;
  final String fileName;
  final String fileType; // 'image', 'document', 'video'
  final String filePath;
  final int fileSize;
  final DateTime uploadedAt;
  final String uploadedBy;

  Attachment({
    required this.id,
    required this.pengaduanId,
    required this.fileName,
    required this.fileType,
    required this.filePath,
    required this.fileSize,
    required this.uploadedAt,
    required this.uploadedBy,
  });

  Attachment copyWith({
    String? id,
    String? pengaduanId,
    String? fileName,
    String? fileType,
    String? filePath,
    int? fileSize,
    DateTime? uploadedAt,
    String? uploadedBy,
  }) {
    return Attachment(
      id: id ?? this.id,
      pengaduanId: pengaduanId ?? this.pengaduanId,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      filePath: filePath ?? this.filePath,
      fileSize: fileSize ?? this.fileSize,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      uploadedBy: uploadedBy ?? this.uploadedBy,
    );
  }
}
