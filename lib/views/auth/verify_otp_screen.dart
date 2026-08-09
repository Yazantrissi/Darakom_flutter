import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/verify_otp_controller.dart';

class VerifyOtpScreen extends StatelessWidget {
  final String email;
  VerifyOtpScreen({super.key, required this.email});

  final VerifyOtpController controller = Get.put(VerifyOtpController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF1A2A44)),
            onPressed: () => Get.back(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.verified_user_rounded, size: 100, color: Color(0xFF1A2A44)),
                const SizedBox(height: 32),
                const Text(
                  'تفعيل كلمة المرور',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A2A44)),
                ),
                const SizedBox(height: 12),
                Text(
                  'تم إرسال رمز التحقق إلى $email. يرجى إدخال الرمز وكلمة المرور الجديدة.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'Tajawal', fontSize: 16, color: Colors.black54, height: 1.5),
                ),
                const SizedBox(height: 48),
                
                // OTP Field
                TextFormField(
                  controller: controller.otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'Tajawal', fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 8),
                  decoration: _buildInputDecoration(hint: 'رمز التحقق (6 أرقام)', icon: Icons.pin_rounded),
                ),
                const SizedBox(height: 20),

                // New Password
                Obx(() => TextFormField(
                  controller: controller.passwordController,
                  obscureText: controller.isPasswordHidden.value,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
                  decoration: _buildInputDecoration(hint: 'كلمة المرور الجديدة', icon: Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(controller.isPasswordHidden.value ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                )),
                const SizedBox(height: 20),

                // Confirm Password
                Obx(() => TextFormField(
                  controller: controller.confirmPasswordController,
                  obscureText: controller.isConfirmPasswordHidden.value,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
                  decoration: _buildInputDecoration(hint: 'تأكيد كلمة المرور', icon: Icons.lock_reset_outlined).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(controller.isConfirmPasswordHidden.value ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                  ),
                )),
                const SizedBox(height: 32),

                // Submit Button
                Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF58A1E),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  ),
                  onPressed: controller.isLoading.value ? null : () => controller.resetPassword(email),
                  child: controller.isLoading.value
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                      : const Text('إعادة تعيين كلمة المرور', style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontFamily: 'Tajawal', color: Colors.grey, fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.grey.shade500),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: Color(0xFF1A2A44), width: 1.5)),
    );
  }
}
