import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/interaction_service.dart';
import '../../models/user_model.dart';
import '../../views/home/add_project_screen.dart';

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
      Get.snackbar(
        'تم',
        'تمت إزالة المزود من المفضلة',
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Send private offer = create project locked to this provider.
  void inviteToProject(UserModel provider) {
    Get.to(
      () => AddProjectScreen(),
      arguments: {
        'invited_provider_id': provider.id,
        'providerId': provider.id,
        'providerName': provider.name,
        'visibility': 'private',
      },
    );
  }

  void viewProfile(UserModel provider) {
    Get.defaultDialog(
      title: 'ملف مزود الخدمة',
      titleStyle: const TextStyle(
        fontFamily: 'Tajawal',
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('الاسم: ${provider.name}',
              style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            'النوع: ${provider.providerType ?? provider.roleName ?? provider.type}',
            style: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            'المحافظة: ${provider.provinceName ?? provider.city ?? "غير محدد"}',
            style: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
          ),
          if (provider.phone != null && provider.phone!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('الهاتف: ${provider.phone}',
                style: const TextStyle(fontFamily: 'Tajawal', fontSize: 13)),
          ],
          if (provider.bio != null && provider.bio!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('نبذة: ${provider.bio}',
                style: const TextStyle(fontFamily: 'Tajawal', fontSize: 13)),
          ],
        ],
      ),
      textConfirm: 'عرض خاص',
      textCancel: 'إغلاق',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFF58A1E),
      onConfirm: () {
        Get.back();
        inviteToProject(provider);
      },
    );
  }
}
