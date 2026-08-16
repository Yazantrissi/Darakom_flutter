class RatingModel {
  final String? providerName;
  final String? reviewerName;
  final String projectName;
  final double rating;
  final String comment;
  final String date;

  RatingModel({
    this.providerName,
    this.reviewerName,
    required this.projectName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      providerName: json['providerName'],
      reviewerName: json['reviewerName'],
      projectName: json['projectName'] ?? "",
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? "",
      date: json['date'] ?? "",
    );
  }
}
