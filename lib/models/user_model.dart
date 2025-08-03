class User {
  final String id;
  final String name;
  final String phoneNumber;
  final String? email;
  final bool isAdmin;

  User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.isAdmin = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'],
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'isAdmin': isAdmin,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    bool? isAdmin,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}