import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    // Logic for picking file using model
  }

  Future<void> submitOffer(int projectId) async {
    if (offerProjectNameController.text.isEmpty || totalPriceController.text.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى إكمال البيانات الأساسية');
      return;
    }

    isLoading.value = true;
    
    final data = {
      'project_name': offerProjectNameController.text,
      'duration': totalDurationController.text,
      'cost': totalPriceController.text,
      'start_date': startDateController.text,
      'stages': projectStages.map((e) => {
        'name': e.nameController.text,
        'duration': e.durationController.text,
      }).toList(),
    };

    final success = await _offerService.submitOffer(projectId, data);
    isLoading.value = false;

    if (success) {
      Get.back();
      Get.snackbar('نجاح', 'تم إرسال العرض بنجاح', backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('خطأ', 'فشل في إرسال العرض', backgroundColor: Colors.redAccent, colorText: Colors.white);
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
