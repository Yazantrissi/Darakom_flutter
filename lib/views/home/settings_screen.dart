import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/settings_controller.dart';

// استيراد شاشات البروفايل للعميل ولمزود الخدمة[cite: 20]
import 'profile_screen.dart';
import '../provider/provider_profile_screen.dart';

// استيراد باقي الشاشات[cite: 20]
import '../auth/reset_password_screen.dart'; // استخدمنا شاشة تغيير كلمة المرور هنا بدلاً من إعادة التعيين
import 'about_us_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';

class SettingsScreen extends StatelessWidget {
  // متغير لتحديد نوع المستخدم (القيمة الافتراضية false تعني عميل)[cite: 20]
  final bool isProvider;

  // Constructor بدون كلمة const لأننا نستخدم Get.put بداخله[cite: 20]
  SettingsScreen({super.key, this.isProvider = false});

  final SettingsController controller = Get.put(SettingsController());

  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);
  final Color bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: navyColor,
          elevation: 0,
          title: const Text('الإعدادات', style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            // 1. زر الملف الشخصي (متغير حسب نوع الحساب)[cite: 20]
            _buildSettingsItem(
              icon: Icons.person_outline,
              title: 'الملف الشخصي',
              onTap: () {
                // الشرط الذي يحدد الشاشة بناءً على نوع المستخدم[cite: 20]
                if (isProvider) {
                  Get.to(() => ProviderProfileScreen()); // شاشة مزود الخدمة[cite: 20]
                } else {
                  Get.to(() => ProfileScreen()); // شاشة العميل[cite: 20]
                }
              },
            ),

            // 2. تغيير كلمة المرور[cite: 20]
            _buildSettingsItem(
                icon: Icons.lock_outline,
                title: 'تغيير كلمة المرور',
                onTap: () => Get.to(() => ResetPasswordScreen())
              // ملاحظة: إذا كان اسم ملفك reset_password_screen.dart، قم بتغييرها هنا إلى ResetPasswordScreen()
            ),

            // 3. الإشعارات (مع زر Switch تفاعلي)[cite: 20]
            _buildSwitchItem(
              icon: Icons.notifications_active_outlined,
              title: 'الإشعارات',
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // 4. من نحن[cite: 20]
            _buildSettingsItem(
                icon: Icons.info_outline_rounded,
                title: 'من نحن',
                onTap: () => Get.to(() => const AboutUsScreen())
            ),

            // 5. سياسة الخصوصية[cite: 20]
            _buildSettingsItem(
                icon: Icons.privacy_tip_outlined,
                title: 'سياسة الخصوصية',
                onTap: () => Get.to(() => const PrivacyPolicyScreen())
            ),

            // 6. الشروط والأحكام[cite: 20]
            _buildSettingsItem(
                icon: Icons.gavel_rounded,
                title: 'الشروط والأحكام',
                onTap: () => Get.to(() => const TermsConditionsScreen())
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // 7. تسجيل الخروج[cite: 20]
            _buildSettingsItem(
              icon: Icons.logout_rounded,
              title: 'تسجيل الخروج',
              iconColor: Colors.redAccent,
              textColor: Colors.redAccent,
              hideArrow: true,
              onTap: () => _showLogoutDialog(context),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج', textAlign: TextAlign.right),
        content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟', textAlign: TextAlign.right),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // دالة بناء العنصر العادي مع سهم الانتقال[cite: 20]
  Widget _buildSettingsItem({required IconData icon, required String title, required VoidCallback onTap, Color? iconColor, Color? textColor, bool hideArrow = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: (iconColor ?? navyColor).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: iconColor ?? navyColor, size: 20),
        ),
        title: Text(title, style: TextStyle(fontFamily: 'Tajawal', fontSize: 15, fontWeight: FontWeight.bold, color: textColor ?? navyColor)),
        trailing: hideArrow ? null : Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade400),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  // دالة بناء عنصر الإشعارات (Switch)[cite: 20]
  Widget _buildSwitchItem({required IconData icon, required String title}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: navyColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: navyColor, size: 20),
        ),
        title: Text(title, style: TextStyle(fontFamily: 'Tajawal', fontSize: 15, fontWeight: FontWeight.bold, color: navyColor)),
        trailing: Obx(() => Switch(
          value: controller.isNotificationsEnabled.value,
          onChanged: controller.toggleNotifications,
          activeColor: orangeColor,
        )),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}