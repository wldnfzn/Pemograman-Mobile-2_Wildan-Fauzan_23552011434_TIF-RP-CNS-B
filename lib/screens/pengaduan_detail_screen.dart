import 'package:flutter/material.dart';
import 'package:laporpak/models/pengaduan.dart';
import 'package:laporpak/models/user.dart';
import 'package:laporpak/screens/chat_screen.dart';
import 'package:laporpak/services/pengaduan_service.dart';
import 'package:laporpak/widgets/custom_app_bar.dart';
import 'package:laporpak/widgets/custom_button.dart';

class PengaduanDetailScreen extends StatefulWidget {
  final Pengaduan pengaduan;
  final User currentUser;

  const PengaduanDetailScreen({
    Key? key,
    required this.pengaduan,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<PengaduanDetailScreen> createState() => _PengaduanDetailScreenState();
}

class _PengaduanDetailScreenState extends State<PengaduanDetailScreen> {
  late Pengaduan _pengaduan;
  final _pengaduanService = PengaduanService();

  @override
  void initState() {
    super.initState();
    _pengaduan = _pengaduanService.getPengaduanById(widget.pengaduan.id) ??
        widget.pengaduan;
  }

  Color _getStatusColor() {
    switch (_pengaduan.status) {
      case 'Selesai':
        return Colors.green;
      case 'Proses':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _updateStatus(String newStatus) async {
    final updated = await _pengaduanService.updateStatus(
      pengaduanId: _pengaduan.id,
      newStatus: newStatus,
    );

    if (updated != null && mounted) {
      setState(() => _pengaduan = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status diperbarui ke: $newStatus')),
      );
    }
  }

  void _toggleLike() {
    _pengaduanService
        .toggleLike(
          pengaduanId: _pengaduan.id,
          userId: widget.currentUser.id,
        )
        .then((updated) {
          if (updated != null) {
            setState(() => _pengaduan = updated);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final isLiked = _pengaduan.likedByUserIds.contains(widget.currentUser.id);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detail Pengaduan',
        backgroundColor: Colors.blue[600]!,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              color: _getStatusColor().withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor().withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: _getStatusColor(), width: 1),
                        ),
                        child: Text(
                          _pengaduan.status,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    _pengaduan.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            // Main content
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category and date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _pengaduan.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        _formatDate(_pengaduan.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Reporter info
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pelapor',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _pengaduan.reporterName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'NIK: ${_pengaduan.reporterNik}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  // Description
                  Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _pengaduan.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Assigned petugas if exists
                  if (_pengaduan.assignedToPetugasId != null) ...[
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ditugaskan ke',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _pengaduan.assignedToPetugasName ??
                                'Petugas Tidak Diketahui',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                  // Likes
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _toggleLike,
                        child: Row(
                          children: [
                            Icon(
                              isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: isLiked ? Colors.red : Colors.grey[400],
                              size: 20,
                            ),
                            SizedBox(width: 6),
                            Text(
                              '${_pengaduan.likes} orang setuju',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  // Action buttons
                  if (widget.currentUser.role == 'petugas' &&
                      _pengaduan.assignedToPetugasId ==
                          widget.currentUser.id) ...[
                    if (_pengaduan.status != 'Selesai')
                      CustomButton(
                        label: 'TANDAI SELESAI',
                        onPressed: () => _updateStatus('Selesai'),
                        backgroundColor: Colors.green[600]!,
                      )
                    else
                      CustomButton(
                        label: 'UBAH KE PROSES',
                        onPressed: () => _updateStatus('Proses'),
                        backgroundColor: Colors.orange[600]!,
                      ),
                    SizedBox(height: 12),
                  ],
                  if (widget.currentUser.role == 'admin' ||
                      widget.currentUser.role == 'petugas' ||
                      _pengaduan.reporterUserId ==
                          widget.currentUser.id) ...[
                    CustomButton(
                      label: 'CHAT DENGAN ${_pengaduan.assignedToPetugasId != null ? 'PETUGAS' : 'ADMIN'}',
                      onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              currentUser: widget.currentUser,
                              pengaduanId: _pengaduan.id,
                            ),
                          ),
                        );
                      },
                      backgroundColor: Colors.blue[600]!,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
