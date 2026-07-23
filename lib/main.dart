import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/splash/splash_screen.dart'; // تأكد من مطابقة المسار لمكان حفظ الشاشة
import 'views/home/client_dashboard_screen.dart';

void main() {
  // التأكد من تهيئة كل خدمات فلاتر بشكل صحيح قبل تشغيل التطبيق
  WidgetsFlutterBinding.ensureInitialized();

  // يمكنك هنا لاحقاً تهيئة Shared Preferences و Dio

  runApp(const DarakomApp());
}

class DarakomApp extends StatelessWidget {
  const DarakomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'داركم',
      debugShowCheckedModeBanner: false,

      // فرض اللغة العربية واتجاه الشاشة (RTL) على مستوى التطبيق بالكامل
      locale: const Locale('ar'),
      fallbackLocale: const Locale('ar'),

      // إعدادات التنسيق البصري الموحد (Theme)
      theme: ThemeData(
        fontFamily: 'Tajawal', // تطبيق خط تجول على جميع النصوص افتراضياً
        scaffoldBackgroundColor: const Color(0xFFF5F7FA), // الخلفية الرمادية الفاتحة
        primaryColor: const Color(0xFF1A2A44), // الكحلي الداكن

        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF1A2A44),
          secondary: const Color(0xFFF58A1E), // البرتقالي الحيوي
        ),

        // توحيد تصميم شريط التطبيق العلوي (AppBar)
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // شفاف ليتماشى مع التصميم العصري
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF1A2A44)),
          titleTextStyle: TextStyle(
            fontFamily: 'Tajawal',
            color: Color(0xFF1A2A44),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // توحيد تصميم الأزرار المرتفعة (ElevatedButton) في كافة الشاشات
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF58A1E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // زوايا دائرية 12px
            ),
            textStyle: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      // تعيين شاشة البداية لتكون أول ما يظهر عند فتح التطبيق
      //home: ClientDashboardScreen(),
      home: SplashScreen(),
    );
  }
}