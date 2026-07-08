import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart'; // تأكد من استيراد شاشة استعادة كلمة المرور

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // استدعاء المتحكم الخاص بإدارة الحالة
  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // دعم كامل للغة العربية
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA), // لون الخلفية الرمادي الفاتح
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // الشعار (App Logo)
                  const Icon(
                    Icons.foundation_rounded, // يمكنك لاحقاً استبدالها بصورة الشعار الحقيقي
                    size: 90,
                    color: Color(0xFF1A2A44), // الكحلي الداكن
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'داركم',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A2A44),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // البطاقة البيضاء (Card-based Layout)
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0), // زوايا دائرية 12px
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04), // ظلال ناعمة
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // حقل البريد الإلكتروني / اسم المستخدم
                        TextFormField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontFamily: 'Tajawal'),
                          decoration: _buildInputDecoration(
                            hint: 'البريد الإلكتروني أو اسم المستخدم',
                            icon: Icons.email_outlined,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // حقل كلمة المرور مع زر الإظهار/الإخفاء
                        Obx(() => TextFormField(
                          controller: controller.passwordController,
                          obscureText: controller.isPasswordHidden.value,
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontFamily: 'Tajawal'),
                          decoration: _buildInputDecoration(
                            hint: 'كلمة المرور',
                            icon: Icons.lock_outline,
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordHidden.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey.shade600,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                        )),

                        const SizedBox(height: 8),

                        // رابط نسيت كلمة المرور (محاذاة لليمين، لون برتقالي)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // الانتقال إلى شاشة استعادة كلمة المرور
                              Get.to(() => ForgotPasswordScreen());
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'نسيت كلمة المرور؟',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                color: Color(0xFFF58A1E), // البرتقالي الحيوي
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // زر تسجيل الدخول (عرض كامل الشاشة للبطاقة)
                        Obx(() => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF58A1E), // لون برتقالي
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0), // زوايا 12px
                            ),
                          ),
                          onPressed: controller.isLoading.value ? null : controller.login,
                          child: controller.isLoading.value
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                              : const Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )),

                        const SizedBox(height: 24),

                        // فاصل الدخول عبر الشبكات الاجتماعية
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'أو الدخول بواسطة',
                                style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade500, fontSize: 14),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // أيقونات تسجيل الدخول (Google / Apple)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton(icon: Icons.g_mobiledata_rounded, color: Colors.red),
                            const SizedBox(width: 20),
                            _buildSocialButton(icon: Icons.apple_rounded, color: Colors.black),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // رابط إنشاء حساب جديد
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'ليس لديك حساب؟',
                        style: TextStyle(fontFamily: 'Tajawal', color: Colors.black54, fontSize: 15),
                      ),
                      TextButton(
                        onPressed: () {
                          // الانتقال إلى شاشة إنشاء الحساب
                          Get.to(() => RegisterScreen());
                        },
                        child: const Text(
                          'انشاء حساب جديد',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: Color(0xFF1A2A44), // الكحلي
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لتصميم حقول الإدخال
  InputDecoration _buildInputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontFamily: 'Tajawal', color: Colors.grey, fontSize: 14),
      hintTextDirection: TextDirection.rtl,
      prefixIcon: Icon(icon, color: Colors.grey.shade500),
      filled: true,
      fillColor: const Color(0xFFF9FAFC), // خلفية الحقل أفتح بقليل من خلفية الشاشة
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
        borderSide: const BorderSide(color: Color(0xFF1A2A44), width: 1.5), // كحلي عند التحديد
      ),
    );
  }

  // دالة مساعدة لبناء أزرار السوشيال ميديا
  Widget _buildSocialButton({required IconData icon, required Color color}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: IconButton(
        icon: Icon(icon, size: 32, color: color),
        onPressed: () {
          // إجراء تسجيل الدخول الاجتماعي
        },
      ),
    );
  }
}