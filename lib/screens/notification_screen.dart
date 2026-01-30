import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laporpak/services/auth_service.dart';
import 'package:laporpak/services/notification_service.dart';
import 'package:laporpak/widgets/custom_app_bar.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final AuthService _authService = AuthService();
  final NotificationService _notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return Scaffold(
        body: Center(child: Text('User not found')),
      );
    }

    final notifications =
        _notificationService.getUserNotifications(currentUser.id);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifikasi',
        showBackButton: true,
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tidak ada notifikasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Semua notifikasi akan ditampilkan di sini',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationCard(context, notification);
              },
            ),
      floatingActionButton: notifications.isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
                await _notificationService.markAllAsRead(currentUser.id);
                setState(() {});
              },
              backgroundColor: Colors.blue,
              child: Icon(Icons.check_circle),
            )
          : null,
    );
  }

  Widget _buildNotificationCard(BuildContext context, var notification) {
    final dateFormat = DateFormat('dd MMM HH:mm');
    final formattedDate = dateFormat.format(notification.createdAt);

    // Get notification icon and color based on type
    IconData getNotificationIcon(String type) {
      switch (type.toLowerCase()) {
        case 'comment':
          return Icons.comment;
        case 'like':
          return Icons.favorite;
        case 'status':
          return Icons.info;
        case 'assigned':
          return Icons.assignment;
        case 'message':
          return Icons.message;
        default:
          return Icons.notifications;
      }
    }

    Color getNotificationColor(String type) {
      switch (type.toLowerCase()) {
        case 'comment':
          return Colors.blue;
        case 'like':
          return Colors.red;
        case 'status':
          return Colors.orange;
        case 'assigned':
          return Colors.green;
        case 'message':
          return Colors.purple;
        default:
          return Colors.grey;
      }
    }

    return GestureDetector(
      onTap: () async {
        await _notificationService.markAsRead(notification.id);
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification.isRead
                ? Colors.grey[200]!
                : Colors.blue[200]!,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: getNotificationColor(notification.type)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  getNotificationIcon(notification.type),
                  color: getNotificationColor(notification.type),
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 12),
            // Notification content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
