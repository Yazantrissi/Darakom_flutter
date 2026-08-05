import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/attachment_model.dart';
import 'my_projects_controller.dart';

class AddProjectController extends GetxController {
  // وضع التعديل
  var isEditMode = false.obs;
  var editingProjectId = 0.obs;

  // تبويبات نوع المشروع (إنشاء = true / تشطيب = false)
  var isConstructionTab = true.obs;

  // الحقول المشتركة
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // المحافظات السورية
  var selectedGovernorate = Rx<String?>(null);
  final List<String> governorates = [
    'دمشق', 'ريف دمشق', 'حلب', 'حمص', 'حماة', 'اللاذقية',
    'طرطوس', 'إدلب', 'الرقة', 'دير الزور', 'الحسكة', 'درعا',
    'السويداء', 'القنيطرة'
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
    // التحقق إذا كان هناك بيانات مرسلة للتعديل
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      initializeForEdit(Get.arguments);
    } else {
      // إضافة ملف واحد افتراضياً عند فتح الشاشة في حالة الإضافة الجديدة
      addAttachment();
    }
  }

  void initializeForEdit(Map<String, dynamic> project) {
    isEditMode.value = true;
    editingProjectId.value = project['id'];
    
    projectNameController.text = project['projectName'] ?? '';
    descriptionController.text = project['description'] ?? '';
    areaController.text = project['area'] ?? '';
    addressController.text = project['address'] ?? '';
    selectedGovernorate.value = project['governorate'];
    
    isConstructionTab.value = project['type'] == 'إنشاء';
    
    if (isConstructionTab.value) {
      selectedProvider.value = project['specialization'];
      constructionDurationDays.value = (project['duration'] as int).toDouble();
    } else {
      selectedCraftsman.value = project['specialization'];
      tenderType.value = project['tenderType'] ?? 'عادي';
      finishingDuration.value = (project['duration'] as int).toDouble();
    }
    
    // ملاحظة: المرفقات تتطلب معالجة خاصة في الحالات الواقعية (تحميل من السيرفر)
    // حالياً سنتركها فارغة أو نضيف حقلاً واحداً
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
    if (projectNameController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال اسم المشروع', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));

    final updatedProject = {
      'id': isEditMode.value ? editingProjectId.value : DateTime.now().millisecondsSinceEpoch,
      'projectName': projectNameController.text,
      'description': descriptionController.text,
      'area': areaController.text,
      'governorate': selectedGovernorate.value,
      'address': addressController.text,
      'type': isConstructionTab.value ? 'إنشاء' : 'تشطيب',
      'specialization': isConstructionTab.value ? selectedProvider.value : selectedCraftsman.value,
      'publishDate': isEditMode.value ? Get.arguments['publishDate'] : DateTime.now().toString().split(' ')[0],
      'offersCount': isEditMode.value ? Get.arguments['offersCount'] : 0,
      'status': isEditMode.value ? Get.arguments['status'] : 'تلقي العروض',
      'duration': isConstructionTab.value ? constructionDurationDays.value.toInt() : finishingDuration.value.toInt(),
    };

    if (isEditMode.value) {
      Get.find<MyProjectsController>().updatePendingProject(updatedProject);
      Get.snackbar('تم بنجاح', 'تم تحديث المشروع بنجاح', backgroundColor: Colors.green, colorText: Colors.white);
      
      // العودة لصفحة التفاصيل مع البيانات الجديدة
      Get.back(result: updatedProject);
    } else {
      // منطق الإضافة (يمكن استدعاء دالة الإضافة في المتحكم الرئيسي هنا)
      Get.snackbar('تم بنجاح', 'تمت إضافة المشروع وطرحه في المنصة.', backgroundColor: Colors.green, colorText: Colors.white);
      Get.back();
    }

    isLoading.value = false;
  }

  @override
  void onClose() {
    projectNameController.dispose();
    descriptionController.dispose();
    areaController.dispose();
    addressController.dispose();
    for (var attachment in projectAttachments) {
      attachment.dispose();
    }
    super.onClose();
  }
}