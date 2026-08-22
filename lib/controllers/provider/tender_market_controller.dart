import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/project_model.dart';
import '../../services/project_service.dart';
import '../../views/provider/project_details_screen.dart';

class TenderMarketController extends GetxController {
  final ProjectService _projectService = Get.find<ProjectService>();

  var currentTabIndex = 0.obs;
  var isLoading = false.obs;

  var publicTenders = <ProjectModel>[].obs;
  var privateTenders = <ProjectModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTenders();
  }

  Future<void> fetchTenders() async {
    isLoading.value = true;
    try {
      final public = await _projectService.fetchPublicTenders();
      final private = await _projectService.fetchPrivateTenders();
      publicTenders.assignAll(public);
      privateTenders.assignAll(private);
    } catch (e) {
      print('Error fetching tenders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  void viewTenderDetails(int tenderId) {
    ProjectModel? tender = publicTenders.firstWhereOrNull((e) => e.id == tenderId) ??
        privateTenders.firstWhereOrNull((e) => e.id == tenderId);
    if (tender == null) return;
    Get.to(() => ProjectDetailsScreen(projectData: tender));
  }

  Future<void> rejectTender(int projectId) async {
    final project = privateTenders.firstWhereOrNull((p) => p.id == projectId);
    final invitationId = project?.invitationId;

    if (invitationId == null) {
      Get.snackbar(
        'تنبيه',
        'تعذر رفض الدعوة: معرّف الدعوة غير متوفر من الخادم حالياً.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    Get.defaultDialog(
      title: 'رفض المناقصة',
      middleText: 'هل أنت متأكد من رغبتك في رفض هذه الدعوة؟',
      textConfirm: 'نعم، رفض',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        Get.back();
        isLoading.value = true;
        final success = await _projectService.rejectInvitation(invitationId);
        isLoading.value = false;

        if (success) {
          privateTenders.removeWhere((t) => t.id == projectId);
          Get.snackbar(
            'تم الرفض',
            'تم رفض الدعوة بنجاح',
            backgroundColor: Colors.grey.shade800,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'خطأ',
            'فشل رفض الدعوة، حاول مرة أخرى',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      },
    );
  }
}
