class RatingModel {
  final int id;
  final String? toUserName;
  final String? reviewerName;
  final String projectName;
  final double rating;
  final String comment;
  final String date;
  final String? type; // 'given' or 'received'

  RatingModel({
    required this.id,
    this.toUserName,
    this.reviewerName,
    required this.projectName,
    required this.rating,
    required this.comment,
    required this.date,
    this.type,
  });

  // Alias for compatibility with old controller code if needed
  String? get providerName => toUserName;

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    final project = json['project'] as Map<String, dynamic>?;
    final toUser = json['to_user'] as Map<String, dynamic>?;
    final user = json['user'] as Map<String, dynamic>?;

    return RatingModel(
      id: json['id'] ?? 0,
      toUserName: toUser != null ? "${toUser['first_name']} ${toUser['last_name']}" : json['providerName'],
      reviewerName: user != null ? "${user['first_name']} ${user['last_name']}" : json['reviewerName'],
      projectName: project?['title'] ?? json['projectName'] ?? "",
      rating: (json['rate'] ?? json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? "",
      date: json['created_at']?.split('T')[0] ?? json['date'] ?? "",
      type: json['type'],
    );
  }
}
