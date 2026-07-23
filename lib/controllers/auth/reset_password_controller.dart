import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  // أدوات التحكم بالنصوص
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // متغيرات حالة الرؤية لكل حقل بشكل مستقل
  var isCurrentPasswordHidden = true.obs;
  var isNewPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  var isLoading = false.obs;

  void toggleCurrentPasswordVisibility() => isCurrentPasswordHidden.value = !isCurrentPasswordHidden.value;
  void toggleNewPasswordVisibility() => isNewPasswordHidden.value = !isNewPasswordHidden.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  // دالة تحديث كلمة السر وإرسالها للسيرفر
  Future<void> updatePassword() async {
    // التحقق من تطابق كلمة السر الجديدة والتأكيد
    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'خطأ',
        'كلمة السر الجديدة وتأكيدها غير متطابقين',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    // محاكاة الاتصال بالـ API
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    Get.snackbar(
      'تم بنجاح',
      'تم تغيير كلمة السر بنجاح.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );

    Get.back(); // العودة لشاشة الإعدادات بعد النجاح
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}