import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/attachment_model.dart';
import '../../views/home/client_dashboard_screen.dart';

class AuthController extends GetxController {
  // حقول الإدخال
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  // المرفقات الخاصة بعملية إنشاء الحساب (للهوية أو السجل التجاري)
  var registerAttachments = <AttachmentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // إضافة حقل مرفق واحد افتراضياً عند فتح الشاشة
    addRegisterAttachment();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // --- دوال المرفقات للتسجيل ---
  void addRegisterAttachment() {
    registerAttachments.add(AttachmentModel());
  }

  void removeRegisterAttachment(int index) {
    registerAttachments[index].dispose();
    registerAttachments.removeAt(index);
  }

  // دالة اختيار ملفات التوثيق
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
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء رفع الملف',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> login() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    Get.offAll(() => ClientDashboardScreen());
  }

  Future<void> register() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    Get.snackbar(
      'تم بنجاح',
      'تم إنشاء الحساب بنجاح.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );

    Get.offAll(() => ClientDashboardScreen());
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    for (var attachment in registerAttachments) {
      attachment.dispose();
    }
    super.onClose();
  }
}