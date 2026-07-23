import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/attachment_model.dart';

class AddProjectController extends GetxController {
  // تبويبات نوع المشروع (إنشاء = true / تشطيب = false)
  var isConstructionTab = true.obs;

  // الحقول المشتركة
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // المحافظات (أمثلة افتراضية)
  var selectedGovernorate = Rx<String?>(null);
  final List<String> governorates = [
    'الرياض', 'مكة المكرمة', 'المدينة المنورة', 'الشرقية', 'القصيم', 'عسير', 'تبوك'
  ];

  // --- قسم الإنشاء (Construction) ---
  var selectedProvider = Rx<String?>(null);
  final List<String> providers = [
    'مكتب هندسي', 'مهندس مدني', 'مهندس معماري', 'استشاري', 'مقاول'
  ];
  var constructionDurationDays = 1.0.obs; // من 1 إلى 30 يوم

  // --- قسم التشطيب (Finishing) ---
  var selectedCraftsman = Rx<String?>(null);
  final List<String> craftsmen = [
    'كهرباء', 'سباكة', 'بلاط', 'تكييف', 'جبسنبورد', 'طاقة شمسية', 'دهان'
  ];
  var tenderType = 'عادي'.obs; // نوع الطرح (عادي / مستعجل)
  var finishingDuration = 1.0.obs; // المدة تعتمد على نوع الطرح

  // --- قسم رفع الملفات الديناميكي ---
  var projectAttachments = <AttachmentModel>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // إضافة ملف واحد افتراضياً عند فتح الشاشة
    addAttachment();
  }

  // دوال تغيير الحالة للتبويبات
  void switchTab(bool isConstruction) {
    isConstructionTab.value = isConstruction;
  }

  void changeTenderType(String? type) {
    if (type != null) {
      tenderType.value = type;
      // تصفير المدة لتجنب أخطاء النطاق عند تغيير نوع الطرح
      finishingDuration.value = 1.0;
    }
  }

  // --- دوال إدارة المرفقات ---
  void addAttachment() {
    projectAttachments.add(AttachmentModel());
  }

  void removeAttachment(int index) {
    projectAttachments[index].dispose(); // تنظيف الذاكرة للملف المحذوف
    projectAttachments.removeAt(index);
  }

  // دالة اختيار الملفات باستخدام file_picker
  Future<void> pickAttachment(int index) async {
    String? selectedType = projectAttachments[index].type.value;

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
        // فتح معرض الصور فقط
        result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );
      } else if (selectedType == 'ملفات') {
        // فتح متصفح الملفات للمستندات فقط
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt'],
        );
      }

      // إذا قام المستخدم باختيار ملف ولم يقم بإلغاء العملية
      if (result != null && result.files.single.path != null) {
        projectAttachments[index].fileName.value = result.files.single.name;
        projectAttachments[index].filePath.value = result.files.single.path;
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء اختيار الملف',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // إرسال المشروع
  Future<void> submitProject() async {
    isLoading.value = true;

    // محاكاة الإرسال للخادم
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    Get.snackbar(
      'تم بنجاح',
      'تمت إضافة المشروع وطرحه في المنصة.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );

    Get.back(); // العودة للوحة التحكم
  }

  @override
  void onClose() {
    descriptionController.dispose();
    areaController.dispose();
    addressController.dispose();
    for (var attachment in projectAttachments) {
      attachment.dispose();
    }
    super.onClose();
  }
}