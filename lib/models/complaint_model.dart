class ComplaintModel {
  final int id;
  final String complaintCode;
  final String description;
  final String status;
  final String date;
  final String projectName;
  final String? defendantName;
  final String? resolution;
  final String? subject;

  ComplaintModel({
    required this.id,
    required this.complaintCode,
    required this.description,
    required this.status,
    required this.date,
    required this.projectName,
    this.defendantName,
    this.resolution,
    this.subject,
  });

  /// Normalize legacy statuses, then map pending_review -> pending for UI filters.
  static String _mapStatus(String status) {
    String normalized = status;
    switch (status) {
      case 'open':
      case 'in_review':
        normalized = 'pending_review';
        break;
      case 'closed':
        return 'rejected';
    }

    switch (normalized) {
      case 'pending_review':
      case 'pending':
        return 'pending';
      case 'resolved':
        return 'resolved';
      case 'rejected':
        return 'rejected';
      default:
        return normalized;
    }
  }

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    final project = json['project'] as Map<String, dynamic>?;
    final reportedUser = json['reported_user'] as Map<String, dynamic>?;

    String? dName = reportedUser?['name']?.toString();
    if (dName == null && project != null && project['performer'] != null) {
      final user = project['performer']['user'];
      if (user != null) {
        dName = user['name']?.toString() ??
            "${user['first_name'] ?? ''} ${user['last_name'] ?? ''}".trim();
      }
    }

    final rawStatus = json['status']?.toString() ?? 'pending_review';

    return ComplaintModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      complaintCode: "#CMP-${json['id']}",
      description:
          json['message']?.toString() ?? json['text']?.toString() ?? "",
      status: _mapStatus(rawStatus),
      date: json['created_at']?.toString().split('T').first ?? "",
      projectName: project?['title']?.toString() ?? "مشروع غير محدد",
      defendantName: dName ?? "غير محدد",
      resolution: json['admin_response']?.toString(),
      subject: json['subject']?.toString(),
    );
  }
}
