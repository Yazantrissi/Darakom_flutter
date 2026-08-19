import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/complaint_model.dart';
import '../../services/interaction_service.dart';

class ComplaintsController extends GetxController {
  final InteractionService _interactionService = Get.find<InteractionService>();

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
      
      pendingComplaints.value = complaints.where((c) => c.status == 'pending').toList();
      resolvedComplaints.value = complaints.where((c) => c.status == 'resolved').toList();
      rejectedComplaints.value = complaints.where((c) => c.status == 'rejected').toList();
      
    } catch (e) {
      print("Error in fetchComplaints: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitNewComplaint(int projectId, String description) async {
    if (description.isEmpty) return;
    
    isLoading.value = true;
    final success = await _interactionService.submitComplaint(projectId, description);
    isLoading.value = false;

    if (success) {
      Get.snackbar('تم الإرسال', 'تم رفع الشكوى للإدارة وسيتم التواصل معك قريباً', 
        backgroundColor: Colors.green, colorText: Colors.white);
      fetchComplaints();
    } else {
      Get.snackbar('خطأ', 'فشل إرسال الشكوى، حاول مرة أخرى', 
        backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }
}
