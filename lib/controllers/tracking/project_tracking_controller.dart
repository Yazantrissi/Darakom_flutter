import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../views/provider/add_completed_stage_screen.dart';
import '../../views/home/complaints_screen.dart';
import '../../controllers/home/complaints_controller.dart';
import '../../services/interaction_service.dart';
import '../../services/project_service.dart';
import '../../models/project_step_model.dart';
import '../../models/project_model.dart';

class ProjectTrackingController extends GetxController {
  final InteractionService _interactionService = Get.find<InteractionService>();
  final ProjectService _projectService = Get.find<ProjectService>();

  late final int projectId;
  late final String projectTitle;
  late final bool isProvider;
  late final bool canRate;

  var progress = 0.0.obs;
  var steps = <ProjectStepModel>[].obs;
  var isLoading = false.obs;
  var project = Rxn<ProjectModel>();

  int? performerUserId;
  String? providerName;
  String? providerType;
  String? provinceName;
  String? clientName;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    projectId = args['projectId'] ?? 0;
    projectTitle = args['projectTitle'] ?? "مشروع غير محدد";
    isProvider = args['isProvider'] ?? false;
    canRate = args['canRate'] == true;
    loadTrackingData();
  }

  Future<void> loadTrackingData() async {
    if (projectId == 0) return;

    try {
      isLoading.value = true;

      final details = await _projectService.fetchProjectDetails(projectId);
      if (details != null) {
        project.value = details;
        progress.value = details.progressPercentage / 100.0;
        performerUserId = details.performerUserId;
        providerName = details.providerName;
        providerType = details.providerType ?? details.type;
        provinceName = details.governorate;
        clientName = details.clientName;
        if (details.isCompletedLifecycle) {
          progress.value = 1.0;
        }
      }

      final stepsData =
          await _projectService.fetchProjectSteps(projectId, isProvider: isProvider);
      final mapped = stepsData
          .map((e) => ProjectStepModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      mapped.sort((a, b) => a.id.compareTo(b.id));
      steps.assignAll(mapped);

      if (steps.isNotEmpty && progress.value == 0) {
        final completed = steps.where((s) => s.isCompleted).length;
        progress.value = completed / steps.length;
      }
    } catch (e) {
      print("Error loading tracking data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void openComplaintForm() {
    if (Get.isRegistered<ComplaintsController>()) {
      Get.delete<ComplaintsController>();
    }
    Get.to(
      () => ComplaintsScreen(),
      arguments: {
        'prefill': true,
        'providerId': performerUserId,
        'providerName': providerName,
        'projectId': projectId,
        'projectTitle': projectTitle,
        'clientName': clientName,
      },
    );
  }

  void showComplaintDialog() {
    if (!isProvider && performerUserId == null) {
      Get.snackbar(
        'تنبيه',
        'لا يمكن تقديم شكوى حالياً، المقاول غير محدد',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    openComplaintForm();
  }

  void showRatingDialog() {
    final current = project.value;
    if (current == null) return;

    double selectedRating = 5.0;
    final TextEditingController commentController = TextEditingController();

    Get.defaultDialog(
      title: 'تقييم مزود الخدمة',
      titleStyle: const TextStyle(
        fontFamily: 'Tajawal',
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              Text(
                'المزود: ${providerName ?? "مزود الخدمة"}',
                style: const TextStyle(fontFamily: 'Tajawal', fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Text(
                'المشروع: $projectTitle',
                style: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                textAlign: TextAlign.center,
              ),
              if (clientName != null)
                Text(
                  'العميل: $clientName',
                  style: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selectedRating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: Colors.amber,
                      size: 36,
                    ),
                    onPressed: () => setState(() => selectedRating = index + 1.0),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'أضف تعليقك هنا (اختياري)...',
                  hintStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          );
        },
      ),
      textConfirm: 'إرسال التقييم',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFF58A1E),
      onConfirm: () async {
        Get.back();
        isLoading.value = true;
        final result = await _interactionService.submitRating(projectId, {
          'rating': selectedRating,
          'score': selectedRating.round(),
          'comment': commentController.text,
          if (performerUserId != null) 'reviewed_user_id': performerUserId,
        });
        isLoading.value = false;

        if (result['success'] == true) {
          Get.snackbar(
            'شكراً لك',
            result['message'] ?? 'تم إرسال التقييم',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'خطأ',
            result['message'] ?? 'فشل إرسال التقييم',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      },
    );
  }

  void addCompletedStage() {
    Get.to(() => AddCompletedStageScreen(), arguments: {
      'projectId': projectId,
      'projectTitle': projectTitle,
    })?.then((value) {
      if (value == true) loadTrackingData();
    });
  }
}
