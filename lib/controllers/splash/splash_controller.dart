import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../views/onboarding/onboarding_screen.dart';
import '../../views/home/client_dashboard_screen.dart';
import '../../views/provider/provider_dashboard_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startLoading();
  }

  void _startLoading() async {
    // محاكاة وقت التحميل لمدة 3 ثوانٍ
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userType = prefs.getString('user_type');

    if (token != null && token.isNotEmpty) {
      if (userType == 'provider') {
        Get.offAll(() => ProviderDashboardScreen());
      } else {
        Get.offAll(() => ClientDashboardScreen());
      }
    } else {
      // الانتقال إلى شاشة الترحيب وإغلاق شاشة البداية نهائياً من الذاكرة
      Get.offAll(() => OnboardingScreen());
    }
  }
}
