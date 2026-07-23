import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final NotificationsController controller = Get.put(NotificationsController());

  // الألوان الأساسية
  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);
  final Color bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // دعم الواجهة العربية
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            // 1. الهيدر الكحلي المخصص
            _buildCustomHeader(),

            // 2. قائمة الإشعارات
            Expanded(
              child: Obx(() => ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                itemCount: controller.notifications.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final notification = controller.notifications[index];
                  return _buildNotificationCard(notification);
                },
              )),
            ),
          ],
        ),
      ),
    );
  }

  // --- دوال بناء الواجهة --- //

  // 1. الهيدر المنحني
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
          // زر "تحديد الكل كمقروء" (على اليسار)
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

          // العنوان (في المنتصف)
          const Text(
            'الإشعارات',
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // زر العودة (على اليمين)
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

  // 2. بطاقة الإشعار
  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    // تحديد خصائص الأيقونة واللون بناءً على نوع الإشعار
    IconData iconData;
    Color iconColor;

    switch (notification['type']) {
      case 'success':
        iconData = Icons.check_circle_outline_rounded;
        iconColor = Colors.green;
        break;
      case 'update':
        iconData = Icons.notifications_none_rounded;
        iconColor = orangeColor;
        break;
      case 'alert':
        iconData = Icons.error_outline_rounded;
        iconColor = Colors.redAccent;
        break;
      case 'rating':
        iconData = Icons.star_border_rounded;
        iconColor = orangeColor;
        break;
      case 'message':
        iconData = Icons.chat_bubble_outline_rounded;
        iconColor = Colors.purpleAccent;
        break;
      default:
        iconData = Icons.notifications_none_rounded;
        iconColor = navyColor;
    }

    bool isRead = notification['isRead'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
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
          // الأيقونة بخلفية شفافة خفيفة
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

          // محتوى الإشعار (العنوان والنص)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'],
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 15,
                    fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                    color: navyColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification['body'],
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

          // الوقت والنقطة البرتقالية (لغير المقروء)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                notification['time'],
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 11,
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
    );
  }
}