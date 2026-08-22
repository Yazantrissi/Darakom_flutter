class ProjectReportModel {
  final int id;
  final int projectId;
  final String description;
  final int? reportedProgress;
  final String status;
  final String date;
  final List<String> images;
  final String? title;

  ProjectReportModel({
    required this.id,
    required this.projectId,
    required this.description,
    this.reportedProgress,
    required this.status,
    required this.date,
    this.images = const [],
    this.title,
  });

  factory ProjectReportModel.fromJson(Map<String, dynamic> json) {
    List<String> imageUrls = [];
    if (json['documents'] != null) {
      for (var doc in json['documents']) {
        if (doc is Map) {
          final url = doc['url'] ?? doc['path'];
          if (url != null && url.toString().isNotEmpty) {
            imageUrls.add(url.toString());
          }
        }
      }
    }

    return ProjectReportModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      projectId: json['project_id'] is int
          ? json['project_id']
          : int.tryParse(json['project_id']?.toString() ?? '') ?? 0,
      description: json['details']?.toString() ?? json['description']?.toString() ?? "",
      reportedProgress: json['reported_progress'] is int
          ? json['reported_progress']
          : int.tryParse(json['reported_progress']?.toString() ?? ''),
      status: json['status']?.toString() ?? "pending",
      date: json['created_at']?.toString().split('T').first ?? "",
      images: imageUrls,
      title: json['title']?.toString(),
    );
  }
}
