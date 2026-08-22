import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/interaction_service.dart';
import '../../services/project_service.dart';
import '../../models/user_model.dart';
import 'dart:async';

class SearchProvidersController extends GetxController {
  final InteractionService _interactionService = Get.find<InteractionService>();
  final ProjectService _projectService = Get.find<ProjectService>();
  
  final TextEditingController searchController = TextEditingController();

  var searchResults = <UserModel>[].obs;
  var categories = <Map<String, dynamic>>[].obs;
  var selectedCategoryId = 0.obs;
  var isLoading = false.obs;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    onSearch("");
  }

  Future<void> fetchCategories() async {
    final list = await _interactionService.fetchServiceCategories();
    final flat = <Map<String, dynamic>>[];
    for (final e in list) {
      if (e is! Map) continue;
      final m = Map<String, dynamic>.from(e);
      final children = m['children'] as List?;
      if (children != null && children.isNotEmpty) {
        for (final c in children) {
          if (c is Map) flat.add(Map<String, dynamic>.from(c));
        }
      } else {
        flat.add(m);
      }
    }
    categories.assignAll(flat);
  }

  void selectCategory(int id) {
    if (selectedCategoryId.value == id) {
      selectedCategoryId.value = 0;
      onSearch(searchController.text);
    } else {
      selectedCategoryId.value = id;
      fetchByCategory(id);
    }
  }

  Future<void> fetchByCategory(int id) async {
    isLoading.value = true;
    try {
      final results = await _interactionService.fetchProvidersByCategory(id);
      searchResults.assignAll(results);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onSearch(String query) {
    if (selectedCategoryId.value != 0) return Future.value();

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      isLoading.value = true;
      try {
        final results = await _interactionService.searchProviders(query);
        searchResults.assignAll(results);
      } catch (e) {
        print("Search error: $e");
      } finally {
        isLoading.value = false;
      }
    });
    return Future.value();
  }

  void inviteToProject(UserModel provider) async {
    isLoading.value = true;
    final projects = await _projectService.fetchClientProjects();
    isLoading.value = false;

    if (projects.isEmpty) {
      Get.snackbar('تنبيه', 'يجب إضافة مشروع أولاً لتتمكن من إرسال دعوة', 
        backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

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
    Get.back();
    isLoading.value = true;
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

  @override
  void onClose() {
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}
