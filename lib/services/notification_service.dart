import 'package:get/get.dart' hide Response;
import 'api_service.dart';
import '../core/api_constants.dart';
import '../core/api_response.dart';
import '../models/notification_model.dart';

class NotificationService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<Map<String, dynamic>> fetchNotifications() async {
    try {
      final response = await _apiService.get(ApiConstants.notifications);
      if (ApiResponse.isSuccess(response.data)) {
        final data = ApiResponse.dataOf(response.data);
        List list = [];
        int unreadCount = 0;

        if (data is List) {
          list = data;
          unreadCount = list.where((e) {
            final map = Map<String, dynamic>.from(e as Map);
            final raw = map['is_read'] ?? map['read'] ?? false;
            return !(raw == true || raw == 1 || raw == '1');
          }).length;
        } else if (data is Map) {
          list = (data['items'] as List?) ??
              (data['notifications'] as List?) ??
              [];
          unreadCount = data['unread_count'] is int
              ? data['unread_count'] as int
              : list.where((e) {
                  final map = Map<String, dynamic>.from(e as Map);
                  final raw = map['is_read'] ?? map['read'] ?? false;
                  return !(raw == true || raw == 1 || raw == '1');
                }).length;
        }

        final notifications = list
            .map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        return {
          'unread_count': unreadCount,
          'notifications': notifications,
        };
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    }
    return {'unread_count': 0, 'notifications': <NotificationModel>[]};
  }

  Future<bool> markAsRead(String id) async {
    try {
      final response =
          await _apiService.patch(ApiConstants.markNotificationRead(id));
      return ApiResponse.isSuccess(response.data);
    } catch (e) {
      print("Error marking notification as read: $e");
      return false;
    }
  }

  Future<bool> markAllAsRead() async {
    try {
      final response =
          await _apiService.patch(ApiConstants.markAllNotificationsRead);
      return ApiResponse.isSuccess(response.data);
    } catch (e) {
      print("Error marking all notifications as read: $e");
      return false;
    }
  }

  Future<bool> deleteNotification(String id) async {
    try {
      final response =
          await _apiService.delete(ApiConstants.deleteNotification(id));
      return ApiResponse.isSuccess(response.data);
    } catch (e) {
      print("Error deleting notification: $e");
      return false;
    }
  }
}
