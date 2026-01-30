import 'package:flutter/material.dart';
import 'package:laporpak/models/user.dart';
import 'package:laporpak/screens/notification_screen.dart';
import 'package:laporpak/screens/pengaduan_detail_screen.dart';
import 'package:laporpak/screens/profile_screen.dart';
import 'package:laporpak/screens/report_form_screen.dart';
import 'package:laporpak/services/auth_service.dart';
import 'package:laporpak/services/pengaduan_service.dart';
import 'package:laporpak/services/notification_service.dart';
import 'package:laporpak/widgets/pengaduan_card.dart';
import 'package:laporpak/widgets/statistics_card.dart';

class MasyarakatDashboardEnhancedScreen extends StatefulWidget {
  final User user;

  const MasyarakatDashboardEnhancedScreen({Key? key, required this.user})
      : super(key: key);

  @override
  State<MasyarakatDashboardEnhancedScreen> createState() =>
      _MasyarakatDashboardEnhancedScreenState();
}

class _MasyarakatDashboardEnhancedScreenState
    extends State<MasyarakatDashboardEnhancedScreen> {
  final _pengaduanService = PengaduanService();
  final _authService = AuthService();
  final _notificationService = NotificationService();

  int _selectedIndex = 0;
  String _searchQuery = '';
  String? _selectedCategory;

  List get _filteredPengaduans {
    return _pengaduanService.searchAndFilter(
      searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
      category: _selectedCategory,
    );
  }

  List<dynamic> get _userReports {
    return _pengaduanService.getUserReports(widget.user.id);
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
          title: Text('LaporPak Masyarakat'),
          backgroundColor: Colors.blue[600],
          elevation: 0,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => NotificationScreen()),
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
        body: _selectedIndex == 0 ? _buildDashboard() : _buildMyReports(),
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ReportFormScreen(user: widget.user)),
                  ).then((_) => setState(() {}));
                },
                backgroundColor: Colors.blue[600],
                child: Icon(Icons.add),
              )
            : null,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
            BottomNavigationBarItem(icon: Icon(Icons.my_library_books), label: 'Laporan Saya'),
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
    final trendingReports = _pengaduanService.getTrendingReports();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[600]!, Colors.blue[400]!],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat datang, ${widget.user.name}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Lapor masalah dan pantau penyelesaiannya',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ReportFormScreen(user: widget.user)),
                    ).then((_) => setState(() {}));
                  },
                  icon: Icon(Icons.add),
                  label: Text('Buat Laporan Baru'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Statistics
          Text(
            'Statistik Laporan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatisticsCard(
                  title: 'Total Laporan',
                  value: '${_userReports.length}',
                  subtitle: 'Laporan Anda',
                  icon: Icons.description,
                  backgroundColor: Colors.blue[50],
                  iconColor: Colors.blue,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: StatisticsCard(
                  title: 'Selesai',
                  value: '${_userReports.where((r) => r.status == 'Selesai').length}',
                  subtitle: 'Laporan ditutup',
                  icon: Icons.check_circle,
                  backgroundColor: Colors.green[50],
                  iconColor: Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Trending reports
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
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => _buildTrendingSheet(),
                  );
                },
                child: Text('Lihat Semua'),
              ),
            ],
          ),
          SizedBox(height: 12),
          if (trendingReports.isEmpty)
            Center(
              child: Text('Tidak ada laporan trending'),
            )
          else
            ...trendingReports.take(3).map((report) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PengaduanDetailScreen(pengaduan: report, currentUser: widget.user),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.trending_up,
                            color: Colors.orange, size: 20),
                      ),
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
                              '${report.likes} orang mendukung • ${report.category}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                    ],
                  ),
                ),
              );
            }).toList(),
          SizedBox(height: 20),

          // Browse reports section
          Text(
            'Laporan Terbaru',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          // Category filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip('Semua', null),
                ..._pengaduanService.getCategories().map((category) {
                  return _buildCategoryChip(category, category);
                }).toList(),
              ],
            ),
          ),
          SizedBox(height: 12),
          // Search
          TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Cari laporan...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          SizedBox(height: 16),
          if (_filteredPengaduans.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('Tidak ada laporan ditemukan'),
              ),
            )
          else
            ...(_filteredPengaduans).map((pengaduan) {
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
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildMyReports() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Laporan Saya',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          if (_userReports.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.description, size: 64, color: Colors.grey[300]),
                    SizedBox(height: 16),
                    Text(
                      'Anda belum membuat laporan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Mulai laporkan masalah untuk membantu komunitas',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            )
          else
            ...(_userReports).map((pengaduan) {
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
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String? category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedCategory = selected ? category : null);
        },
        selectedColor: Colors.blue[600],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildTrendingSheet() {
    final trendingReports = _pengaduanService.getTrendingReports();
    return Container(
      child: Column(
        children: [
          AppBar(
            title: Text('Laporan Trending'),
            backgroundColor: Colors.blue[600],
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: trendingReports.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PengaduanDetailScreen(
                            pengaduan: trendingReports[index], currentUser: widget.user),
                      ),
                    );
                  },
                  child: PengaduanCard(
                    pengaduan: trendingReports[index],
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PengaduanDetailScreen(
                              pengaduan: trendingReports[index], currentUser: widget.user),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
