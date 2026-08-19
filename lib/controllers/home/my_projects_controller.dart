import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/project_model.dart';
import '../../services/project_service.dart';
import '../../services/interaction_service.dart';

class MyProjectsController extends GetxController {
  final ProjectService _projectService = Get.find<ProjectService>();
  final InteractionService _interactionService = Get.find<InteractionService>();

  var isLoading = false.obs;

  // 1. قائمة المشاريع قيد الانتظار
  var pendingProjects = <ProjectModel>[].obs;

  // 2. قائمة المشاريع قيد الإنشاء
  var activeProjects = <ProjectModel>[].obs;

  // 3. قائمة المشاريع المنتهية
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
      
      pendingProjects.value = allProjects.where((p) => p.status == 'new' || p.status == 'pending').toList();
      activeProjects.value = allProjects.where((p) => p.status == 'active').toList();
      completedProjects.value = allProjects.where((p) => p.status == 'completed' || p.status == 'finished').toList();
      
    } catch (e) {
      print("Error fetching my projects: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void deletePendingProject(int id) {
    pendingProjects.removeWhere((p) => p.id == id);
  }

  void updatePendingProject(ProjectModel updatedProject) {
    int index = pendingProjects.indexWhere((p) => p.id == updatedProject.id);
    if (index != -1) {
      pendingProjects[index] = updatedProject;
      pendingProjects.refresh();
    }
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
        final success = await _interactionService.submitRating(project.id, {
          'rating': selectedRating,
          'comment': commentController.text,
        });
        isLoading.value = false;

        if (success) {
          Get.snackbar('شكراً لك', 'تم إرسال تقييمك بنجاح', backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          Get.snackbar('خطأ', 'فشل إرسال التقييم، حاول مرة أخرى', backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      },
    );
  }

  void showComplaintDialog(ProjectModel project) {
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
          final success = await _interactionService.submitComplaint(project.id, complaintController.text);
          isLoading.value = false;

          if (success) {
            Get.snackbar('تم الاستلام', 'تم رفع الشكوى للإدارة وسيتم التواصل معك قريباً', backgroundColor: Colors.green, colorText: Colors.white);
          } else {
            Get.snackbar('خطأ', 'فشل إرسال الشكوى، حاول مرة أخرى', backgroundColor: Colors.redAccent, colorText: Colors.white);
          }
        } else {
          Get.snackbar('تنبيه', 'يرجى كتابة تفاصيل الشكوى أولاً', backgroundColor: Colors.orange, colorText: Colors.white);
        }
      },
    );
  }
}
