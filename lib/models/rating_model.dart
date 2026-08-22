class RatingModel {
  final int id;
  final String? toUserName;
  final String? reviewerName;
  final String projectName;
  final double rating;
  final String comment;
  final String date;
  final String? type;

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

  String? get providerName => toUserName;

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    final project = json['project'] as Map<String, dynamic>?;
    final reviewedUser = json['reviewed_user'] as Map<String, dynamic>?;
    final reviewer = json['reviewer'] as Map<String, dynamic>?;
    final toUser = json['to_user'] as Map<String, dynamic>?;
    final user = json['user'] as Map<String, dynamic>?;

    double parseDouble(dynamic val) {
      if (val is double) return val;
      if (val is int) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    String? nameFrom(Map<String, dynamic>? u) {
      if (u == null) return null;
      if (u['name'] != null) return u['name'].toString();
      final first = u['first_name']?.toString() ?? '';
      final last = u['last_name']?.toString() ?? '';
      final full = '$first $last'.trim();
      return full.isEmpty ? null : full;
    }

    return RatingModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      toUserName: nameFrom(reviewedUser) ?? nameFrom(toUser) ?? json['providerName']?.toString(),
      reviewerName: nameFrom(reviewer) ?? nameFrom(user) ?? json['reviewerName']?.toString(),
      projectName: project?['title']?.toString() ?? json['projectName']?.toString() ?? "",
      rating: parseDouble(json['score'] ?? json['rate'] ?? json['rating'] ?? 0.0),
      comment: json['comment']?.toString() ?? "",
      date: json['created_at']?.toString().split('T').first ?? json['date']?.toString() ?? "",
      type: json['type']?.toString(),
    );
  }
}
