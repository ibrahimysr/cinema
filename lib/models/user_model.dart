class UserModel {
  final int id;
  final String name;
  final String email;
  final int roleId;
  final int? cinemaId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.roleId,
    this.cinemaId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      roleId: json['role_id'],
      cinemaId: json['cinema_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role_id': roleId,
      'cinema_id': cinemaId,
    };
  }
} 