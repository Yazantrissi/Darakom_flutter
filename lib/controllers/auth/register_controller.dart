import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart'; // استيراد مكتبة اختيار الملفات
import '../../models/attachment_model.dart'; // استيراد نموذج الملفات

class RegisterController extends GetxController {
  // أدوات التحكم بالنصوص
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController syndicateNumberController = TextEditingController();

  // المتغيرات التفاعلية
  var isCustomerTab = true.obs;
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var isLoading = false.obs;
  var isPrivacyAccepted = false.obs;

  // متغيرات القوائم المنسدلة (مزود الخدمة)
  Rx<String?> selectedSpecialization = Rx<String?>(null);
  Rx<String?> selectedCraft = Rx<String?>(null);

  // --- قائمة المرفقات الديناميكية ---
  var registerAttachments = <AttachmentModel>[].obs;

  final List<String> specializations = [
    'مكتب هندسي', 'مهندس مدني', 'مهندس معماري', 'استشاري', 'مقاول', 'حرفي'
  ];

  final List<String> crafts = [
    'كهرباء', 'سباكة', 'بلاط', 'تكييف', 'جبسنبورد', 'طاقة شمسية', 'دهان', 'نجارة', 'حدادة', 'غيرها'
  ];

  @override
  void onInit() {
    super.onInit();
    // إضافة حقل مرفق واحد افتراضياً عند فتح الشاشة
    addRegisterAttachment();
  }

  void switchTab(bool isCustomer) {
    isCustomerTab.value = isCustomer;
    selectedSpecialization.value = null;
    selectedCraft.value = null;
    syndicateNumberController.clear();
  }

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  void changeSpecialization(String? value) {
    selectedSpecialization.value = value;
    if (value != 'حرفي') {
      selectedCraft.value = null;
    }
  }

  void changeCraft(String? value) => selectedCraft.value = value;

  // --- دوال رفع الملفات (البديل للزر القديم) ---
  void addRegisterAttachment() {
    registerAttachments.add(AttachmentModel());
  }

  void removeRegisterAttachment(int index) {
    registerAttachments[index].dispose();
    registerAttachments.removeAt(index);
  }

  Future<void> pickRegisterAttachment(int index) async {
    String? selectedType = registerAttachments[index].type.value;

    if (selectedType == null) {
      Get.snackbar(
        'تنبيه',
        'الرجاء اختيار نوع الملف أولاً',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    FilePickerResult? result;

    try {
      if (selectedType == 'صور') {
        result = await FilePicker.platform.pickFiles(type: FileType.image);
      } else if (selectedType == 'ملفات') {
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt'],
        );
      }

      if (result != null && result.files.single.path != null) {
        registerAttachments[index].fileName.value = result.files.single.name;
        registerAttachments[index].filePath.value = result.files.single.path;
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء رفع الملف', backgroundColor: Colors.red, colorText: Colors.white);
    }
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
    for (var attachment in registerAttachments) {
      attachment.dispose();
    }
    super.onClose();
  }
}