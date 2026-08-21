import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/project_model.dart';
import '../../services/project_service.dart';
import '../../services/interaction_service.dart';

class MyProjectsController extends GetxController {
  final ProjectService _projectService = Get.find<ProjectService>();
  final InteractionService _interactionService = Get.find<InteractionService>();

  var isLoading = false.obs;

  // 1. قائمة المشاريع قيد الانتظار (Execution: not_started)
  var pendingProjects = <ProjectModel>[].obs;

  // 2. قائمة المشاريع قيد الإنشاء (Execution: in_progress)
  var activeProjects = <ProjectModel>[].obs;

  // 3. قائمة المشاريع المنتهية (Execution: finished)
  var completedProjects = <ProjectModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyProjects();
  }

  Future<void> fetchMyProjects() async {
    isLoading.value = true;
    try {
      final allProjects = await _projectService.fetchClientProjects();
      
      // Categorizing based on execution_status from backend
      pendingProjects.value = allProjects.where((p) => p.executionStatus == 'not_started').toList();
      activeProjects.value = allProjects.where((p) => p.executionStatus == 'in_progress').toList();
      completedProjects.value = allProjects.where((p) => p.executionStatus == 'finished' || p.status == 'completed').toList();
      
    } catch (e) {
      print("Error fetching my projects: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProjects() async {
    await fetchMyProjects();
  }

  void deletePendingProject(int id) {
    pendingProjects.removeWhere((p) => p.id == id);
  }

  // --- دوال التفاعل مع المشاريع المنتهية ---

  void showRatingDialog(ProjectModel project) {
    double selectedRating = 5.0;
    final TextEditingController commentController = TextEditingController();

    Get.defaultDialog(
      title: 'تقييم المشروع',
      titleStyle: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 18),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              Text('كيف كانت تجربتك في "${project.title}"؟', 
                style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
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
        }
      ),
      textConfirm: 'إرسال التقييم',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFF58A1E),
      onConfirm: () async {
        Get.back();
        isLoading.value = true;
        final result = await _interactionService.submitRating(project.id, {
          'rating': selectedRating,
          'comment': commentController.text,
        });
        isLoading.value = false;

        if (result['success']) {
          Get.snackbar('شكراً لك', result['message'], backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          Get.snackbar('خطأ', result['message'], backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      },
    );
  }

  void showComplaintDialog(ProjectModel project) {
    if (project.performerUserId == null) {
      Get.snackbar('تنبيه', 'لا يمكن تقديم شكوى على مشروع ليس له مقاول منفذ بعد', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    final TextEditingController complaintController = TextEditingController();
    Get.defaultDialog(
      title: 'تقديم شكوى',
      titleStyle: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 18, color: Colors.redAccent),
      content: Column(
        children: [
          Text('المشروع: ${project.title}', style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          TextField(
            controller: complaintController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'اشرح تفاصيل المشكلة التي واجهتها...',
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
          isLoading.value = true;
          final result = await _interactionService.submitComplaint(
            projectId: project.id, 
            text: complaintController.text,
            againstUserId: project.performerUserId!,
          );
          isLoading.value = false;

          if (result['success']) {
            Get.snackbar('تم الاستلام', result['message'], backgroundColor: Colors.green, colorText: Colors.white);
          } else {
            Get.snackbar('خطأ', result['message'], backgroundColor: Colors.redAccent, colorText: Colors.white);
          }
        } else {
          Get.snackbar('تنبيه', 'يرجى كتابة تفاصيل الشكوى أولاً', backgroundColor: Colors.orange, colorText: Colors.white);
        }
      },
    );
  }
}
