import 'package:flutter/material.dart';
import 'package:laporpak/models/user.dart';
import 'package:laporpak/services/pengaduan_service.dart';
import 'package:laporpak/widgets/custom_app_bar.dart';
import 'package:laporpak/widgets/custom_button.dart';
import 'package:laporpak/widgets/custom_text_field.dart';

class ReportFormScreen extends StatefulWidget {
  final User user;

  const ReportFormScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pengaduanService = PengaduanService();
  String _selectedCategory = 'Fasilitas Umum';
  bool _isLoading = false;

  final List<String> _categories = [
    'Fasilitas Umum',
    'Pungutan Liar',
    'Gangguan Keamanan',
    'Kebersihan Lingkungan',
    'Lainnya',
  ];

  void _submitReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final pengaduan = await _pengaduanService.createPengaduan(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        reporterUserId: widget.user.id,
        reporterName: widget.user.name,
        reporterNik: widget.user.nik ?? 'N/A',
      );

      if (pengaduan != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pengaduan berhasil dibuat!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Buat Pengaduan Baru',
        backgroundColor: Colors.blue[600]!,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sampaikan masalah Anda dengan detail',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 24),
                CustomTextField(
                  label: 'Judul Pengaduan',
                  hint: 'Masukkan judul singkat pengaduan',
                  controller: _titleController,
                  prefixIcon: Icon(Icons.title),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    if (value.length < 5) {
                      return 'Judul minimal 5 karakter';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Kategori',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    underline: SizedBox.shrink(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    items: _categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCategory = value);
                      }
                    },
                  ),
                ),
                SizedBox(height: 16),
                CustomTextField(
                  label: 'Deskripsi Lengkap',
                  hint:
                      'Jelaskan masalah secara detail, lokasi, dan dampaknya',
                  controller: _descriptionController,
                  prefixIcon: Icon(Icons.description),
                  maxLines: 8,
                  minLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    if (value.length < 20) {
                      return 'Deskripsi minimal 20 karakter';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue[200]!, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue[600]),
                          SizedBox(width: 8),
                          Text(
                            'Informasi Pelapor',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Nama: ${widget.user.name}',
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'NIK: ${widget.user.nik ?? 'Belum ditentukan'}',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                CustomButton(
                  label: 'KIRIM PENGADUAN',
                  onPressed: _submitReport,
                  isLoading: _isLoading,
                  backgroundColor: Colors.blue[600]!,
                  height: 56,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
