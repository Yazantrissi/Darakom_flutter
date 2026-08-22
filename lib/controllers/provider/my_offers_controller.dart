import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/offer_service.dart';
import '../../services/api_service.dart';
import '../../core/api_response.dart';
import '../../models/offer_model.dart';

class MyOffersController extends GetxController {
  final OfferService _offerService = Get.find<OfferService>();
  final ApiService _apiService = Get.find<ApiService>();

  var currentTabIndex = 0.obs;
  var isLoading = false.obs;

  var publicOffers = <OfferModel>[].obs;
  var privateOffers = <OfferModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOffers();
  }

  Future<void> fetchOffers() async {
    isLoading.value = true;
    try {
      final allOffers = await _offerService.fetchProviderOffers();
      publicOffers.value = allOffers
          .where((o) => o.status != 'withdrawn' && o.projectVisibility != 'private')
          .toList();
      privateOffers.value = allOffers
          .where((o) => o.projectVisibility == 'private')
          .toList();
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  Future<void> deleteOffer(int id, bool isPublic) async {
    try {
      isLoading.value = true;
      final response = await _apiService.delete('/provider/offers/$id');
      isLoading.value = false;

      if (ApiResponse.isSuccess(response.data)) {
        if (isPublic) {
          publicOffers.removeWhere((element) => element.id == id);
        } else {
          privateOffers.removeWhere((element) => element.id == id);
        }
        Get.snackbar(
          'تم الحذف',
          ApiResponse.messageOf(response.data, fallback: 'تم حذف العرض بنجاح'),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'خطأ',
          ApiResponse.messageOf(response.data, fallback: 'فشل حذف العرض'),
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('خطأ', 'فشل حذف العرض', backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }
}
