class User {
  final String id;
  final String email;
  final String password;
  final String role; // 'masyarakat', 'admin', 'petugas'
  final String name;
  final String? nik;
  final String? address;
  final String? photoUrl;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.role,
    required this.name,
    this.nik,
    this.address,
    this.photoUrl,
    required this.createdAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? password,
    String? role,
    String? name,
    String? nik,
    String? address,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      name: name ?? this.name,
      nik: nik ?? this.nik,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'User(id: $id, email: $email, role: $role, name: $name)';
}
