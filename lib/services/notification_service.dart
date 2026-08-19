import 'package:get/get.dart' hide Response;
import 'api_service.dart';
import '../core/api_constants.dart';
import '../models/notification_model.dart';

class NotificationService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<Map<String, dynamic>> fetchNotifications() async {
    try {
      final response = await _apiService.get(ApiConstants.notifications);
      if (response.data['success']) {
        final data = response.data['data'];
        final List list = data['notifications'] ?? [];
        return {
          'unread_count': data['unread_count'] ?? 0,
          'notifications': list.map((e) => NotificationModel.fromJson(e)).toList(),
        };
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    }
    return {'unread_count': 0, 'notifications': <NotificationModel>[]};
  }

  Future<bool> markAsRead(String id) async {
    try {
      final response = await _apiService.patch("${ApiConstants.markNotificationRead}/$id/read");
      return response.data['success'];
    } catch (e) {
      print("Error marking notification as read: $e");
      return false;
    }
  }

  Future<bool> markAllAsRead() async {
    try {
      final response = await _apiService.patch(ApiConstants.markAllNotificationsRead);
      return response.data['success'];
    } catch (e) {
      print("Error marking all notifications as read: $e");
      return false;
    }
  }

  Future<bool> deleteNotification(String id) async {
    try {
      final response = await _apiService.delete("${ApiConstants.notifications}/$id");
      return response.data['success'];
    } catch (e) {
      print("Error deleting notification: $e");
      return false;
    }
  }
}
