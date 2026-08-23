import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../../services/offer_service.dart';
import '../../models/attachment_model.dart';
import '../../models/offer_model.dart';

class SubmitOfferController extends GetxController {
  final OfferService _offerService = Get.find<OfferService>();

  final TextEditingController offerProjectNameController = TextEditingController();
  final TextEditingController totalDurationController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();

  var isLoading = false.obs;
  var projectStages = <StageItem>[].obs;
  var offerAttachments = <AttachmentModel>[].obs;

  int? editingOfferId;
  bool isEditMode = false;

  @override
  void onInit() {
    super.onInit();
    addAttachment();
  }

  void loadFromOffer(OfferModel offer, {required String projectName}) {
    isEditMode = true;
    editingOfferId = offer.id;
    offerProjectNameController.text = projectName;
    totalDurationController.text = offer.duration.toString();
    totalPriceController.text = offer.cost.round().toString();

    String? startDate;
    if (offer.workSummary != null && offer.workSummary!.trim().startsWith('{')) {
      try {
        final parsed = jsonDecode(offer.workSummary!);
        if (parsed is Map) {
          startDate = parsed['startDate']?.toString();
          final stages = parsed['stages'];
          if (stages is List && (offer.stages == null || offer.stages!.isEmpty)) {
            projectStages.clear();
            for (final s in stages) {
              if (s is! Map) continue;
              final item = StageItem();
              item.nameController.text = (s['name'] ?? s['title'] ?? '').toString();
              item.durationController.text =
                  (s['duration_days'] ?? s['duration'] ?? '').toString().replaceAll(RegExp(r'[^\d]'), '');
              projectStages.add(item);
            }
          }
        }
      } catch (_) {}
    }
    startDateController.text = startDate ?? '';

    if (offer.stages != null && offer.stages!.isNotEmpty) {
      projectStages.clear();
      for (final s in offer.stages!) {
        final item = StageItem();
        item.nameController.text = (s['title'] ?? s['name'] ?? '').toString();
        item.durationController.text =
            (s['duration_days'] ?? s['duration'] ?? '').toString().replaceAll(RegExp(r'[^\d]'), '');
        projectStages.add(item);
      }
    }
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

    final amount = int.tryParse(totalPriceController.text) ?? 0;
    final deliveryDays = int.tryParse(totalDurationController.text) ?? 1;

    final stages = projectStages
        .where((stage) => stage.nameController.text.trim().isNotEmpty)
        .map((stage) => {
              'title': stage.nameController.text.trim(),
              'duration_days': int.tryParse(stage.durationController.text),
            })
        .toList();

    final notesPayload = <String, dynamic>{
      if (startDateController.text.trim().isNotEmpty)
        'startDate': startDateController.text.trim(),
      if (stages.isNotEmpty) 'stages': stages,
      if (offerProjectNameController.text.trim().isNotEmpty)
        'projectTitle': offerProjectNameController.text.trim(),
    };

    final Map<String, dynamic> data = {
      'amount': amount,
      'delivery_days': deliveryDays,
      if (notesPayload.isNotEmpty) 'notes': jsonEncode(notesPayload),
      if (stages.isNotEmpty) 'stages': stages,
    };

    final docs = <Map<String, dynamic>>[];
    for (final att in offerAttachments) {
      if (att.fileBytes.value != null ||
          (att.filePath.value != null && att.filePath.value!.isNotEmpty)) {
        docs.add({
          'file_path': att.filePath.value,
          'file_bytes': att.fileBytes.value,
          'file_name': att.fileName.value,
          'title': att.type.value ?? att.fileName.value,
        });
      }
    }

    final Map<String, dynamic> result;
    if (isEditMode && editingOfferId != null) {
      result = await _offerService.updateOfferDetailed(
        editingOfferId!,
        data,
        attachments: docs.isNotEmpty ? docs : null,
      );
    } else {
      result = await _offerService.submitOfferDetailed(
        projectId,
        data,
        attachments: docs.isNotEmpty ? docs : null,
      );
    }
    isLoading.value = false;

    if (result['success'] == true) {
      Get.back(result: true);
      Get.snackbar(
        'نجاح',
        isEditMode ? 'تم تحديث العرض بنجاح' : 'تم إرسال العرض بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'خطأ',
        'فشل في حفظ العرض: ${result['message']}',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
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
