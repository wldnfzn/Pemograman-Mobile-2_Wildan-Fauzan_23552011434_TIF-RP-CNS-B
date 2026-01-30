import 'package:flutter/material.dart';
import 'package:laporpak/models/pengaduan.dart';
import 'package:laporpak/services/auth_service.dart';
import 'package:laporpak/services/pengaduan_service.dart';
import 'package:laporpak/widgets/custom_app_bar.dart';
import 'package:laporpak/widgets/custom_button.dart';

class AdminAssignPetugasScreen extends StatefulWidget {
  final Pengaduan pengaduan;

  const AdminAssignPetugasScreen({Key? key, required this.pengaduan})
      : super(key: key);

  @override
  State<AdminAssignPetugasScreen> createState() =>
      _AdminAssignPetugasScreenState();
}

class _AdminAssignPetugasScreenState extends State<AdminAssignPetugasScreen> {
  final _authService = AuthService();
  final _pengaduanService = PengaduanService();
  String? _selectedPetugasId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedPetugasId = widget.pengaduan.assignedToPetugasId;
  }

  void _assignPetugas() async {
    if (_selectedPetugasId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih petugas terlebih dahulu')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final petugas = _authService.getUserById(_selectedPetugasId!);
    if (petugas != null) {
      final updated = await _pengaduanService.assignToPetugas(
        pengaduanId: widget.pengaduan.id,
        petugasUserId: _selectedPetugasId!,
        petugasName: petugas.name,
      );

      if (updated != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pengaduan ditugaskan ke ${petugas.name}'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final petugas = _authService.getUsersByRole('petugas');

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Tugaskan ke Petugas',
        backgroundColor: Colors.green[600]!,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pengaduan:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.pengaduan.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Pilih Petugas',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: petugas.isEmpty
                  ? Center(
                      child: Text('Tidak ada petugas tersedia'),
                    )
                  : ListView.builder(
                      itemCount: petugas.length,
                      itemBuilder: (context, index) {
                        final p = petugas[index];
                        final isSelected = _selectedPetugasId == p.id;

                        return Card(
                          margin: EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            onTap: () =>
                                setState(() => _selectedPetugasId = p.id),
                            selected: isSelected,
                            selectedTileColor:
                                Colors.green[50],
                            leading: Radio<String>(
                              value: p.id,
                              groupValue: _selectedPetugasId,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() =>
                                      _selectedPetugasId = value);
                                }
                              },
                            ),
                            title: Text(
                              p.name,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(p.email),
                            trailing: Icon(
                              Icons.check_circle,
                              color: isSelected
                                  ? Colors.green
                                  : Colors.grey[300],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 24),
            CustomButton(
              label: 'TUGASKAN PETUGAS',
              onPressed: _assignPetugas,
              isLoading: _isLoading,
              backgroundColor: Colors.green[600]!,
              height: 56,
            ),
          ],
        ),
      ),
    );
  }
}
