class NotificationModel {
  final String id;
  final String type;
  final String? message;
  final Map<String, dynamic>? data;
  final String createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    this.message,
    this.data,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? "",
      type: json['type']?.toString() ?? "",
      message: json['message']?.toString(),
      data: json['data'] is Map ? Map<String, dynamic>.from(json['data']) : null,
      createdAt: json['created_at']?.toString() ?? "",
      isRead: json['read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'message': message,
      'data': data,
      'created_at': createdAt,
      'read': isRead,
    };
  }
}
