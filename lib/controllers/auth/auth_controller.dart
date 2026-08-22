import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import '../../views/auth/login_screen.dart';
import '../../views/home/client_dashboard_screen.dart';
import '../../views/provider/provider_dashboard_screen.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // حقول الإدخال
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى ملء جميع الحقول',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    final user = await _authService.login(emailController.text, passwordController.text);
    isLoading.value = false;

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      if (user.token != null) {
        await prefs.setString('token', user.token!);
      }
      await prefs.setString('user_type', user.type);

      if (user.type == 'provider') {
        Get.offAll(() => ProviderDashboardScreen());
      } else {
        Get.offAll(() => ClientDashboardScreen());
      }
    }
    // AuthService already shows Arabic API/422 errors via snackbar
  }

  Future<void> logout() async {
    isLoading.value = true;
    final success = await _authService.logout();
    isLoading.value = false;
    
    if (success) {
      Get.offAll(() => LoginScreen());
    } else {
      // Even if server fails, clear local and go to login
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Get.offAll(() => LoginScreen());
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
