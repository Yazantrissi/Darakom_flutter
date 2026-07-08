import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  // أدوات التحكم بالنصوص (تم فصل الاسم الأول والأخير كما طلبت)
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController syndicateNumberController = TextEditingController(); // الرقم النقابي

  // المتغيرات التفاعلية
  var isCustomerTab = true.obs;
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var isLoading = false.obs;
  var isPrivacyAccepted = false.obs; // سياسة الخصوصية

  // متغيرات القوائم المنسدلة (مزود الخدمة)
  Rx<String?> selectedSpecialization = Rx<String?>(null);
  Rx<String?> selectedCraft = Rx<String?>(null);

  final List<String> specializations = [
    'مكتب هندسي', 'مهندس مدني', 'مهندس معماري', 'استشاري', 'مقاول', 'حرفي'
  ];

  final List<String> crafts = [
    'كهرباء', 'سباكة', 'بلاط', 'تكييف', 'جبسنبورد', 'طاقة شمسية', 'دهان', 'نجارة', 'حدادة', 'غيرها'
  ];

  void switchTab(bool isCustomer) {
    isCustomerTab.value = isCustomer;
    // إعادة تعيين بعض القيم عند التبديل
    selectedSpecialization.value = null;
    selectedCraft.value = null;
    syndicateNumberController.clear();
  }

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  void changeSpecialization(String? value) {
    selectedSpecialization.value = value;
    if (value != 'حرفي') {
      selectedCraft.value = null; // تفريغ الحرفة إذا لم يكن حرفياً
    }
  }

  void changeCraft(String? value) => selectedCraft.value = value;

  // دالة محاكاة رفع الملفات
  void uploadDocuments() {
    print("تم الضغط على زر رفع الأوراق الثبوتية");
    // سيتم تنفيذ منطق اختيار الملفات (File Picker) هنا
  }

  Future<void> register() async {
    if (!isPrivacyAccepted.value) {
      Get.snackbar('تنبيه', 'يجب الموافقة على سياسة الخصوصية أولاً',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));

    String role = isCustomerTab.value ? 'عميل' : selectedSpecialization.value ?? 'مزود خدمة';
    print("تم تسجيل الحساب بنجاح: ${firstNameController.text} - $role");

    isLoading.value = false;
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    syndicateNumberController.dispose();
    super.onClose();
  }
}