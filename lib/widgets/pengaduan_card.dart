import 'package:flutter/material.dart';
import 'package:laporpak/models/pengaduan.dart';

class PengaduanCard extends StatelessWidget {
  final Pengaduan pengaduan;
  final VoidCallback onTap;
  final VoidCallback? onLikeTap;
  final bool isLiked;

  const PengaduanCard({
    Key? key,
    required this.pengaduan,
    required this.onTap,
    this.onLikeTap,
    this.isLiked = false,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (pengaduan.status) {
      case 'Selesai':
        return Colors.green;
      case 'Proses':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Icon _getCategoryIcon() {
    switch (pengaduan.category) {
      case 'Fasilitas Umum':
        return Icon(Icons.home_repair_service);
      case 'Pungutan Liar':
        return Icon(Icons.warning);
      default:
        return Icon(Icons.report);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pengaduan.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          pengaduan.reporterName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _getStatusColor(), width: 1),
                    ),
                    child: Text(
                      pengaduan.status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  _getCategoryIcon(),
                  SizedBox(width: 6),
                  Text(
                    pengaduan.category,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Text(
                    _formatDate(pengaduan.createdAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                pengaduan.description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  GestureDetector(
                    onTap: onLikeTap,
                    child: Row(
                      children: [
                        Icon(
                          isLiked ? Icons.favorite : Icons.favorite_outline,
                          color: isLiked ? Colors.red : Colors.grey[400],
                          size: 18,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${pengaduan.likes}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward, size: 16, color: Colors.blue),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} menit lalu';
      }
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
