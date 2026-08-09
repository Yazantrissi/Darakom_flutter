import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';

class ResetPasswordController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

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
    if (currentPasswordController.text.isEmpty || newPasswordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى ملء جميع الحقول', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

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
    final success = await _authService.changePassword(
      currentPasswordController.text,
      newPasswordController.text,
      confirmPasswordController.text,
    );
    isLoading.value = false;

    if (success) {
      Get.back(); // العودة لشاشة الإعدادات بعد النجاح
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
