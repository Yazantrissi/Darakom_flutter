class RoleModel {
  final int id;
  final String name;

  RoleModel({required this.id, required this.name});

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoleModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
