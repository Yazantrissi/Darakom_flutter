class ProjectStepModel {
  final int id;
  final int projectId;
  final String title;
  final String? description;
  final int progressPercent;
  final String status; // not_started, in_progress, completed
  final String? date;

  ProjectStepModel({
    required this.id,
    required this.projectId,
    required this.title,
    this.description,
    required this.progressPercent,
    required this.status,
    this.date,
  });

  factory ProjectStepModel.fromJson(Map<String, dynamic> json) {
    return ProjectStepModel(
      id: json['id'] ?? 0,
      projectId: json['project_id'] ?? 0,
      title: json['title'] ?? "",
      description: json['description'],
      progressPercent: json['progress_percent'] ?? 0,
      status: json['status'] ?? "not_started",
      date: json['date'] ?? json['updated_at']?.split('T')[0],
    );
  }

  bool get isCompleted => status == 'completed' || progressPercent == 100;
}
