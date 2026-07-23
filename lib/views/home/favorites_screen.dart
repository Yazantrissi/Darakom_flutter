import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/favorites_controller.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});

  final FavoritesController controller = Get.put(FavoritesController());

  // ألوان الهوية البصرية
  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);
  final Color bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // دعم الواجهة العربية
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            // 1. الهيدر الكحلي المنحني (يتناسب مع باقي الشاشات)
            _buildCustomHeader(),

            // 2. قائمة المزودين المفضلين
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(24.0),
                itemCount: controller.favoriteProviders.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final provider = controller.favoriteProviders[index];
                  return _buildProviderCard(provider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- دوال بناء الواجهة --- //

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
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
              onPressed: () => Get.back(), // العودة للخلف (للقائمة الجانبية أو الرئيسية)
            ),
          ),
          const Text(
            'المفضلة',
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 48), // لموازنة التوسيط
        ],
      ),
    );
  }

  Widget _buildProviderCard(Map<String, dynamic> provider) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // القسم العلوي: الاسم والتقييم
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة المزود (أيقونة افتراضية)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: orangeColor.withOpacity(0.5)),
                ),
                child: Icon(Icons.engineering_rounded, color: navyColor, size: 28),
              ),
              const SizedBox(width: 16),

              // بيانات المزود
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider['name'],
                      style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: navyColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider['specialty'],
                      style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),

              // التقييم النجمي
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text('${provider['rating']}', style: TextStyle(fontFamily: 'Tajawal', color: navyColor, fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(width: 4),
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade100, height: 1),
          const SizedBox(height: 16),

          // رقم المشاريع المنتهية
          Row(
            children: [
              Icon(Icons.check_circle_outline_rounded, size: 18, color: Colors.green.shade600),
              const SizedBox(width: 8),
              Text(
                'المشاريع المنتهية بنجاح: ',
                style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, color: Colors.grey.shade600),
              ),
              Text(
                '${provider['completedProjects']} مشروع',
                style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green.shade700),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // الأزرار: تقديم عرض وعرض الملف
          Row(
            children: [
              // زر تقديم عرض مباشر (برتقالي)
              Expanded(
                flex: 3, // أخذ مساحة أكبر قليلاً
                child: ElevatedButton.icon(
                  onPressed: () => controller.sendDirectOffer(provider['name']),
                  icon: const Icon(Icons.send_rounded, size: 16, color: Colors.white),
                  label: const Text('تقديم عرض مباشر', style: TextStyle(fontFamily: 'Tajawal', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // زر عرض الملف الشخصي (مفرغ كحلي)
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: () => controller.viewProfile(provider['name']),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: navyColor, width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('عرض الملف', style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, fontWeight: FontWeight.bold, color: navyColor)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}