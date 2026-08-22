class NotificationModel {
  final String id;
  final String type;
  final String? title;
  final String? message;
  final Map<String, dynamic>? data;
  final String createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    this.title,
    this.message,
    this.data,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final title = json['title']?.toString();
    final isReadRaw = json['is_read'] ?? json['read'] ?? false;
    final isRead = isReadRaw == true || isReadRaw == 1 || isReadRaw == '1';

    return NotificationModel(
      id: json['id']?.toString() ?? "",
      type: json['type']?.toString() ?? title ?? "",
      title: title,
      message: json['message']?.toString(),
      data: json['data'] is Map ? Map<String, dynamic>.from(json['data']) : null,
      createdAt: json['created_at']?.toString() ?? "",
      isRead: isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'message': message,
      'data': data,
      'created_at': createdAt,
      'is_read': isRead,
    };
  }
}
