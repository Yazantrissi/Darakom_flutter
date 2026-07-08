import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // أدوات التحكم بالنصوص
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // متغيرات تفاعلية باستخدام .obs
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  // دالة لتغيير حالة إظهار/إخفاء كلمة المرور
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // دالة تسجيل الدخول
  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'يرجى تعبئة جميع الحقول',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    // محاكاة الاتصال بالخادم (سيتم ربطها بـ API لاحقاً)
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;
    print("تم تسجيل الدخول بنجاح: ${emailController.text}");
    // Get.offAll(() => const HomeScreen()); // الانتقال للصفحة الرئيسية لاحقاً
  }

  @override
  void onClose() {
    // تنظيف الموارد عند إغلاق الشاشة
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}