import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/project_model.dart';
import '../../services/project_service.dart';

class MyProjectsController extends GetxController {
  final ProjectService _projectService = Get.find<ProjectService>();

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
      
      // Splitting based on execution_status or status
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
    // In a real app, call a delete API first
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

  void showRatingDialog(String projectName) {
    Get.defaultDialog(
      title: 'تقييم المشروع',
      titleStyle: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 18),
      content: Column(
        children: [
          Text('كيف كانت تجربتك في "$projectName"؟', style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => const Icon(Icons.star_rounded, color: Colors.amber, size: 36)),
          ),
          const SizedBox(height: 16),
          TextField(
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'أضف تعليقك هنا (اختياري)...',
              hintStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
      textConfirm: 'إرسال التقييم',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFF58A1E),
      onConfirm: () {
        Get.back();
        Get.snackbar('شكراً لك', 'تم إرسال تقييمك بنجاح', backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  void showComplaintDialog(String projectName) {
    final TextEditingController complaintController = TextEditingController();
    Get.defaultDialog(
      title: 'تقديم شكوى',
      titleStyle: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 18, color: Colors.redAccent),
      content: Column(
        children: [
          Text('المشروع: $projectName', style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 13)),
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
      onConfirm: () {
        if (complaintController.text.isNotEmpty) {
          Get.back();
          Get.snackbar('تم الاستلام', 'تم رفع الشكوى للإدارة وسيتم التواصل معك قريباً', backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
        } else {
          Get.snackbar('تنبيه', 'يرجى كتابة تفاصيل الشكوى أولاً', backgroundColor: Colors.orange, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
        }
      },
    );
  }
}
