import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laporpak/models/notification.dart';

class AttachmentWidget extends StatelessWidget {
  final Attachment attachment;
  final VoidCallback? onDownload;
  final VoidCallback? onDelete;

  const AttachmentWidget({
    Key? key,
    required this.attachment,
    this.onDownload,
    this.onDelete,
  }) : super(key: key);

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icons.video_file;
      case 'mp3':
      case 'wav':
        return Icons.audio_file;
      case 'zip':
      case 'rar':
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Colors.purple;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final formattedDate = dateFormat.format(attachment.uploadedAt);
    final fileSize = _formatFileSize(attachment.fileSize);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          // File icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getFileColor(attachment.fileType).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                _getFileIcon(attachment.fileType),
                color: _getFileColor(attachment.fileType),
                size: 28,
              ),
            ),
          ),
          SizedBox(width: 12),
          // File info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.fileName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  '$fileSize • Uploaded $formattedDate',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Action buttons
          if (onDownload != null)
            IconButton(
              icon: Icon(Icons.download, size: 20),
              onPressed: onDownload,
              color: Colors.blue,
              splashRadius: 20,
            ),
          if (onDelete != null)
            IconButton(
              icon: Icon(Icons.close, size: 20),
              onPressed: onDelete,
              color: Colors.red,
              splashRadius: 20,
            ),
        ],
      ),
    );
  }
}
