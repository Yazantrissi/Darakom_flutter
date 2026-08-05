class PostModel {
  final String id;
  final String description;
  final List<String> images;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.description,
    required this.images,
    required this.createdAt,
  });
}