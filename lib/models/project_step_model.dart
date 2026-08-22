class ProjectStepModel {
  final int id;
  final int projectId;
  final String title;
  final String? description;
  final int progressPercent;
  final String status; // not_started, in_progress, completed
  final String? date;
  final List<Map<String, dynamic>>? attachments;

  ProjectStepModel({
    required this.id,
    required this.projectId,
    required this.title,
    this.description,
    required this.progressPercent,
    required this.status,
    this.date,
    this.attachments,
  });

  static String _mapStatus(String status) {
    switch (status) {
      case 'pending':
        return 'not_started';
      case 'in_progress':
        return 'in_progress';
      case 'completed':
        return 'completed';
      default:
        return status.isNotEmpty ? status : 'not_started';
    }
  }

  static int _progressForStatus(String mappedStatus, dynamic rawProgress) {
    if (rawProgress != null) {
      if (rawProgress is int) return rawProgress;
      final parsed = int.tryParse(rawProgress.toString());
      if (parsed != null) return parsed;
    }
    switch (mappedStatus) {
      case 'completed':
        return 100;
      case 'in_progress':
        return 50;
      default:
        return 0;
    }
  }

  factory ProjectStepModel.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['status']?.toString() ?? 'pending';
    final mappedStatus = _mapStatus(rawStatus);

    return ProjectStepModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      projectId: json['project_id'] is int
          ? json['project_id']
          : int.tryParse(json['project_id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? "",
      description: json['description']?.toString(),
      progressPercent: _progressForStatus(
        mappedStatus,
        json['progress_percent'] ?? json['progress'],
      ),
      status: mappedStatus,
      date: json['date']?.toString() ?? json['updated_at']?.toString().split('T').first,
      attachments: json['attachments'] != null
          ? List<Map<String, dynamic>>.from(json['attachments'])
          : null,
    );
  }

  bool get isCompleted => status == 'completed' || progressPercent == 100;
}
