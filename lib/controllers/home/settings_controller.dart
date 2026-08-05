import 'package:get/get.dart';

class SettingsController extends GetxController {
  // متغير تفاعلي لحالة الإشعارات (مفعلة افتراضياً)
  var isNotificationsEnabled = true.obs;

  void toggleNotifications(bool value) {
    isNotificationsEnabled.value = value;
  }
}