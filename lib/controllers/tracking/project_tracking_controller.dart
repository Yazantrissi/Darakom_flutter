import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../views/provider/add_completed_stage_screen.dart';
import '../../services/interaction_service.dart';
import '../../services/project_service.dart';
import '../../models/project_step_model.dart';

class ProjectTrackingController extends GetxController {
  final InteractionService _interactionService = Get.find<InteractionService>();
  final ProjectService _projectService = Get.find<ProjectService>();

  // Data from arguments
  late final int projectId;
  late final String projectTitle;
  late final bool isProvider;

  var progress = 0.0.obs;
  var steps = <ProjectStepModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    projectId = args['projectId'] ?? 0;
    projectTitle = args['projectTitle'] ?? "مشروع غير محدد";
    isProvider = args['isProvider'] ?? false;
    
    loadTrackingData();
  }

  Future<void> loadTrackingData() async {
    if (projectId == 0) return;
    
    try {
      isLoading.value = true;
      
      // 1. Load project details for overall progress
      final project = await _projectService.fetchProjectDetails(projectId);
      if (project != null) {
        progress.value = project.progressPercentage / 100.0;
      }

      // 2. Load milestones/steps
      final stepsData = await _projectService.fetchProjectSteps(projectId, isProvider: isProvider);
      steps.assignAll(stepsData.map((e) => ProjectStepModel.fromJson(e)).toList());
      
    } catch (e) {
      print("Error loading tracking data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void showComplaintDialog() {
    final TextEditingController complaintController = TextEditingController();
    Get.defaultDialog(
      title: 'تقديم شكوى',
      titleStyle: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 18, color: Colors.redAccent),
      content: Column(
        children: [
          const Text(
            'هل تواجه مشكلة أو تأخير في سير العمل؟',
            style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: complaintController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'اشرح تفاصيل المشكلة هنا ليتم التدخل من الإدارة...',
              hintStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
            ),
          ),
        ],
      ),
      textConfirm: 'إرسال الشكوى',
      textCancel: 'تراجع',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        if (complaintController.text.isNotEmpty) {
          Get.back();
          final success = await _interactionService.submitComplaint(projectId, complaintController.text);
          if (success) {
            Get.snackbar('تم الإرسال', 'تم رفع الشكوى للإدارة وسيتم التواصل معك قريباً', 
              backgroundColor: Colors.green, colorText: Colors.white);
          } else {
            Get.snackbar('خطأ', 'فشل إرسال الشكوى، حاول مرة أخرى', 
              backgroundColor: Colors.redAccent, colorText: Colors.white);
          }
        } else {
          Get.snackbar('تنبيه', 'يرجى كتابة تفاصيل الشكوى أولاً', backgroundColor: Colors.orange, colorText: Colors.white);
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
