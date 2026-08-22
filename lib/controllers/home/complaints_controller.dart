import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/complaint_model.dart';
import '../../services/interaction_service.dart';
import '../../services/project_service.dart';

class ComplaintsController extends GetxController {
  final InteractionService _interactionService = Get.find<InteractionService>();
  final ProjectService _projectService = Get.find<ProjectService>();

  var isLoading = false.obs;

  // 1. الشكاوي قيد المراجعة
  var pendingComplaints = <ComplaintModel>[].obs;

  // 2. الشكاوي التي تم حلها
  var resolvedComplaints = <ComplaintModel>[].obs;

  // 3. الشكاوي المرفوضة
  var rejectedComplaints = <ComplaintModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchComplaints();
  }

  Future<void> fetchComplaints() async {
    try {
      isLoading.value = true;
      final complaints = await _interactionService.fetchClientComplaints();

      const pendingStatuses = {
        'pending_review',
        'pending',
        'open',
        'in_review',
      };

      pendingComplaints.value =
          complaints.where((c) => pendingStatuses.contains(c.status)).toList();
      resolvedComplaints.value =
          complaints.where((c) => c.status == 'resolved').toList();
      rejectedComplaints.value =
          complaints.where((c) => c.status == 'rejected').toList();

    } catch (e) {
      print("Error in fetchComplaints: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitNewComplaint(int projectId, String description) async {
    if (description.isEmpty) return;
    
    isLoading.value = true;
    
    // 1. Fetch project to get performer ID
    final project = await _projectService.fetchProjectDetails(projectId);
    if (project == null || project.performerUserId == null) {
      isLoading.value = false;
      Get.snackbar('تنبيه', 'لا يمكن تقديم شكوى حالياً، المقاول غير محدد', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    // 2. Submit complaint
    final result = await _interactionService.submitComplaint(
      projectId: projectId, 
      text: description,
      againstUserId: project.performerUserId!,
    );
    isLoading.value = false;

    if (result['success'] == true) {
      Get.snackbar('تم الإرسال', result['message'] ?? 'تم رفع الشكوى للإدارة وسيتم التواصل معك قريباً', 
        backgroundColor: Colors.green, colorText: Colors.white);
      fetchComplaints();
    } else {
      Get.snackbar('خطأ', result['message'] ?? 'فشل إرسال الشكوى، حاول مرة أخرى', 
        backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }
}
