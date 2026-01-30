import 'package:laporpak/models/notification.dart';
import 'dart:math';

class NotificationService {
  static final NotificationService _instance =
      NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final List<Notifikasi> notifications = [];
  final List<Comment> comments = [];
  final List<Attachment> attachments = [];

  // Add comment to report
  Future<Comment?> addComment({
    required String pengaduanId,
    required String authorId,
    required String authorName,
    required String authorRole,
    required String content,
  }) async {
    await Future.delayed(Duration(milliseconds: 300));

    try {
      final newComment = Comment(
        id: _generateId(),
        pengaduanId: pengaduanId,
        authorId: authorId,
        authorName: authorName,
        authorRole: authorRole,
        content: content,
        createdAt: DateTime.now(),
      );

      comments.add(newComment);
      return newComment;
    } catch (e) {
      return null;
    }
  }

  // Get comments for a report
  List<Comment> getCommentsByReport(String pengaduanId) {
    final result = comments.where((c) => c.pengaduanId == pengaduanId).toList();
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  }

  // Like comment
  Future<Comment?> toggleCommentLike({
    required String commentId,
    required String userId,
  }) async {
    await Future.delayed(Duration(milliseconds: 200));

    try {
      final index = comments.indexWhere((c) => c.id == commentId);
      if (index == -1) return null;

      final comment = comments[index];
      final likes = List<String>.from(comment.likes);

      if (likes.contains(userId)) {
        likes.remove(userId);
      } else {
        likes.add(userId);
      }

      comments[index] = comment.copyWith(likes: likes);
      return comments[index];
    } catch (e) {
      return null;
    }
  }

  // Add attachment
  Future<Attachment?> addAttachment({
    required String pengaduanId,
    required String fileName,
    required String fileType,
    required String filePath,
    required int fileSize,
    required String uploadedBy,
  }) async {
    await Future.delayed(Duration(milliseconds: 300));

    try {
      final attachment = Attachment(
        id: _generateId(),
        pengaduanId: pengaduanId,
        fileName: fileName,
        fileType: fileType,
        filePath: filePath,
        fileSize: fileSize,
        uploadedAt: DateTime.now(),
        uploadedBy: uploadedBy,
      );

      attachments.add(attachment);
      return attachment;
    } catch (e) {
      return null;
    }
  }

  // Get attachments for a report
  List<Attachment> getAttachmentsByReport(String pengaduanId) {
    return attachments.where((a) => a.pengaduanId == pengaduanId).toList();
  }

  // Send notification
  Future<Notifikasi?> sendNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    String? relatedId,
  }) async {
    await Future.delayed(Duration(milliseconds: 200));

    try {
      final notification = Notifikasi(
        id: _generateId(),
        userId: userId,
        title: title,
        message: message,
        type: type,
        relatedId: relatedId,
        createdAt: DateTime.now(),
      );

      notifications.add(notification);
      return notification;
    } catch (e) {
      return null;
    }
  }

  // Get user notifications
  List<Notifikasi> getUserNotifications(String userId) {
    final result =
        notifications.where((n) => n.userId == userId).toList();
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  }

  // Get unread notifications
  List<Notifikasi> getUnreadNotifications(String userId) {
    return notifications
        .where((n) => n.userId == userId && !n.isRead)
        .toList();
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(Duration(milliseconds: 200));

    try {
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);
      }
    } catch (e) {
      // Handle error
    }
  }

  // Mark all as read
  Future<void> markAllAsRead(String userId) async {
    await Future.delayed(Duration(milliseconds: 300));

    try {
      for (int i = 0; i < notifications.length; i++) {
        if (notifications[i].userId == userId && !notifications[i].isRead) {
          notifications[i] = notifications[i].copyWith(isRead: true);
        }
      }
    } catch (e) {
      // Handle error
    }
  }

  // Generate unique ID
  String _generateId() {
    return 'notif_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }
}
