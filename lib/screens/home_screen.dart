import 'package:flutter/material.dart';
import 'package:laporpak/screens/login_screen_v2.dart';
import 'package:laporpak/screens/register_screen_v2.dart';
import 'package:laporpak/services/pengaduan_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pengaduanService = PengaduanService();
  late Map<String, dynamic> _stats;

  @override
  void initState() {
    super.initState();
    _pengaduanService.initializeDummyPengaduans();
    _stats = _pengaduanService.getStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0A84FF), Color(0xFF0066CC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
              child: Column(
                children: [
                  Icon(Icons.report_problem, size: 80, color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'LaporPak',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Platform Pengaduan Masyarakat Terpercaya',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Laporkan keluhan Anda dengan mudah dan aman. Kami berkomitmen memberikan respons cepat dan solusi terbaik untuk setiap pengaduan.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Statistics Section
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statistik Platform',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _buildStatCard(
                        'Total Pengaduan',
                        '${_stats['totalReports']}',
                        Icons.report,
                        Colors.blue,
                      ),
                      _buildStatCard(
                        'Terselesaikan',
                        '${_stats['completedReports'] ?? 0}',
                        Icons.check_circle,
                        Colors.green,
                      ),
                      _buildStatCard(
                        'Dalam Proses',
                        '${_stats['inProgressReports'] ?? 0}',
                        Icons.hourglass_bottom,
                        Colors.orange,
                      ),
                      _buildStatCard(
                        'Kategori',
                        '${_stats['categories']?.length ?? 0}',
                        Icons.category,
                        Colors.purple,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Categories Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kategori Pengaduan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  if (_stats['categories'] != null && (_stats['categories'] as Map).isNotEmpty)
                    ...((_stats['categories'] as Map<String, int>).entries.map((e) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '• ${e.key}',
                              style: TextStyle(fontSize: 14),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${e.value}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList())
                  else
                    Text('Belum ada data kategori', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Features Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fitur Unggulan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  _buildFeatureItem(
                    Icons.security,
                    'Aman & Terpercaya',
                    'Data Anda dilindungi dengan enkripsi tingkat enterprise',
                  ),
                  _buildFeatureItem(
                    Icons.speed,
                    'Respons Cepat',
                    'Tim kami merespons setiap pengaduan dalam waktu singkat',
                  ),
                  _buildFeatureItem(
                    Icons.public,
                    'Transparan',
                    'Pantau status pengaduan Anda secara real-time',
                  ),
                  _buildFeatureItem(
                    Icons.support_agent,
                    'Dukungan 24/7',
                    'Tim support kami siap membantu kapan saja',
                  ),
                ],
              ),
            ),

            SizedBox(height: 28),

            // Call-to-Action Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => LoginScreenV2()),
                        );
                      },
                      icon: Icon(Icons.login),
                      label: Text('Masuk'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0A84FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => RegisterScreenV2()),
                        );
                      },
                      icon: Icon(Icons.app_registration),
                      label: Text('Daftar Baru'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF0A84FF), width: 2),
                        foregroundColor: Color(0xFF0A84FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Footer
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: Colors.grey[100],
              child: Column(
                children: [
                  Text(
                    '© 2025 LaporPak. All rights reserved.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Hubungi kami: support@laporpak.com',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 24, color: Colors.blue),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
