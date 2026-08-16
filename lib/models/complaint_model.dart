class ComplaintModel {
  final int id;
  final String title;
  final String description;
  final String status;
  final String date;

  ComplaintModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      status: json['status'] ?? "pending",
      date: json['created_at']?.split('T')[0] ?? "",
    );
  }
}
