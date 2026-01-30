import 'package:flutter/material.dart';
import 'package:laporpak/models/user.dart';
import 'package:laporpak/services/auth_service.dart';
import 'package:laporpak/widgets/custom_button.dart';
import 'package:laporpak/widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _user;
  final _authService = AuthService();
  bool _isEditMode = false;

  // Edit form controllers
  late TextEditingController _nameController;
  late TextEditingController _nikController;
  late TextEditingController _addressController;

  // Change password controllers
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _nameController = TextEditingController(text: _user.name);
    _nikController = TextEditingController(text: _user.nik ?? '');
    _addressController = TextEditingController(text: _user.address ?? '');
  }

  void _saveProfile() async {
    final updated = await _authService.updateProfile(
      userId: _user.id,
      name: _nameController.text.trim(),
      nik: _nikController.text.trim(),
      address: _addressController.text.trim(),
    );

    if (updated != null && mounted) {
      setState(() {
        _user = updated;
        _isEditMode = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil berhasil diperbarui'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _changePassword() async {
    if (_newPasswordController.text !=
        _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password baru tidak cocok'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await _authService.changePassword(
      userId: _user.id,
      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password berhasil diubah'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengubah password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _addressController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.blue[700]!],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 48,
                      color: Colors.blue[600],
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    _user.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getDisplayRole(_user.role),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Profile info
            Text(
              'Informasi Profil',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            if (!_isEditMode) ...[
              _buildInfoCard('Email', _user.email),
              _buildInfoCard('NIK', _user.nik ?? 'Belum ditentukan'),
              _buildInfoCard('Alamat', _user.address ?? 'Belum ditentukan'),
              SizedBox(height: 20),
              CustomButton(
                label: 'EDIT PROFIL',
                onPressed: () => setState(() => _isEditMode = true),
                backgroundColor: Colors.blue[600]!,
              ),
            ] else ...[
              CustomTextField(
                label: 'Nama',
                controller: _nameController,
                prefixIcon: Icon(Icons.person),
              ),
              SizedBox(height: 12),
              CustomTextField(
                label: 'NIK',
                controller: _nikController,
                prefixIcon: Icon(Icons.badge),
              ),
              SizedBox(height: 12),
              CustomTextField(
                label: 'Alamat',
                controller: _addressController,
                prefixIcon: Icon(Icons.location_on),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              CustomButton(
                label: 'SIMPAN',
                onPressed: _saveProfile,
                backgroundColor: Colors.green[600]!,
              ),
              SizedBox(height: 12),
              CustomButton(
                label: 'BATAL',
                onPressed: () => setState(() => _isEditMode = false),
                backgroundColor: Colors.grey[600]!,
              ),
            ],
            SizedBox(height: 24),
            // Change password section
            Text(
              'Keamanan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            CustomButton(
              label: 'UBAH PASSWORD',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ChangePasswordDialog(
                    onSubmit: _changePassword,
                    oldPasswordController: _oldPasswordController,
                    newPasswordController: _newPasswordController,
                    confirmPasswordController: _confirmPasswordController,
                  ),
                );
              },
              backgroundColor: Colors.orange[600]!,
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _getDisplayRole(String role) {
    switch (role) {
      case 'masyarakat':
        return 'Masyarakat (Pelapor)';
      case 'admin':
        return 'Administrator';
      case 'petugas':
        return 'Petugas Lapangan';
      default:
        return role;
    }
  }
}

class ChangePasswordDialog extends StatefulWidget {
  final VoidCallback onSubmit;
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  const ChangePasswordDialog({
    Key? key,
    required this.onSubmit,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
  }) : super(key: key);

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ubah Password'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              label: 'Password Lama',
              controller: widget.oldPasswordController,
              obscureText: true,
              prefixIcon: Icon(Icons.lock),
            ),
            SizedBox(height: 12),
            CustomTextField(
              label: 'Password Baru',
              controller: widget.newPasswordController,
              obscureText: true,
              prefixIcon: Icon(Icons.lock),
            ),
            SizedBox(height: 12),
            CustomTextField(
              label: 'Konfirmasi Password',
              controller: widget.confirmPasswordController,
              obscureText: true,
              prefixIcon: Icon(Icons.lock),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSubmit();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
          ),
          child: Text('Ubah'),
        ),
      ],
    );
  }
}
