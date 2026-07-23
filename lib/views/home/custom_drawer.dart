import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/login_screen.dart';
import 'profile_screen.dart'; // استيراد شاشة البروفايل
import '../tracking/project_tracking_screen.dart'; // استيراد شاشة متابعة المشروع
import 'favorites_screen.dart';
import 'ratings_screen.dart';
import 'complaints_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0D1B2A), // الكحلي الداكن جداً
      child: SafeArea(
        child: Column(
          children: [
            // قسم بيانات المستخدم (البروفايل)
            InkWell(
              onTap: () {
                Get.back(); // إغلاق القائمة
                Get.to(() => ProfileScreen()); // الانتقال للبروفايل
              },
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFF58A1E), width: 2),
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 35),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'محمد العتيبي',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'mohammed@example.com',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Divider(color: Colors.white.withOpacity(0.1), thickness: 1),
            const SizedBox(height: 8),

            // --- عناصر القائمة ---

            // 1. زر متابعة المشروع (تم الربط هنا)
            _buildDrawerItem(
              icon: Icons.assignment_outlined,
              title: 'متابعة المشروع',
              onTap: () {
                Get.back(); // إغلاق القائمة الجانبية أولاً
                Get.to(() => ProjectTrackingScreen()); // الانتقال لشاشة المتابعة
              },
            ),

            _buildDrawerItem(
              icon: Icons.favorite_border_rounded,
              title: 'المفضلة',
              onTap: () {
                Get.back(); // إغلاق القائمة الجانبية أولاً
                Get.to(() => FavoritesScreen()); // الانتقال لشاشة المفضلة
              },
            ),

            _buildDrawerItem(
              icon: Icons.star_border_rounded,
              title: 'التقييمات',
              onTap: () {
                Get.back(); // إغلاق القائمة الجانبية أولاً
                Get.to(() => RatingsScreen()); // الانتقال لشاشة التقييمات
              },
            ),

            _buildDrawerItem(
              icon: Icons.headset_mic_outlined,
              title: 'الشكاوي',
              onTap: () {
                Get.back(); // إغلاق القائمة الجانبية
                Get.to(() => ComplaintsScreen()); // الانتقال لسجل الشكاوي
              },
            ),

            const Spacer(),

            Divider(color: Colors.white.withOpacity(0.1), thickness: 1),

            // زر تسجيل الخروج
            _buildDrawerItem(
              icon: Icons.logout_rounded,
              title: 'تسجيل الخروج',
              color: Colors.redAccent,
              onTap: () {
                Get.offAll(() => LoginScreen()); // العودة لتسجيل الدخول
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ويدجت مساعد لبناء عناصر القائمة
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 26),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Tajawal',
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
    );
  }
}