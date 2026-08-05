import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/attachment_model.dart';
import '../../models/project_stage_model.dart';

class SubmitOfferController extends GetxController {
  // الحقول الأساسية للعرض
  final TextEditingController offerProjectNameController = TextEditingController();
  final TextEditingController totalDurationController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();

  // قائمة مراحل المشروع
  var projectStages = <ProjectStageModel>[].obs;

  // قائمة المرفقات
  var offerAttachments = <AttachmentModel>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // إضافة مرحلة أولى افتراضياً
    addStage();
    // إضافة حقل مرفق واحد افتراضياً
    addAttachment();
  }

  // --- إدارة المراحل ---
  void addStage() {
    projectStages.add(ProjectStageModel());
  }

  void removeStage(int index) {
    if (projectStages.length > 1) {
      projectStages[index].dispose();
      projectStages.removeAt(index);
    } else {
      Get.snackbar('تنبيه', 'يجب أن يحتوي المشروع على مرحلة واحدة على الأقل', 
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // --- إدارة المرفقات (نفس منطق إضافة مشروع) ---
  void addAttachment() {
    offerAttachments.add(AttachmentModel());
  }

  void removeAttachment(int index) {
    offerAttachments[index].dispose();
    offerAttachments.removeAt(index);
  }

  Future<void> pickAttachment(int index) async {
    String? selectedType = offerAttachments[index].type.value;

    if (selectedType == null) {
      Get.snackbar('تنبيه', 'الرجاء اختيار نوع الملف أولاً', backgroundColor: Colors.orange, colorText: Colors.white);
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
        offerAttachments[index].fileName.value = result.files.single.name;
        offerAttachments[index].filePath.value = result.files.single.path;
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء اختيار الملف', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // إرسال العرض النهائي
  Future<void> submitOffer() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    Get.snackbar(
      'تم الإرسال',
      'تم تقديم عرضك بنجاح للعميل.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );

    Get.until((route) => Get.currentRoute == '/ProviderDashboardScreen' || route.isFirst);
  }

  @override
  void onClose() {
    offerProjectNameController.dispose();
    totalDurationController.dispose();
    totalPriceController.dispose();
    startDateController.dispose();
    for (var stage in projectStages) {
      stage.dispose();
    }
    for (var attachment in offerAttachments) {
      attachment.dispose();
    }
    super.onClose();
  }
}