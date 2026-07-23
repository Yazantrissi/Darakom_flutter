import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../views/auth/login_screen.dart';

class OnboardingController extends GetxController {
  // للتحكم في التمرير بين الشاشات
  final PageController pageController = PageController();

  // تتبع الصفحة الحالية لتحديث مؤشر النقاط (Dot Indicator)
  var currentPage = 0.obs;

  // بيانات الشاشات الثلاث
  final List<Map<String, dynamic>> pages = [
    {
      'title': 'أسهل طريقة لإدارة مشاريعك',
      'subtitle': 'ابحث عن أفضل مزودي الخدمة في مكان واحد',
      'icon': Icons.architecture_rounded, // أيقونة مؤقتة لحين توفر الرسومات التوضيحية
    },
    {
      'title': 'اختر مزود الخدمة المناسب',
      'subtitle': 'مكاتب هندسية، مهندسين، مقاولين، وحرفيين',
      'icon': Icons.engineering_rounded,
    },
    {
      'title': 'تابع مشاريعك خطوة بخطوة',
      'subtitle': 'نسبة إنجاز، مراحل، وتواصل مباشر',
      'icon': Icons.track_changes_rounded,
    },
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    Get.offAll(() => LoginScreen());
  }

  void startNow() {
    Get.offAll(() => LoginScreen());
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}