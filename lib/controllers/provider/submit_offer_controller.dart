import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../../services/offer_service.dart';
import '../../models/attachment_model.dart';

class SubmitOfferController extends GetxController {
  final OfferService _offerService = Get.find<OfferService>();

  final TextEditingController offerProjectNameController = TextEditingController();
  final TextEditingController totalDurationController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();

  var isLoading = false.obs;
  var projectStages = <StageItem>[].obs;
  var offerAttachments = <AttachmentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    addAttachment();
  }

  void addStage() {
    projectStages.add(StageItem());
  }

  void removeStage(int index) {
    projectStages.removeAt(index);
  }

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

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: selectedType == 'صور' ? FileType.image : FileType.any,
        withData: kIsWeb,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        offerAttachments[index].fileName.value = file.name;
        if (kIsWeb) {
          offerAttachments[index].fileBytes.value = file.bytes;
        } else {
          offerAttachments[index].filePath.value = file.path;
        }
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  Future<void> submitOffer(int projectId) async {
    if (totalPriceController.text.isEmpty || totalDurationController.text.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى إكمال البيانات الأساسية السعر والمدة');
      return;
    }

    isLoading.value = true;
    
    final Map<String, dynamic> data = {
      'cost': double.tryParse(totalPriceController.text) ?? 0,
      'duration': int.tryParse(totalDurationController.text) ?? 1,
      'duration_unit': 'day', // Default to day, backend also accepts month, year
      'provider_comment': offerProjectNameController.text, // Using this as a comment for now
      'details': 'Submitted from mobile app',
    };

    List<Map<String, dynamic>> attachments = [];
    for (var attr in offerAttachments) {
      if (attr.fileBytes.value != null || attr.filePath.value != null) {
        attachments.add({
          'file_path': attr.filePath.value,
          'file_bytes': attr.fileBytes.value,
          'file_name': attr.fileName.value,
        });
      }
    }

    final result = await _offerService.submitOfferDetailed(projectId, data, attachments: attachments);
    isLoading.value = false;

    if (result['success']) {
      Get.back();
      Get.snackbar('نجاح', 'تم إرسال العرض بنجاح', backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('خطأ', 'فشل في إرسال العرض: ${result['message']}', backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    offerProjectNameController.dispose();
    totalDurationController.dispose();
    totalPriceController.dispose();
    startDateController.dispose();
    for (var stage in projectStages) {
      stage.nameController.dispose();
      stage.durationController.dispose();
    }
    for (var att in offerAttachments) {
      att.dispose();
    }
    super.onClose();
  }
}

class StageItem {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
}
