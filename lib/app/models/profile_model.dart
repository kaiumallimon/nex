class Profile {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  Profile({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<dynamic, dynamic> json) {
    return Profile(
      id: json['id'],
      username: json['username'],
      fullName: json['full_name'],
      email: json['email'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
