class UserModel {
  final int id;
  final String name;
  final String email;
  final String type;
  final String status;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.status,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      type: json['type'] ?? "",
      status: json['status'] ?? "",
      token: json['token'],
    );
  }
}
