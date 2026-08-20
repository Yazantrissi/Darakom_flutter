class ProjectReportModel {
  final int id;
  final int projectId;
  final String description;
  final int? reportedProgress;
  final String status; // pending, approved, rejected
  final String date;
  final List<String> images;

  ProjectReportModel({
    required this.id,
    required this.projectId,
    required this.description,
    this.reportedProgress,
    required this.status,
    required this.date,
    this.images = const [],
  });

  factory ProjectReportModel.fromJson(Map<String, dynamic> json) {
    List<String> imageUrls = [];
    if (json['documents'] != null) {
      for (var doc in json['documents']) {
        if (doc['path'] != null) {
          imageUrls.add(doc['url'] ?? ""); // Using URL from Resource if available
        }
      }
    }

    return ProjectReportModel(
      id: json['id'] ?? 0,
      projectId: json['project_id'] ?? 0,
      description: json['description'] ?? "",
      reportedProgress: json['reported_progress'],
      status: json['status'] ?? "pending",
      date: json['created_at']?.split('T')[0] ?? "",
      images: imageUrls,
    );
  }
}
