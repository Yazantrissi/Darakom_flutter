import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/reset_password_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final ResetPasswordController controller = Get.put(ResetPasswordController());

  // الألوان الثابتة للهوية البصرية
  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);
  final Color bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // دعم الواجهة العربية RTL
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: navyColor,
          elevation: 0,
          title: const Text(
            'تغيير كلمة السر',
            style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
            onPressed: () => Get.back(), // العودة للخلف لشاشة الإعدادات
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),

                // البطاقة البيضاء التي تحتوي على الحقول القابلة للتعديل
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // حقل كلمة السر الحالية
                      Obx(() => _buildPasswordField(
                        controller: controller.currentPasswordController,
                        label: 'كلمة السر الحالية',
                        hint: 'أدخل كلمة السر الحالية',
                        isObscured: controller.isCurrentPasswordHidden.value,
                        onToggleVisibility: controller.toggleCurrentPasswordVisibility,
                      )),
                      const SizedBox(height: 20),

                      // حقل كلمة السر الجديدة
                      Obx(() => _buildPasswordField(
                        controller: controller.newPasswordController,
                        label: 'كلمة السر الجديدة',
                        hint: 'أدخل كلمة السر الجديدة',
                        isObscured: controller.isNewPasswordHidden.value,
                        onToggleVisibility: controller.toggleNewPasswordVisibility,
                      )),
                      const SizedBox(height: 20),

                      // حقل تأكيد كلمة السر الجديدة
                      Obx(() => _buildPasswordField(
                        controller: controller.confirmPasswordController,
                        label: 'تأكيد كلمة السر الجديدة',
                        hint: 'أعد كتابة كلمة السر الجديدة',
                        isObscured: controller.isConfirmPasswordHidden.value,
                        onToggleVisibility: controller.toggleConfirmPasswordVisibility,
                      )),
                      const SizedBox(height: 32),

                      // زر حفظ التغييرات البرتقالي
                      Obx(() => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: orangeColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onPressed: controller.isLoading.value ? null : controller.updatePassword,
                        child: controller.isLoading.value
                            ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                            : const Text(
                          'تحديث كلمة السر',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ويدجت مساعد لبناء حقول كلمات المرور المتطابقة مع الهوية
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isObscured,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajawal',
            color: Colors.grey.shade600,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isObscured,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.right,
          style: TextStyle(fontFamily: 'Tajawal', fontSize: 15, color: navyColor, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontFamily: 'Tajawal', color: Colors.grey, fontSize: 13),
            hintTextDirection: TextDirection.rtl,
            prefixIcon: Icon(Icons.lock_outline_rounded, color: Colors.grey.shade500, size: 22),
            suffixIcon: IconButton(
              icon: Icon(
                isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: orangeColor,
                size: 20,
              ),
              onPressed: onToggleVisibility,
            ),
            filled: true,
            fillColor: const Color(0xFFF9FAFC),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: navyColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}