import 'package:get/get.dart';
import '../../views/home/profile_screen.dart';
import '../../views/auth/login_screen.dart';
import '../../views/auth/reset_password_screen.dart'; // استيراد شاشة تغيير كلمة السر

class SettingsController extends GetxController {
  // حالة زر تفعيل الإشعارات
  var isPushNotificationEnabled = true.obs;

  void togglePushNotification(bool value) {
    isPushNotificationEnabled.value = value;
  }

  void goToProfile() {
    Get.to(() => ProfileScreen());
  }

  // تفعيل دالة الانتقال إلى شاشة تغيير كلمة السر
  void goToChangePassword() {
    Get.to(() => ResetPasswordScreen());
  }

  void logout() {
    // مسح جميع المسارات والعودة لشاشة تسجيل الدخول
    Get.offAll(() => LoginScreen());
  }
}