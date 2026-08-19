import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/notifications_controller.dart';
import '../../models/notification_model.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final NotificationsController controller = Get.put(NotificationsController());

  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);
  final Color bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            _buildCustomHeader(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.notifications.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.notifications.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchNotifications,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                    itemCount: controller.notifications.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final notification = controller.notifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 24, left: 24, right: 24),
      decoration: BoxDecoration(
        color: navyColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
          bottomRight: Radius.circular(32.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: controller.markAllAsRead,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'تحديد الكل كمقروء',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: orangeColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Text(
            'الإشعارات',
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
              onPressed: () => Get.back(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    IconData iconData;
    Color iconColor;

    // Mapping backend notification type classes to UI
    switch (notification.type) {
      case 'AcceptProvider':
        iconData = Icons.check_circle_outline_rounded;
        iconColor = Colors.green;
        break;
      case 'UrgentProject':
        iconData = Icons.flash_on_rounded;
        iconColor = Colors.redAccent;
        break;
      case 'RejectOffer':
        iconData = Icons.cancel_outlined;
        iconColor = Colors.grey;
        break;
      default:
        iconData = Icons.notifications_none_rounded;
        iconColor = orangeColor;
    }

    bool isRead = notification.isRead;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => controller.deleteNotification(notification.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () {
          if (!isRead) controller.markAsRead(notification.id);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isRead ? Colors.white : const Color(0xFFF9FAFC),
            borderRadius: BorderRadius.circular(16.0),
            border: isRead ? null : Border.all(color: orangeColor.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(iconData, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getNotificationTitle(notification),
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 15,
                        fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                        color: navyColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message ?? "",
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatTime(notification.createdAt),
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 10,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (!isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: orangeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getNotificationTitle(NotificationModel n) {
    switch (n.type) {
      case 'AcceptProvider': return 'تم قبول العرض';
      case 'UrgentProject': return 'مناقصة مستعجلة';
      case 'RejectOffer': return 'تم رفض العرض';
      default: return 'تنبيه جديد';
    }
  }

  String _formatTime(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);
      
      if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
      if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
      return '${date.day}/${date.month}';
    } catch (e) {
      return dateStr.split('T')[0];
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'لا توجد إشعارات حالياً',
            style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
