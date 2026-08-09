import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';
import '../../views/auth/verify_otp_screen.dart';

class ForgotPasswordController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
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
    final success = await _authService.forgotPassword(emailController.text);
    isLoading.value = false;

    if (success) {
      Get.to(() => VerifyOtpScreen(email: emailController.text));
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
