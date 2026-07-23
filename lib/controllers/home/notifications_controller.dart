import 'package:get/get.dart';

class NotificationsController extends GetxController {
  // قائمة الإشعارات (تستخدم .obs لتحديث الواجهة عند التغيير)
  var notifications = <Map<String, dynamic>>[
    {
      'id': 1,
      'type': 'success',
      'title': 'تم قبول عرضك',
      'body': 'قبل مقاول فيلا النخيل طلبك',
      'time': 'منذ دقائق',
      'isRead': false,
    },
    {
      'id': 2,
      'type': 'update',
      'title': 'تحديث المشروع',
      'body': 'اكتملت مرحلة الهيكل الإنشائي',
      'time': 'منذ ساعة',
      'isRead': false,
    },
    {
      'id': 3,
      'type': 'alert',
      'title': 'تنبيه موعد',
      'body': 'اجتماع مع المهندس غداً الساعة ١٠ ص',
      'time': 'أمس',
      'isRead': true,
    },
    {
      'id': 4,
      'type': 'rating',
      'title': 'تقييم جديد',
      'body': 'أضاف أحمد العمري تقييماً لمشروعك',
      'time': '٢ يناير',
      'isRead': true,
    },
    {
      'id': 5,
      'type': 'message',
      'title': 'رسالة جديدة',
      'body': 'أرسل المقاول تفاصيل العقد',
      'time': '١ يناير',
      'isRead': true,
    },
  ].obs;

  // دالة تحديد الكل كمقروء
  void markAllAsRead() {
    for (var i = 0; i < notifications.length; i++) {
      var notification = notifications[i];
      notification['isRead'] = true;
      notifications[i] = notification; // تحديث العنصر في القائمة
    }
    // تحديث الواجهة
    notifications.refresh();
  }
}