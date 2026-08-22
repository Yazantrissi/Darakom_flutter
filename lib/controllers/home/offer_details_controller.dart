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
    refreshOfferDetails();
  }

  Future<void> refreshOfferDetails() async {
    if (offer.value.id == 0 || offer.value.projectId == 0) return;
    
    isLoading.value = true;
    try {
      final updatedOffer = await _offerService.fetchOfferDetails(offer.value.projectId, offer.value.id);
      if (updatedOffer != null) {
        offer.value = updatedOffer;
      }
    } catch (e) {
      print("Error refreshing offer details: $e");
    } finally {
      isLoading.value = false;
    }
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
        final result = await _offerService.acceptOfferDetailed(offer.value.projectId, offer.value.id);
        isLoading.value = false;
        
        if (result['success'] == true) {
          Get.snackbar(
            'تم قبول العرض',
            result['message']?.toString() ?? 'تهانينا! تم قبول العرض بنجاح.',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.back(result: true);
        } else {
          Get.snackbar('خطأ', result['message']?.toString() ?? 'فشل قبول العرض، حاول مرة أخرى', backgroundColor: Colors.redAccent, colorText: Colors.white);
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
        final result = await _offerService.rejectOfferDetailed(offer.value.projectId, offer.value.id);
        isLoading.value = false;
        
        if (result['success'] == true) {
          Get.snackbar(
            'تم الرفض',
            result['message']?.toString() ?? 'تم رفض العرض بنجاح.',
            backgroundColor: Colors.grey.shade800,
            colorText: Colors.white,
          );
          Get.back(result: true);
        } else {
          Get.snackbar('خطأ', result['message']?.toString() ?? 'فشل رفض العرض، حاول مرة أخرى', backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      },
    );
  }
}
