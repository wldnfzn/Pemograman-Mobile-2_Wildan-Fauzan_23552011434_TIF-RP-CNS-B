import 'package:flutter/material.dart';
import 'package:laporpak/models/pengaduan.dart';
import 'package:laporpak/models/user.dart';
import 'package:laporpak/screens/pengaduan_detail_screen.dart';
import 'package:laporpak/screens/profile_screen.dart';
import 'package:laporpak/services/auth_service.dart';
import 'package:laporpak/services/pengaduan_service.dart';

class PetugasDashboardEnhancedScreen extends StatefulWidget {
  final User user;

  const PetugasDashboardEnhancedScreen({Key? key, required this.user})
      : super(key: key);

  @override
  State<PetugasDashboardEnhancedScreen> createState() =>
      _PetugasDashboardEnhancedScreenState();
}

class _PetugasDashboardEnhancedScreenState extends State<PetugasDashboardEnhancedScreen> {
  final _pengaduanService = PengaduanService();
  final _authService = AuthService();
  int _selectedIndex = 0;
  String? _selectedStatus;
  String _sortBy = 'terbaru';

  @override
  void initState() {
    super.initState();
    _pengaduanService.initializeDummyPengaduans();
  }

  List get _assignedPengaduans {
    final all = _pengaduanService.getPengaduansByPetugas(widget.user.id);
    
    // Filter by status
    List<Pengaduan> filtered = all;
    if (_selectedStatus != null) {
      filtered = all.where((p) => p.status == _selectedStatus).toList();
    }

    // Sort
    if (_sortBy == 'terbaru') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (_sortBy == 'prioritas') {
      // Sort by status instead (Baru -> Proses -> Selesai)
      const statusOrder = {'Baru': 0, 'Proses': 1, 'Selesai': 2};
      filtered.sort((a, b) =>
          (statusOrder[a.status] ?? 3).compareTo(statusOrder[b.status] ?? 3));
    } else if (_sortBy == 'belum-diproses') {
      filtered = filtered.where((p) => p.status == 'Baru').toList();
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return filtered;
  }

  Map<String, int> _getStats() {
    final all = _pengaduanService.getPengaduansByPetugas(widget.user.id);
    return {
      'total': all.length,
      'baru': all.where((p) => p.status == 'Baru').length,
      'proses': all.where((p) => p.status == 'Proses').length,
      'selesai': all.where((p) => p.status == 'Selesai').length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard Petugas', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.orange[600],
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_outlined),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tidak ada notifikasi baru')),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _authService.logout();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
        body: _selectedIndex == 0
            ? _buildDashboard()
            : _selectedIndex == 1
                ? _buildPerformance()
                : _selectedIndex == 2
                    ? _buildActivity()
                    : ProfileScreen(user: widget.user),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt),
              label: 'Tugas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              label: 'Performa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Aktivitas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    final stats = _getStats();
    return SingleChildScrollView(
      child: Column(
        children: [
          // Welcome Card
          Container(
            color: Colors.orange[600],
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, ${widget.user.name}!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Mari kerjakan tugas-tugas hari ini',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // Statistics Grid
          Padding(
            padding: EdgeInsets.all(16),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildStatTile('Total Tugas', stats['total']!, Colors.blue, Icons.task_alt),
                _buildStatTile('Baru', stats['baru']!, Colors.purple, Icons.new_releases),
                _buildStatTile('Dalam Proses', stats['proses']!, Colors.orange, Icons.hourglass_bottom),
                _buildStatTile('Selesai', stats['selesai']!, Colors.green, Icons.check_circle),
                _buildStatTile(
                  'Completion Rate',
                  stats['total']! > 0 ? ((stats['selesai']! / stats['total']!) * 100).toStringAsFixed(0) : '0',
                  Colors.teal,
                  Icons.percent,
                ),
              ],
            ),
          ),

          // Filter and Sort
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String?>(
                    value: _selectedStatus,
                    isExpanded: true,
                    hint: Text('Filter Status'),
                    items: [
                      DropdownMenuItem(value: null, child: Text('Semua Status')),
                      DropdownMenuItem(value: 'Baru', child: Text('Baru')),
                      DropdownMenuItem(value: 'Proses', child: Text('Dalam Proses')),
                      DropdownMenuItem(value: 'Selesai', child: Text('Selesai')),
                    ],
                    onChanged: (v) => setState(() => _selectedStatus = v),
                  ),
                ),
                SizedBox(width: 8),
                PopupMenuButton<String>(
                  initialValue: _sortBy,
                  onSelected: (v) => setState(() => _sortBy = v),
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'terbaru', child: Text('Terbaru')),
                    PopupMenuItem(value: 'prioritas', child: Text('Prioritas')),
                    PopupMenuItem(value: 'belum-diproses', child: Text('Belum Diproses')),
                  ],
                  child: Chip(label: Text('Sort'), avatar: Icon(Icons.sort)),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          // Tasks List
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _assignedPengaduans.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(Icons.inbox, size: 64, color: Colors.grey[300]),
                          SizedBox(height: 16),
                          Text(
                            'Tidak ada tugas',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _assignedPengaduans.length,
                    itemBuilder: (context, index) {
                      final pengaduan = _assignedPengaduans[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PengaduanDetailScreen(
                                pengaduan: pengaduan,
                                currentUser: widget.user,
                              ),
                            ),
                          ).then((_) => setState(() {}));
                        },
                        child: Card(
                          margin: EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        pengaduan.title,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(pengaduan.status).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        pengaduan.status,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: _getStatusColor(pengaduan.status),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Text(
                                  pengaduan.description,
                                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.category, size: 14, color: Colors.grey),
                                        SizedBox(width: 4),
                                        Text(
                                          pengaduan.category,
                                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPerformance() {
    final stats = _getStats();
    final completionRate = stats['total']! > 0 ? (stats['selesai']! / stats['total']!) * 100 : 0.0;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          // Completion Rate Chart
          Card(
            margin: EdgeInsets.all(16),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tingkat Penyelesaian',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: completionRate / 100,
                            strokeWidth: 8,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                            backgroundColor: Colors.grey[200],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${completionRate.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              '${stats['selesai']}/${stats['total']}',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 12),
                  _performanceMetric('Total Tugas', '${stats['total']}'),
                  SizedBox(height: 8),
                  _performanceMetric('Tugas Selesai', '${stats['selesai']}'),
                  SizedBox(height: 12),
                  _performanceMetric('Dalam Proses', '${stats['proses']}'),
                  SizedBox(height: 8),
                  _performanceMetric('Belum Diproses', '${stats['baru']}'),
                ],
              ),
            ),
          ),
          
          // Performance Tips
          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tips Meningkatkan Performa',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    _tipItem('Prioritaskan tugas dengan prioritas tinggi'),
                    _tipItem('Tandai tugas selesai setelah penyelesaian'),
                    _tipItem('Ikuti standar penyelesaian waktu'),
                    _tipItem('Berikan update rutin ke pelapor'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivity() {
    final all = _pengaduanService.getPengaduansByPetugas(widget.user.id);
    final sortedByDate = List<Pengaduan>.from(all)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Riwayat Aktivitas',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: sortedByDate.length,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final pengaduan = sortedByDate[index];
              return TimelineItem(
                pengaduan: pengaduan,
                isLast: index == sortedByDate.length - 1,
              );
            },
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStatTile(String label, dynamic value, Color color, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _performanceMetric(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _tipItem(String tip) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, size: 18, color: Colors.orange),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Baru':
        return Colors.purple;
      case 'Proses':
        return Colors.orange;
      case 'Selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class TimelineItem extends StatelessWidget {
  final Pengaduan pengaduan;
  final bool isLast;

  const TimelineItem({
    Key? key,
    required this.pengaduan,
    required this.isLast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.orange[600],
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: Colors.orange[200],
              ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pengaduan.title,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              SizedBox(height: 4),
              Text(
                '${pengaduan.status} • ${_formatDate(pengaduan.createdAt)}',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
