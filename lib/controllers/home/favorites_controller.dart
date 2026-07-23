import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  // قائمة وهمية لمزودي الخدمة المفضلين
  final List<Map<String, dynamic>> favoriteProviders = [
    {
      'id': 1,
      'name': 'مؤسسة البناء الحديث',
      'specialty': 'مقاولات عامة',
      'rating': 4.9,
      'completedProjects': 120,
    },
    {
      'id': 2,
      'name': 'مكتب الأفق الهندسي',
      'specialty': 'تصميم وإشراف هندسي',
      'rating': 4.8,
      'completedProjects': 85,
    },
    {
      'id': 3,
      'name': 'م. خالد الشمري',
      'specialty': 'تصميم داخلي',
      'rating': 4.7,
      'completedProjects': 42,
    },
  ];

  // دالة زر تقديم عرض مباشر
  void sendDirectOffer(String providerName) {
    Get.snackbar(
      'تقديم عرض',
      'جاري الانتقال لتقديم عرض مباشر لـ "$providerName"...',
      backgroundColor: const Color(0xFFF58A1E),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
    // مستقبلاً: Get.to(() => SendOfferScreen(providerName: providerName));
  }

  // دالة زر عرض الملف الشخصي
  void viewProfile(String providerName) {
    Get.snackbar(
      'الملف الشخصي',
      'جاري فتح الملف الشخصي لـ "$providerName"...',
      backgroundColor: const Color(0xFF1A2A44),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
    // مستقبلاً: Get.to(() => ProviderProfileScreen(providerName: providerName));
  }
}