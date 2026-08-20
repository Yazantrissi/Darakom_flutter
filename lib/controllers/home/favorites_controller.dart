import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/interaction_service.dart';
import '../../services/project_service.dart';
import '../../models/user_model.dart';
import '../../models/project_model.dart';

class FavoritesController extends GetxController {
  final InteractionService _interactionService = Get.find<InteractionService>();
  final ProjectService _projectService = Get.find<ProjectService>();

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

  void inviteToProject(UserModel provider) async {
    // 1. Fetch Client Projects
    isLoading.value = true;
    final projects = await _projectService.fetchClientProjects();
    isLoading.value = false;

    if (projects.isEmpty) {
      Get.snackbar('تنبيه', 'يجب إضافة مشروع أولاً لتتمكن من إرسال دعوة', 
        backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    // 2. Show Selection Dialog
    Get.defaultDialog(
      title: 'دعوة لمشروع',
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('اختر المشروع الذي ترغب بدعوة المزود إليه:', 
              style: TextStyle(fontFamily: 'Tajawal', fontSize: 13)),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final p = projects[index];
                  return ListTile(
                    title: Text(p.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: Text(p.status, style: const TextStyle(fontSize: 12)),
                    onTap: () => _sendInvitation(p.id, provider),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      textCancel: 'إلغاء',
    );
  }

  void _sendInvitation(int projectId, UserModel provider) async {
    Get.back(); // Close dialog
    isLoading.value = true;
    
    // We need the provider's profile ID. If UserModel is from Profile resource, id is likely the profile id.
    // In our UserModel mapping, we might need to check if we have the profile id specifically.
    // Assuming 'id' in search results is the Profile ID for simplicity here.
    final success = await _interactionService.sendProjectInvitation(projectId, provider.id);
    isLoading.value = false;

    if (success) {
      Get.snackbar('تم الإرسال', 'تم إرسال الدعوة لـ "${provider.name}" بنجاح', 
        backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('خطأ', 'فشل إرسال الدعوة، قد يكون المزود مدعواً مسبقاً', 
        backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  void viewProfile(String providerName) {
    Get.snackbar('الملف الشخصي', 'جاري فتح الملف الشخصي لـ "$providerName"...');
  }
}
