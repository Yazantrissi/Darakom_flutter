import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();

  var isLoading = false.obs;

  Future<void> sendResetLink() async {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'يرجى إدخال البريد الإلكتروني',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    // محاكاة إرسال الطلب للخادم (API Call)
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    // إظهار رسالة نجاح
    Get.snackbar(
      'تم الإرسال',
      'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني بنجاح.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );

    // اختياري: العودة لشاشة تسجيل الدخول بعد ثانيتين من النجاح
    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}