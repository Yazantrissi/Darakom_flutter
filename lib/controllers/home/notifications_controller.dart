import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../models/notification_model.dart';
import '../../services/notification_service.dart';

class NotificationsController extends GetxController {
  final NotificationService _notificationService = Get.find<NotificationService>();

  var notifications = <NotificationModel>[].obs;
  var unreadCount = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final result = await _notificationService.fetchNotifications();
      unreadCount.value = result['unread_count'];
      notifications.assignAll(result['notifications']);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String id) async {
    final success = await _notificationService.markAsRead(id);
    if (success) {
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        final n = notifications[index];
        notifications[index] = NotificationModel(
          id: n.id,
          type: n.type,
          message: n.message,
          data: n.data,
          createdAt: n.createdAt,
          isRead: true,
        );
        if (unreadCount.value > 0) unreadCount.value--;
      }
    }
  }

  Future<void> markAllAsRead() async {
    final success = await _notificationService.markAllAsRead();
    if (success) {
      notifications.assignAll(notifications.map((n) => NotificationModel(
        id: n.id,
        type: n.type,
        message: n.message,
        data: n.data,
        createdAt: n.createdAt,
        isRead: true,
      )).toList());
      unreadCount.value = 0;
      Get.snackbar('تم بنجاح', 'تم تحديد جميع الإشعارات كمقروءة', 
        backgroundColor: Colors.green, colorText: Colors.white);
    }
  }

  Future<void> deleteNotification(String id) async {
    final success = await _notificationService.deleteNotification(id);
    if (success) {
      notifications.removeWhere((n) => n.id == id);
      Get.snackbar('تم', 'تم حذف الإشعار', backgroundColor: Colors.black87, colorText: Colors.white);
    }
  }
}
