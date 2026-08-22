class RoleModel {
  final int id;
  final String name;
  /// Main provider type sent to API (e.g. مقاول, حرفي).
  final String? providerType;
  /// Craftsman subtype when providerType is حرفي.
  final String? craftsmanSubtype;

  RoleModel({
    required this.id,
    required this.name,
    this.providerType,
    this.craftsmanSubtype,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    int parseId(dynamic val) {
      if (val is int) return val;
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    return RoleModel(
      id: parseId(json['id']),
      name: (json['label'] ?? json['name'] ?? '').toString(),
      providerType: json['provider_type']?.toString(),
      craftsmanSubtype: json['craftsman_subtype']?.toString(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoleModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
