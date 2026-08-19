import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/interaction_service.dart';
import '../../models/user_model.dart';

class FavoritesController extends GetxController {
  final InteractionService _interactionService = Get.find<InteractionService>();

  var isLoading = false.obs;
  var favoriteProviders = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    isLoading.value = true;
    try {
      final list = await _interactionService.fetchFavorites();
      favoriteProviders.assignAll(list);
    } catch (e) {
      print("Error fetching favorites: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFavorite(int providerId) async {
    final success = await _interactionService.toggleFavorite(providerId);
    if (success) {
      favoriteProviders.removeWhere((p) => p.id == providerId);
      Get.snackbar('تم', 'تمت إزالة المزود من المفضلة', 
        backgroundColor: Colors.black87, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void sendDirectOffer(String providerName) {
    Get.snackbar('تقديم عرض', 'جاري الانتقال لتقديم عرض مباشر لـ "$providerName"...');
  }

  void viewProfile(String providerName) {
    Get.snackbar('الملف الشخصي', 'جاري فتح الملف الشخصي لـ "$providerName"...');
  }
}
