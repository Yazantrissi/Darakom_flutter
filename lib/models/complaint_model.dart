class ComplaintModel {
  final int id;
  final String complaintCode;
  final String description;
  final String status;
  final String date;
  final String projectName;
  final String? defendantName;
  final String? resolution;

  ComplaintModel({
    required this.id,
    required this.complaintCode,
    required this.description,
    required this.status,
    required this.date,
    required this.projectName,
    this.defendantName,
    this.resolution,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    final project = json['project'] as Map<String, dynamic>?;
    
    // Attempting to get defendant name from project performer
    String? dName;
    if (project != null && project['performer'] != null) {
       final user = project['performer']['user'];
       if (user != null) {
         dName = "${user['first_name']} ${user['last_name']}";
       }
    }

    return ComplaintModel(
      id: json['id'] ?? 0,
      complaintCode: "#CMP-${json['id']}",
      description: json['text'] ?? "",
      status: json['status'] ?? "pending",
      date: json['created_at']?.split('T')[0] ?? "",
      projectName: project?['title'] ?? "مشروع غير محدد",
      defendantName: dName ?? "غير محدد",
      resolution: json['admin_response'],
    );
  }
}
