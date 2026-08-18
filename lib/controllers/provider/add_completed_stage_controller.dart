import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../../models/attachment_model.dart';
import '../../services/project_service.dart';

class AddCompletedStageController extends GetxController {
  final ProjectService _projectService = Get.find<ProjectService>();

  final int projectId = Get.arguments['projectId'];
  final String projectTitle = Get.arguments['projectTitle'];

  final TextEditingController commentController = TextEditingController();
  var isLoading = false.obs;

  // قائمة المرفقات الديناميكية
  var attachments = <AttachmentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // إضافة حقل مرفق واحد افتراضياً
    addAttachment();
  }

  void addAttachment() {
    attachments.add(AttachmentModel());
  }

  void removeAttachment(int index) {
    attachments[index].dispose();
    attachments.removeAt(index);
  }

  Future<void> pickAttachment(int index) async {
    String? selectedType = attachments[index].type.value;

    if (selectedType == null) {
      Get.snackbar(
        'تنبيه',
        'الرجاء اختيار نوع الملف أولاً',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: selectedType == 'صور' ? FileType.image : FileType.any,
        withData: kIsWeb,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        attachments[index].fileName.value = file.name;
        if (kIsWeb) {
          attachments[index].fileBytes.value = file.bytes;
        } else {
          attachments[index].filePath.value = file.path;
        }
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  Future<void> submitStageUpdate() async {
    if (commentController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إضافة وصف للمرحلة المنجزة', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    final Map<String, dynamic> data = {
      'comment': commentController.text,
    };

    List<Map<String, dynamic>> docs = [];
    for (var attr in attachments) {
      if (attr.fileBytes.value != null || attr.filePath.value != null) {
        docs.add({
          'file_path': attr.filePath.value,
          'file_bytes': attr.fileBytes.value,
          'file_name': attr.fileName.value,
        });
      }
    }

    final success = await _projectService.completeProjectStage(projectId, data, attachments: docs);
    isLoading.value = false;

    if (success) {
      Get.back(result: true); 
      Get.snackbar('تم بنجاح', 'تم تحديث حالة المشروع ونقله للمرحلة التالية', backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('خطأ', 'فشل في تحديث المشروع، حاول مرة أخرى', backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    for (var attr in attachments) {
      attr.dispose();
    }
    super.onClose();
  }
}
