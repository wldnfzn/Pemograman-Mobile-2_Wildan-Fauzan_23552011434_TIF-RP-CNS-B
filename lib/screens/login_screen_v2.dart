import 'package:flutter/material.dart';
import 'package:laporpak/screens/register_screen_v2.dart';
import 'package:laporpak/services/auth_service.dart';
import 'package:laporpak/services/pengaduan_service.dart';
import 'package:laporpak/widgets/custom_button.dart';
import 'package:laporpak/widgets/custom_text_field.dart';

class LoginScreenV2 extends StatefulWidget {
  @override
  State<LoginScreenV2> createState() => _LoginScreenV2State();
}

class _LoginScreenV2State extends State<LoginScreenV2> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  final _pengaduanService = PengaduanService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService.initializeDummyUsers();
    _pengaduanService.initializeDummyPengaduans();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final user = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (user != null) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(
            '/dashboard',
            arguments: user,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email atau password salah'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A84FF), Color(0xFF0066CC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.report_problem, size: 72, color: Colors.white),
                    SizedBox(height: 12),
                    Text('LaporPak', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text('Aplikasi Pengaduan Masyarakat', style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 24),

                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 8,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomTextField(
                                    label: 'Email',
                                    hint: 'name@example.com',
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    prefixIcon: Icon(Icons.email_outlined),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
                                      if (!value.contains('@')) return 'Format email tidak valid';
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 12),
                                  CustomTextField(
                                    label: 'Password',
                                    hint: 'Masukkan password Anda',
                                    controller: _passwordController,
                                    obscureText: true,
                                    prefixIcon: Icon(Icons.lock_outline),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 18),
                                  CustomButton(label: 'Masuk', onPressed: _login, isLoading: _isLoading, height: 52),
                                ],
                              ),
                            ),

                            SizedBox(height: 12),
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text('Belum punya akun? '),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RegisterScreenV2())),
                                child: Text('Daftar', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A84FF))),
                              ),
                            ]),

                            SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
