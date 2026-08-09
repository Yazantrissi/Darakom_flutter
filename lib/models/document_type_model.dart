class DocumentTypeModel {
  final int id;
  final String name;

  DocumentTypeModel({required this.id, required this.name});

  factory DocumentTypeModel.fromJson(Map<String, dynamic> json) {
    return DocumentTypeModel(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentTypeModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
