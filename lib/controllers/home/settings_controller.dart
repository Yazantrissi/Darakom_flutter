import 'package:get/get.dart';
import '../../services/auth_service.dart';

class SettingsController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // متغير تفاعلي لحالة الإشعارات (مفعلة افتراضياً)
  var isNotificationsEnabled = true.obs;

  void toggleNotifications(bool value) {
    isNotificationsEnabled.value = value;
  }

  Future<void> logout() async {
    // Calling the centralized logout logic that clears prefs and revokes token on server
    await _authService.logout();
  }
}
