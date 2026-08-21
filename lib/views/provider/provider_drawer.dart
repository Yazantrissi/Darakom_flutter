import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/provider/provider_dashboard_controller.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

// استيراد شاشات التقييمات والشكاوي (نفس الشاشات المستخدمة للعميل)
import '../home/ratings_screen.dart';
import '../home/complaints_screen.dart';

class ProviderDrawer extends StatelessWidget {
  const ProviderDrawer({super.key});

  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);

  @override
  Widget build(BuildContext context) {
    // استدعاء المتحكم لتغيير التبويبات عند الضغط على عناصر القائمة الأساسية
    final ProviderDashboardController controller = Get.find<ProviderDashboardController>();
    final AuthService authService = Get.find<AuthService>();

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. رأس القائمة الجانبية (Header) المنحني
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 24, left: 24, right: 24),
            decoration: BoxDecoration(
              color: navyColor,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32)),
            ),
            child: Obx(() => Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.engineering_rounded, size: 40, color: navyColor),
                ),
                const SizedBox(height: 16),
                Text(
                  controller.fullUserName.value,
                  style: const TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.userEmail.value,
                  style: const TextStyle(fontFamily: 'Tajawal', color: Colors.white70, fontSize: 14),
                ),
              ],
            )),
          ),
          const SizedBox(height: 16),

          // 2. عناصر القائمة
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.home_outlined,
                  title: 'الرئيسية',
                  onTap: () {
                    Get.back(); // إغلاق القائمة أولاً
                    controller.changePage(0); // الانتقال للتبويب
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.search_rounded,
                  title: 'سوق المناقصات',
                  onTap: () {
                    Get.back();
                    controller.changePage(1);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.layers_outlined,
                  title: 'العروض',
                  onTap: () {
                    Get.back();
                    controller.changePage(2);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.handyman_outlined,
                  title: 'مشاريعي',
                  onTap: () {
                    Get.back();
                    controller.changePage(3);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.person_outline,
                  title: 'حسابي',
                  onTap: () {
                    Get.back();
                    controller.changePage(4);
                  },
                ),

                const Divider(height: 32), // فاصل للمرتبة الثانية من الإعدادات

                // --- الأزرار الجديدة (التقييمات والشكاوي) ---
                _buildDrawerItem(
                  icon: Icons.star_border_rounded,
                  title: 'التقييمات',
                  onTap: () {
                    Get.back();
                    Get.to(() => RatingsScreen()); // الانتقال لشاشة التقييمات
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.headset_mic_outlined,
                  title: 'الشكاوي',
                  onTap: () {
                    Get.back();
                    Get.to(() => ComplaintsScreen()); // الانتقال لشاشة الشكاوي
                  },
                ),

                const Divider(height: 32), // فاصل قبل تسجيل الخروج

                _buildDrawerItem(
                  icon: Icons.logout_rounded,
                  title: 'تسجيل الخروج',
                  iconColor: Colors.redAccent,
                  textColor: Colors.redAccent,
                  onTap: () async {
                    Get.back();
                    final success = await authService.logout();
                    if (!success) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                    }
                    Get.offAll(() => LoginScreen());
                    Get.snackbar('تسجيل الخروج', 'تم تسجيل الخروج بنجاح', backgroundColor: Colors.black87, colorText: Colors.white);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لبناء أزرار القائمة الجانبية
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? navyColor, size: 24),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: textColor ?? navyColor,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
    );
  }
}
