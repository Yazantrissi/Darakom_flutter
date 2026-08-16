import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/offer_model.dart';

class OfferDetailsController extends GetxController {
  var isLoading = false.obs;
  var offer = OfferModel(id: 0, projectId: 0, status: '', cost: 0, duration: 0, durationUnit: '').obs;

  void setOffer(OfferModel offerData) {
    offer.value = offerData;
  }

  // دالة قبول العرض
  Future<void> acceptOffer() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // محاكاة التحميل
    isLoading.value = false;

    Get.snackbar(
      'تم قبول العرض',
      'تهانينا! تم قبول العرض وسيتم نقلك لتوقيع العقد وإتمام الإجراءات.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
    // مستقبلاً: الانتقال لشاشة توقيع العقد أو الدفع
  }

  // دالة رفض العرض
  void rejectOffer() {
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
      onConfirm: () {
        Get.back(); // إغلاق النافذة
        Get.back(); // العودة لشاشة العروض
        Get.snackbar(
          'تم الرفض',
          'تم رفض العرض بنجاح وإشعار مزود الخدمة.',
          backgroundColor: Colors.grey.shade800,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      },
    );
  }
}