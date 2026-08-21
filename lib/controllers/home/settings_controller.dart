import 'package:get/get.dart';
import '../../services/auth_service.dart';
import '../../views/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // متغير تفاعلي لحالة الإشعارات (مفعلة افتراضياً)
  var isNotificationsEnabled = true.obs;

  void toggleNotifications(bool value) {
    isNotificationsEnabled.value = value;
  }

  Future<void> logout() async {
    final success = await _authService.logout();
    
    if (success) {
      Get.offAll(() => LoginScreen());
    } else {
      // Manual cleanup if API call fails
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Get.offAll(() => LoginScreen());
    }
  }
}
