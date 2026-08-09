import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';
import '../../views/auth/login_screen.dart';

class VerifyOtpController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  Future<void> resetPassword(String email) async {
    if (otpController.text.isEmpty || passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى ملء جميع الحقول', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('تنبيه', 'كلمات المرور غير متطابقة', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    final success = await _authService.resetPassword(
      email,
      otpController.text,
      passwordController.text,
      confirmPasswordController.text,
    );
    isLoading.value = false;

    if (success) {
      Get.offAll(() => LoginScreen());
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
