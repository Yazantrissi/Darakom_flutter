import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // أدوات التحكم بالنصوص للحقول القابلة للتعديل
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  // تحميل بيانات المستخدم الافتراضية
  void _loadUserData() {
    firstNameController.text = 'محمد';
    lastNameController.text = 'العتيبي';
    emailController.text = 'mohammed@example.com';
    phoneController.text = '0501234567';
    addressController.text = 'الرياض، المملكة العربية السعودية';
    bioController.text = 'مهتم ببناء وتصميم الفلل السكنية الحديثة والبحث عن أفضل المقاولين ومقدمي الخدمات الهندسية.';
  }

  // دالة محاكاة تغيير الصورة الشخصية
  void editProfilePicture() {
    print("فتح معرض الصور لتعديل الصورة الشخصية");
    Get.snackbar(
      'تحديث الصورة',
      'سيتم فتح معرض الصور لاختيار صورة جديدة.',
      backgroundColor: const Color(0xFF1A2A44),
      colorText: Colors.white,
    );
  }

  // دالة حفظ التغييرات وإرسالها للباك إيند
  Future<void> saveChanges() async {
    isLoading.value = true;

    // محاكاة الاتصال بالخادم (API Call)
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    Get.snackbar(
      'تم الحفظ',
      'تم تحديث بيانات البروفايل بنجاح.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    bioController.dispose();
    super.onClose();
  }
}