import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/notification_model.dart';
import '../../services/notification_service.dart';
import '../../views/home/client_offers_screen.dart';
import '../../views/home/complaints_screen.dart';
import '../../views/home/ratings_screen.dart';
import '../../views/provider/provider_profile_screen.dart';
import '../../views/provider/tender_market_screen.dart';
import '../../views/provider/my_offers_screen.dart';
import '../../views/tracking/project_tracking_screen.dart';

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

  NotificationModel _copyWithRead(NotificationModel n, {required bool isRead}) {
    return NotificationModel(
      id: n.id,
      type: n.type,
      title: n.title,
      message: n.message,
      data: n.data,
      createdAt: n.createdAt,
      isRead: isRead,
    );
  }

  Future<void> markAsRead(String id) async {
    final success = await _notificationService.markAsRead(id);
    if (success) {
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        final n = notifications[index];
        if (!n.isRead && unreadCount.value > 0) unreadCount.value--;
        notifications[index] = _copyWithRead(n, isRead: true);
      }
    }
  }

  Future<void> markAllAsRead() async {
    final success = await _notificationService.markAllAsRead();
    if (success) {
      notifications.assignAll(
        notifications.map((n) => _copyWithRead(n, isRead: true)).toList(),
      );
      unreadCount.value = 0;
      Get.snackbar(
        'تم بنجاح',
        'تم تحديد جميع الإشعارات كمقروءة',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteNotification(String id) async {
    final success = await _notificationService.deleteNotification(id);
    if (success) {
      notifications.removeWhere((n) => n.id == id);
      Get.snackbar(
        'تم',
        'تم حذف الإشعار',
        backgroundColor: Colors.black87,
        colorText: Colors.white,
      );
    }
  }

  Future<void> openNotification(NotificationModel notification) async {
    if (!notification.isRead) {
      await markAsRead(notification.id);
    }

    final data = notification.data ?? {};
    final action = (data['action'] ?? '').toString();
    final projectId = int.tryParse('${data['project_id'] ?? ''}');
    final projectTitle =
        (data['project_title'] ?? notification.title ?? 'مشروع').toString();

    final prefs = await SharedPreferences.getInstance();
    final isProvider = prefs.getString('user_type') == 'provider';

    switch (action) {
      case 'client_offers':
        Get.to(() => ClientOffersScreen(projectId: projectId));
        break;
      case 'client_tracking':
      case 'provider_tracking':
        if (projectId != null && projectId > 0) {
          Get.to(
            () => ProjectTrackingScreen(),
            arguments: {
              'projectId': projectId,
              'projectTitle': projectTitle,
              'isProvider': action == 'provider_tracking' || isProvider,
              'canRate': action == 'client_tracking' && !isProvider,
            },
          );
        }
        break;
      case 'complaints':
        Get.to(() => ComplaintsScreen());
        break;
      case 'provider_tenders':
        Get.to(() => TenderMarketScreen());
        break;
      case 'provider_offers':
        Get.to(() => MyOffersScreen());
        break;
      case 'provider_reviews':
        Get.to(() => RatingsScreen());
        break;
      case 'provider_profile':
        Get.to(() => ProviderProfileScreen());
        break;
      default:
        if (projectId != null && projectId > 0) {
          Get.to(
            () => ProjectTrackingScreen(),
            arguments: {
              'projectId': projectId,
              'projectTitle': projectTitle,
              'isProvider': isProvider,
            },
          );
        }
        break;
    }
  }
}
