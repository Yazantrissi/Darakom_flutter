class ProvinceModel {
  final int id;
  final String name;

  ProvinceModel({required this.id, required this.name});

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProvinceModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
