import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var isLoading = false.obs;

  // متغيرات تتبع شروط كلمة المرور
  var hasMinLength = false.obs;
  var hasUppercase = false.obs;
  var hasNumber = false.obs;

  @override
  void onInit() {
    super.onInit();
    // مراقبة ما يكتبه المستخدم لتحديث الشروط فوراً
    passwordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    String text = passwordController.text;
    hasMinLength.value = text.length >= 8;
    hasUppercase.value = text.contains(RegExp(r'[A-Z]'));
    hasNumber.value = text.contains(RegExp(r'[0-9]'));
  }

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  Future<void> savePassword() async {
    // التحقق من تلبية جميع الشروط
    if (!hasMinLength.value || !hasUppercase.value || !hasNumber.value) {
      Get.snackbar('تنبيه', 'يرجى استيفاء جميع شروط كلمة المرور', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('خطأ', 'كلمات المرور غير متطابقة', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    // محاكاة إرسال الطلب للخادم
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    Get.snackbar('نجاح', 'تم تعديل كلمة المرور بنجاح', backgroundColor: Colors.green, colorText: Colors.white);

    // العودة لشاشة تسجيل الدخول بعد النجاح
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed('/login'); // افترض أن لديك مسار (Route) مسمى لشاشة الدخول
    });
  }

  @override
  void onClose() {
    passwordController.removeListener(_validatePassword);
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}