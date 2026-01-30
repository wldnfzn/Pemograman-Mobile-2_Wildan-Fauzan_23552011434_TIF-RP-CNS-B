import 'package:flutter/material.dart';
import 'package:laporpak/models/user.dart';
import 'package:laporpak/screens/notification_screen.dart';
import 'package:laporpak/screens/pengaduan_detail_screen.dart';
import 'package:laporpak/screens/profile_screen.dart';
import 'package:laporpak/services/auth_service.dart';
import 'package:laporpak/services/pengaduan_service.dart';
import 'package:laporpak/services/notification_service.dart';
import 'package:laporpak/widgets/pengaduan_card.dart';
import 'package:laporpak/widgets/statistics_card.dart';

class AdminDashboardEnhancedScreen extends StatefulWidget {
  final User user;

  const AdminDashboardEnhancedScreen({Key? key, required this.user})
      : super(key: key);

  @override
  State<AdminDashboardEnhancedScreen> createState() =>
      _AdminDashboardEnhancedScreenState();
}

class _AdminDashboardEnhancedScreenState
    extends State<AdminDashboardEnhancedScreen> {
  final _pengaduanService = PengaduanService();
  final _authService = AuthService();
  final _notificationService = NotificationService();
  int _selectedIndex = 0;
  String _searchQuery = '';
  String? _selectedStatus;
  String _selectedFilter = 'all';

  List get _filteredPengaduans {
    var results = _pengaduanService.searchAndFilter(
      searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
      status: _selectedStatus,
    );

    if (_selectedFilter == 'trending') {
      results = _pengaduanService.getTrendingReports();
    }

    return results;
  }

  @override
  void initState() {
    super.initState();
    _pengaduanService.initializeDummyPengaduans();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard Admin'),
          backgroundColor: Colors.green[600],
          elevation: 0,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NotificationScreen(),
                      ),
                    );
                  },
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_notificationService.getUnreadNotifications(widget.user.id).length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
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
        body: _selectedIndex == 0 ? _buildDashboard() : _buildReportsList(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Laporan'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
          onTap: (index) {
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen(user: widget.user)),
              );
            } else {
              setState(() => _selectedIndex = index);
            }
          },
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    final stats = _pengaduanService.getStatistics();
    final unreadNotifications =
        _notificationService.getUnreadNotifications(widget.user.id);
    final trendingReports = _pengaduanService.getTrendingReports();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          Text(
            'Selamat datang, ${widget.user.name}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            'Kelola dan pantau semua laporan pengaduan',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 20),

          // Statistics cards
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              StatisticsCard(
                title: 'Total Laporan',
                value: '${stats['total']}',
                subtitle: 'Semua laporan masuk',
                icon: Icons.description,
                backgroundColor: Colors.blue[50],
                iconColor: Colors.blue,
              ),
              StatisticsCard(
                title: 'Selesai',
                value: '${stats['selesai']}',
                subtitle: 'Laporan ditutup',
                icon: Icons.check_circle,
                backgroundColor: Colors.green[50],
                iconColor: Colors.green,
              ),
              StatisticsCard(
                title: 'Diproses',
                value: '${stats['proses']}',
                subtitle: 'Sedang ditangani',
                icon: Icons.hourglass_bottom,
                backgroundColor: Colors.orange[50],
                iconColor: Colors.orange,
              ),
              StatisticsCard(
                title: 'Menunggu',
                value: '${stats['menunggu']}',
                subtitle: 'Belum ditugaskan',
                icon: Icons.pending_actions,
                backgroundColor: Colors.red[50],
                iconColor: Colors.red,
              ),
            ],
          ),
          SizedBox(height: 20),

          // Notifications section
          if (unreadNotifications.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifikasi Terbaru (${unreadNotifications.length})',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Ada ${unreadNotifications.length} notifikasi baru yang menunggu perhatian Anda',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),

          // Trending reports section
          if (trendingReports.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Laporan Trending',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                          _selectedFilter = 'trending';
                        });
                      },
                      child: Text('Lihat Semua'),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                ...trendingReports.take(3).map((report) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PengaduanDetailScreen(pengaduan: report, currentUser: widget.user),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.trending_up,
                              color: Colors.orange, size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  report.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${report.likes} likes',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 14, color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildReportsList() {
    return Column(
      children: [
        // Search and filter
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Cari laporan...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('Semua', 'all'),
                    _buildFilterChip('Menunggu', 'Menunggu'),
                    _buildFilterChip('Diproses', 'Proses'),
                    _buildFilterChip('Selesai', 'Selesai'),
                    _buildFilterChip('Trending', 'trending'),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Reports list
        Expanded(
          child: _filteredPengaduans.isEmpty
              ? Center(
                  child: Text('Tidak ada laporan'),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredPengaduans.length,
                  itemBuilder: (context, index) {
                    final pengaduan = _filteredPengaduans[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PengaduanDetailScreen(pengaduan: pengaduan, currentUser: widget.user),
                          ),
                        );
                      },
                      child: PengaduanCard(
                        pengaduan: pengaduan,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PengaduanDetailScreen(pengaduan: pengaduan, currentUser: widget.user),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String filter) {
    final isSelected = _selectedFilter == filter;
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = filter;
            if (filter == 'Menunggu' || filter == 'Proses' || filter == 'Selesai') {
              _selectedStatus = filter;
            } else {
              _selectedStatus = null;
            }
          });
        },
        selectedColor: Colors.green[600],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
