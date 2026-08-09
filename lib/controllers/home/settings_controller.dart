import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../views/auth/login_screen.dart';

class SettingsController extends GetxController {
  // متغير تفاعلي لحالة الإشعارات (مفعلة افتراضياً)
  var isNotificationsEnabled = true.obs;

  void toggleNotifications(bool value) {
    isNotificationsEnabled.value = value;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_type');

    Get.offAll(() => LoginScreen());
  }
}
