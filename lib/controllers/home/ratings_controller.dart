import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/rating_model.dart';
import '../../models/project_model.dart';
import '../../services/interaction_service.dart';
import '../../services/project_service.dart';

class RatingsController extends GetxController {
  final InteractionService _interactionService = Get.find<InteractionService>();
  final ProjectService _projectService = Get.find<ProjectService>();

  var isLoading = false.obs;

  var givenRatings = <RatingModel>[].obs;
  var receivedRatings = <RatingModel>[].obs;

  var rateableProjects = <ProjectModel>[].obs;
  var uniqueProviders = <Map<String, dynamic>>[].obs;
  var filteredProjects = <ProjectModel>[].obs;
  var selectedProviderId = Rxn<int>();
  var selectedProjectId = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    fetchRatings();
    loadRateableProjects();
  }

  Future<void> fetchRatings() async {
    try {
      isLoading.value = true;
      final ratings = await _interactionService.fetchClientRatings();
      givenRatings.value = ratings;
      receivedRatings.value = [];
    } catch (e) {
      print("Error in fetchRatings: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadRateableProjects() async {
    final projects = await _projectService.fetchClientProjects();
    rateableProjects.assignAll(
      projects.where((p) => p.isCompletedLifecycle && p.performerUserId != null),
    );

    final map = <int, Map<String, dynamic>>{};
    for (final p in rateableProjects) {
      final id = p.performerUserId!;
      map.putIfAbsent(id, () => {
            'id': id,
            'name': p.providerName ?? 'مزود خدمة',
          });
    }
    uniqueProviders.assignAll(map.values.toList());
  }

  void onProviderSelected(int? providerId) {
    selectedProviderId.value = providerId;
    selectedProjectId.value = null;
    if (providerId == null) {
      filteredProjects.clear();
      return;
    }
    filteredProjects.assignAll(
      rateableProjects.where((p) => p.performerUserId == providerId).toList(),
    );
    if (filteredProjects.length == 1) {
      selectedProjectId.value = filteredProjects.first.id;
    }
  }

  void openNewRatingDialog() {
    if (uniqueProviders.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'لا توجد مشاريع مكتملة قابلة للتقييم',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    selectedProviderId.value ??= uniqueProviders.first['id'] as int?;
    onProviderSelected(selectedProviderId.value);

    double selectedRating = 5.0;
    final TextEditingController commentController = TextEditingController();

    Get.defaultDialog(
      title: 'إضافة تقييم جديد',
      titleStyle: const TextStyle(
        fontFamily: 'Tajawal',
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Obx(() {
              final project = filteredProjects
                  .firstWhereOrNull((p) => p.id == selectedProjectId.value);
              return Column(
                children: [
                  DropdownButtonFormField<int>(
                    value: selectedProviderId.value,
                    decoration: const InputDecoration(
                      labelText: 'مزود الخدمة',
                      labelStyle: TextStyle(fontFamily: 'Tajawal'),
                      border: OutlineInputBorder(),
                    ),
                    items: uniqueProviders
                        .map(
                          (p) => DropdownMenuItem<int>(
                            value: p['id'] as int,
                            child: Text(
                              p['name']?.toString() ?? 'مزود',
                              style: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (id) {
                      onProviderSelected(id);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: selectedProjectId.value,
                    decoration: const InputDecoration(
                      labelText: 'المشروع',
                      labelStyle: TextStyle(fontFamily: 'Tajawal'),
                      border: OutlineInputBorder(),
                    ),
                    items: filteredProjects
                        .map(
                          (p) => DropdownMenuItem<int>(
                            value: p.id,
                            child: Text(
                              p.title,
                              style: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (id) {
                      selectedProjectId.value = id;
                      setState(() {});
                    },
                  ),
                  if (project != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'العميل: ${project.clientName ?? "أنت"}',
                      style: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < selectedRating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () => setState(() => selectedRating = index + 1.0),
                      );
                    }),
                  ),
                  TextField(
                    controller: commentController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'أضف تعليقك هنا...',
                      hintStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              );
            });
          },
        ),
      ),
      textConfirm: 'إرسال التقييم',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFF58A1E),
      onConfirm: () async {
        final projectId = selectedProjectId.value;
        if (projectId == null) {
          Get.snackbar('تنبيه', 'يرجى اختيار المشروع',
              backgroundColor: Colors.orange, colorText: Colors.white);
          return;
        }
        Get.back();
        await submitRating(
          projectId,
          selectedRating,
          commentController.text,
          reviewedUserId: selectedProviderId.value,
        );
      },
    );
  }

  Future<void> submitRating(
    int projectId,
    double rating,
    String comment, {
    int? reviewedUserId,
  }) async {
    isLoading.value = true;
    final result = await _interactionService.submitRating(projectId, {
      'rating': rating,
      'score': rating.round(),
      'comment': comment,
      if (reviewedUserId != null) 'reviewed_user_id': reviewedUserId,
    });
    isLoading.value = false;

    if (result['success'] == true) {
      Get.snackbar(
        'تم بنجاح',
        'شكراً لك على تقييمك!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      fetchRatings();
    } else {
      Get.snackbar(
        'خطأ',
        result['message'] ?? 'فشل إرسال التقييم، حاول مرة أخرى',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
