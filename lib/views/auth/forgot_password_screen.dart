import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final ForgotPasswordController controller = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // دعم الواجهة العربية
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA), // الخلفية الرمادية الفاتحة
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF1A2A44)),
            onPressed: () => Get.back(), // سهم العودة
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                // أيقونة تعبيرية
                const Icon(
                  Icons.lock_reset_rounded,
                  size: 100,
                  color: Color(0xFF1A2A44), // الكحلي الداكن
                ),
                const SizedBox(height: 32),

                // العنوان
                const Text(
                  'نسيت كلمة المرور',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A2A44),
                  ),
                ),
                const SizedBox(height: 12),

                // الوصف
                const Text(
                  'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة التعيين',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 48),

                // حقل البريد الإلكتروني
                TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontFamily: 'Tajawal'),
                  decoration: InputDecoration(
                    hintText: 'البريد الإلكتروني',
                    hintStyle: const TextStyle(fontFamily: 'Tajawal', color: Colors.grey),
                    hintTextDirection: TextDirection.rtl,
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade500),
                    filled: true,
                    fillColor: Colors.white, // أبيض ليتماشى مع البطاقات
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
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
                      borderSide: const BorderSide(color: Color(0xFF1A2A44), width: 1.5),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // زر إرسال الرابط
                Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF58A1E), // البرتقالي الحيوي
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // زوايا 12px
                    ),
                  ),
                  onPressed: controller.isLoading.value ? null : controller.sendResetLink,
                  child: controller.isLoading.value
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                      : const Text(
                    'إرسال رابط',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}