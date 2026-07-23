import 'package:get/get.dart';
import '../../views/onboarding/onboarding_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startLoading();
  }

  void _startLoading() async {
    // محاكاة وقت التحميل لمدة 3 ثوانٍ
    // (مستقبلاً يمكنك إضافة كود هنا للتحقق مما إذا كان المستخدم قد سجل دخوله مسبقاً لينتقل للرئيسية مباشرة)
    await Future.delayed(const Duration(seconds: 3));

    // الانتقال إلى شاشة الترحيب وإغلاق شاشة البداية نهائياً من الذاكرة
    Get.offAll(() => OnboardingScreen());
  }
}