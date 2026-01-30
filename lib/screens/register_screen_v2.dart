import 'package:flutter/material.dart';
import 'package:laporpak/services/auth_service.dart';
import 'package:laporpak/widgets/custom_button.dart';
import 'package:laporpak/widgets/custom_text_field.dart';

class RegisterScreenV2 extends StatefulWidget {
  @override
  State<RegisterScreenV2> createState() => _RegisterScreenV2State();
}

class _RegisterScreenV2State extends State<RegisterScreenV2> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = 'masyarakat';
  bool _isLoading = false;
  final _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final user = await _authService.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        role: _role,
      );

      if (user != null) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registrasi berhasil')));
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registrasi gagal')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar'), elevation: 0),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 6,
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextField(label: 'Nama', controller: _nameController, prefixIcon: Icon(Icons.person_outline), validator: (v) => v==null||v.isEmpty ? 'Nama wajib diisi' : null),
                    SizedBox(height: 10),
                    CustomTextField(label: 'Email', controller: _emailController, keyboardType: TextInputType.emailAddress, prefixIcon: Icon(Icons.email_outlined), validator: (v) => v==null||!v.contains('@') ? 'Email tidak valid' : null),
                    SizedBox(height: 10),
                    CustomTextField(label: 'Password', controller: _passwordController, obscureText: true, prefixIcon: Icon(Icons.lock_outline), validator: (v) => v==null||v.length<6 ? 'Minimal 6 karakter' : null),
                    SizedBox(height: 12),

                    Row(children: [
                      Expanded(child: Text('Daftar sebagai')),
                      DropdownButton<String>(value: _role, items: [
                        DropdownMenuItem(value: 'masyarakat', child: Text('Masyarakat')),
                        DropdownMenuItem(value: 'petugas', child: Text('Petugas')),
                      ], onChanged: (v) => setState(() => _role = v ?? 'masyarakat'))
                    ]),

                    SizedBox(height: 14),
                    CustomButton(label: 'Daftar', onPressed: _register, isLoading: _isLoading),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
