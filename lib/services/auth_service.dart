import 'package:laporpak/models/user.dart';
import 'dart:math';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // Simulated database
  final List<User> users = [];
  User? currentUser;

  // Initialize with dummy users
  void initializeDummyUsers() {
    if (users.isEmpty) {
      users.addAll([
        User(
          id: _generateId(),
          email: 'masyarakat@example.com',
          password: 'masyarakat123',
          role: 'masyarakat',
          name: 'Budi Santoso',
          nik: '1234567890123456',
          address: 'Jl. Merdeka No. 123, Jakarta',
          createdAt: DateTime.now(),
        ),
        User(
          id: _generateId(),
          email: 'admin@example.com',
          password: 'admin123',
          role: 'admin',
          name: 'Admin Sistem',
          nik: '1234567890123457',
          address: 'Jl. Sudirman No. 456, Jakarta',
          createdAt: DateTime.now(),
        ),
        User(
          id: _generateId(),
          email: 'petugas@example.com',
          password: 'petugas123',
          role: 'petugas',
          name: 'Petugas Lapangan',
          nik: '1234567890123458',
          address: 'Jl. Gatot Subroto No. 789, Jakarta',
          createdAt: DateTime.now(),
        ),
      ]);
    }
  }

  // Login method
  Future<User?> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    try {
      final user = users.firstWhere(
        (u) => u.email == email && u.password == password,
        orElse: () => throw Exception('Email atau password salah'),
      );
      currentUser = user;
      return user;
    } catch (e) {
      return null;
    }
  }

  // Register method
  Future<User?> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    try {
      // Check if email already exists
      final exists = users.any((u) => u.email == email);
      if (exists) {
        throw Exception('Email sudah terdaftar');
      }

      final newUser = User(
        id: _generateId(),
        email: email,
        password: password,
        role: role,
        name: name,
        createdAt: DateTime.now(),
      );

      users.add(newUser);
      currentUser = newUser;
      return newUser;
    } catch (e) {
      return null;
    }
  }

  // Logout method
  void logout() {
    currentUser = null;
  }

  // Update user profile
  Future<User?> updateProfile({
    required String userId,
    required String name,
    String? nik,
    String? address,
    String? photoUrl,
  }) async {
    await Future.delayed(Duration(milliseconds: 300));

    try {
      final index = users.indexWhere((u) => u.id == userId);
      if (index == -1) {
        throw Exception('User tidak ditemukan');
      }

      final updatedUser = users[index].copyWith(
        name: name,
        nik: nik,
        address: address,
        photoUrl: photoUrl,
      );

      users[index] = updatedUser;

      if (currentUser?.id == userId) {
        currentUser = updatedUser;
      }

      return updatedUser;
    } catch (e) {
      return null;
    }
  }

  // Change password
  Future<bool> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    await Future.delayed(Duration(milliseconds: 300));

    try {
      final user = users.firstWhere((u) => u.id == userId);
      if (user.password != oldPassword) {
        throw Exception('Password lama salah');
      }

      final index = users.indexOf(user);
      users[index] = user.copyWith(password: newPassword);

      if (currentUser?.id == userId) {
        currentUser = users[index];
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Get user by ID
  User? getUserById(String userId) {
    try {
      return users.firstWhere((u) => u.id == userId);
    } catch (e) {
      return null;
    }
  }

  // Get all users with specific role
  List<User> getUsersByRole(String role) {
    return users.where((u) => u.role == role).toList();
  }

  // Generate unique ID
  String _generateId() {
    return 'user_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }
}
