import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/offer_model.dart';
import '../../services/offer_service.dart';

class OfferDetailsController extends GetxController {
  final OfferService _offerService = Get.find<OfferService>();
  
  var isLoading = false.obs;
  var offer = OfferModel(id: 0, projectId: 0, status: '', cost: 0, duration: 0, durationUnit: '').obs;

  void setOffer(OfferModel offerData) {
    offer.value = offerData;
  }

  // دالة قبول العرض
  Future<void> acceptOffer() async {
    Get.defaultDialog(
      title: 'قبول العرض',
      middleText: 'هل أنت متأكد من رغبتك في قبول هذا العرض؟',
      textConfirm: 'نعم، قبول',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: Colors.green,
      onConfirm: () async {
        Get.back();
        isLoading.value = true;
        final success = await _offerService.acceptOffer(offer.value.projectId, offer.value.id);
        isLoading.value = false;
        
        if (success) {
          Get.snackbar(
            'تم قبول العرض',
            'تهانينا! تم قبول العرض بنجاح.',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.back(result: true); // العودة للشاشة السابقة مع إشارة للنجاح لتحديث القائمة
        } else {
          Get.snackbar('خطأ', 'فشل قبول العرض، حاول مرة أخرى', backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      },
    );
  }

  // دالة رفض العرض
  Future<void> rejectOffer() async {
    Get.defaultDialog(
      title: 'رفض العرض',
      titleStyle: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 18, color: Colors.redAccent),
      content: const Text(
        'هل أنت متأكد من رغبتك في رفض هذا العرض؟\nلن تتمكن من التراجع عن هذا الإجراء.',
        style: TextStyle(fontFamily: 'Tajawal', fontSize: 13),
        textAlign: TextAlign.center,
      ),
      textConfirm: 'نعم، أرفض',
      textCancel: 'تراجع',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        Get.back();
        isLoading.value = true;
        final success = await _offerService.rejectOffer(offer.value.projectId, offer.value.id);
        isLoading.value = false;
        
        if (success) {
          Get.snackbar(
            'تم الرفض',
            'تم رفض العرض بنجاح.',
            backgroundColor: Colors.grey.shade800,
            colorText: Colors.white,
          );
          Get.back(result: true);
        } else {
          Get.snackbar('خطأ', 'فشل رفض العرض، حاول مرة أخرى', backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      },
    );
  }
}
