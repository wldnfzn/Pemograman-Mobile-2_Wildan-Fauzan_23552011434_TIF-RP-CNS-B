import 'package:flutter/material.dart';
import 'package:laporpak/models/user.dart';
import 'package:laporpak/screens/admin_dashboard_enhanced_screen.dart';
import 'package:laporpak/screens/home_screen.dart';
import 'package:laporpak/screens/login_screen_v2.dart';
import 'package:laporpak/screens/masyarakat_dashboard_enhanced_screen.dart';
import 'package:laporpak/screens/petugas_dashboard_enhanced_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LaporPak - Aplikasi Pengaduan Masyarakat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: HomeScreen(),
      routes: {
        '/login': (context) => LoginScreenV2(),
        '/dashboard': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as User;
          if (user.role == 'masyarakat') {
            return MasyarakatDashboardEnhancedScreen(user: user);
          } else if (user.role == 'admin') {
            return AdminDashboardEnhancedScreen(user: user);
          } else if (user.role == 'petugas') {
            return PetugasDashboardEnhancedScreen(user: user);
          }
          return LoginScreenV2();
        },
      },
    );
  }
}
