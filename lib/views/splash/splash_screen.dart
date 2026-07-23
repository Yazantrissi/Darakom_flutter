import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/splash/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  // حقن المتحكم ليبدأ المؤقت بمجرد فتح الشاشة
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2A44), // الخلفية الكحلية الداكنة
      body: SafeArea(
        child: Stack(
          children: [
            // محتوى المنتصف (الشعار والاسم)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // الشعار الحقيقي للتطبيق المضاف من المرفقات
                  Image.asset(
                    'assets/images/logo.png',
                    height: 140, // حجم مناسب ليتناسق مع الواجهة
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),

                  // اسم المنصة
                  const Text(
                    'داركم',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF58A1E), // البرتقالي الحيوي
                    ),
                  ),
                  const SizedBox(height: 8),

                  // الشعار اللفظي (Slogan) - اختياري
                  Text(
                    'خطتك الذكية لبيت أحلامك',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // شريط التحميل في الأسفل
            Positioned(
              bottom: 60,
              left: 48,
              right: 48,
              child: Column(
                children: [
                  // شريط التحميل (Loading Bar)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0), // حواف دائرية متناسقة
                    child: const LinearProgressIndicator(
                      backgroundColor: Color(0xFF2A3A54), // كحلي أفتح قليلاً للخلفية
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF58A1E)), // لون الشريط برتقالي
                      minHeight: 6, // سماكة الشريط
                    ),
                  ),
                  const SizedBox(height: 16),

                  // نص توضيحي للتحميل
                  Text(
                    'جاري التحميل...',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}