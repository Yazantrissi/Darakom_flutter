import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/offer_model.dart';
import '../../services/offer_service.dart';

class ClientOffersController extends GetxController {
  final OfferService _offerService = Get.find<OfferService>();

  var currentIndex = 0.obs;
  var isLoading = false.obs;
  
  var publicOffers = <OfferModel>[].obs;
  var privateOffers = <OfferModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOffers();
  }

  Future<void> fetchOffers() async {
    try {
      isLoading.value = true;
      
      // Fetch both public and private offers from the backend
      final public = await _offerService.fetchClientOffers(isPrivate: false);
      final private = await _offerService.fetchClientOffers(isPrivate: true);
      
      publicOffers.assignAll(public);
      privateOffers.assignAll(private);
      
    } catch (e) {
      print("Error fetching client dashboard offers: $e");
      Get.snackbar('خطأ', 'حدث مشكلة أثناء جلب العروض من السيرفر', 
        backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  Future<void> acceptOffer(OfferModel offer) async {
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
        final success = await _offerService.acceptOffer(offer.projectId, offer.id);
        
        if (success) {
          Get.snackbar('نجاح', 'تم قبول العرض بنجاح', backgroundColor: Colors.green, colorText: Colors.white);
          fetchOffers(); // Refresh the list
        } else {
          isLoading.value = false;
          Get.snackbar('خطأ', 'فشل قبول العرض، حاول مرة أخرى', backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      },
    );
  }

  Future<void> rejectOffer(OfferModel offer) async {
    Get.defaultDialog(
      title: 'رفض العرض',
      middleText: 'هل أنت متأكد من رغبتك في رفض هذا العرض؟',
      textConfirm: 'نعم، رفض',
      textCancel: 'تراجع',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        Get.back();
        isLoading.value = true;
        final success = await _offerService.rejectOffer(offer.projectId, offer.id);
        
        if (success) {
          Get.snackbar('تم الرفض', 'تم رفض العرض بنجاح', backgroundColor: Colors.grey.shade800, colorText: Colors.white);
          fetchOffers(); // Refresh the list
        } else {
          isLoading.value = false;
          Get.snackbar('خطأ', 'فشل رفض العرض، حاول مرة أخرى', backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      },
    );
  }

  void onSearchTap() {
    // Implement search logic or navigate to search screen if needed
  }
}
