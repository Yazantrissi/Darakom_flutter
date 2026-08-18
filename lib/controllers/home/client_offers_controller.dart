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
      
      // Using the specific backend endpoints
      final public = await _offerService.fetchClientPublicOffers();
      final private = await _offerService.fetchClientPrivateOffers();
      
      publicOffers.assignAll(public);
      privateOffers.assignAll(private);
      
    } catch (e) {
      print("Error fetching client offers: $e");
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
      middleText: 'هل أنت متأكد من رغبتك في قبول هذا العرض؟ سيتم بدء العمل رسمياً.',
      textConfirm: 'نعم، قبول',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: Colors.green,
      onConfirm: () async {
        Get.back();
        isLoading.value = true;
        final success = await _offerService.acceptOffer(offer.projectId, offer.id);
        
        if (success) {
          Get.snackbar('نجاح', 'تم قبول العرض بنجاح وبدء المشروع', backgroundColor: Colors.green, colorText: Colors.white);
          fetchOffers(); 
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
          fetchOffers();
        } else {
          isLoading.value = false;
          Get.snackbar('خطأ', 'فشل رفض العرض، حاول مرة أخرى', backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      },
    );
  }

  void onSearchTap() {
    // Navigate to Search Providers
  }
}
