import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/settings_controller.dart';
import '../../controllers/home/client_dashboard_controller.dart'; // استيراد متحكم لوحة التحكم للعودة للرئيسية

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final SettingsController controller = Get.put(SettingsController());

  // الألوان الأساسية
  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);
  final Color bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // الواجهة من اليمين لليسار
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            // 1. الهيدر الكحلي المنحني
            _buildCustomHeader(),

            // 2. المحتوى (القابل للتمرير)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // بطاقة الملف الشخصي
                    _buildProfileCard(),
                    const SizedBox(height: 24),

                    // قائمة الإعدادات (البطاقة البيضاء الكبيرة)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSettingsItem(
                            title: 'تغيير كلمة السر',
                            icon: Icons.shield_outlined,
                            iconColor: const Color(0xFF7B61FF),
                            onTap: controller.goToChangePassword,
                          ),
                          _buildDivider(),
                          _buildSettingsToggleItem(
                            title: 'Push Notification',
                            icon: Icons.notifications_none_rounded,
                            iconColor: orangeColor,
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            title: 'About Us',
                            icon: Icons.description_outlined,
                            iconColor: Colors.grey.shade600,
                            textColor: navyColor,
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            title: 'Privacy Policy',
                            icon: Icons.privacy_tip_outlined,
                            iconColor: Colors.grey.shade600,
                            textColor: navyColor,
                            onTap: () {},
                          ),
                          _buildDivider(),
                          _buildSettingsItem(
                            title: 'Terms and Conditions',
                            icon: Icons.article_outlined,
                            iconColor: Colors.grey.shade600,
                            textColor: navyColor,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // بطاقة تسجيل الخروج
                    _buildLogoutCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- دوال بناء عناصر الواجهة --- //

  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 24, left: 24, right: 24),
      decoration: BoxDecoration(
        color: navyColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
          bottomRight: Radius.circular(32.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // زر العودة المعدل (ينتقل للتبويب 0 في الشريط السفلي)
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
              onPressed: () => Get.find<ClientDashboardController>().changePage(0),
            ),
          ),

          const Text(
            'الإعدادات',
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 48), // مساحة فارغة لمعادلة التوسيط
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return GestureDetector(
      onTap: controller.goToProfile,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: orangeColor, width: 1.5),
                  ),
                  child: const Icon(Icons.person_outline_rounded, color: Colors.black54, size: 30),
                ),
                Positioned(
                  bottom: -4,
                  left: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: orangeColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.edit_rounded, color: Colors.white, size: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'محمد العتيبي',
                    style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: navyColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'تعديل الملف الشخصي',
                    style: TextStyle(fontFamily: 'Tajawal', fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_back_ios_rounded, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({required String title, required IconData icon, required Color iconColor, Color? textColor, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10.0)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: TextStyle(fontFamily: 'Tajawal', fontSize: 15, fontWeight: FontWeight.w600, color: textColor ?? iconColor)),
            ),
            Icon(Icons.arrow_back_ios_rounded, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsToggleItem({required String title, required IconData icon, required Color iconColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10.0)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: TextStyle(fontFamily: 'Tajawal', fontSize: 15, fontWeight: FontWeight.w600, color: iconColor)),
          ),
          Obx(() => Switch(
            value: controller.isPushNotificationEnabled.value,
            onChanged: controller.togglePushNotification,
            activeColor: Colors.white,
            activeTrackColor: orangeColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
          )),
        ],
      ),
    );
  }

  Widget _buildLogoutCard() {
    return GestureDetector(
      onTap: controller.logout,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(10.0)),
              child: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text('تسجيل الخروج', style: TextStyle(fontFamily: 'Tajawal', fontSize: 15, fontWeight: FontWeight.bold, color: Colors.redAccent)),
            ),
            const Icon(Icons.arrow_back_ios_rounded, color: Colors.redAccent, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey.shade200, height: 1, thickness: 1, indent: 16, endIndent: 16);
  }
}