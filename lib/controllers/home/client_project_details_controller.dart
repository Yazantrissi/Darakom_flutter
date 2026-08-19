import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'my_projects_controller.dart';
import '../../models/project_model.dart';
import '../../views/home/client_offers_screen.dart';
import '../../views/home/add_project_screen.dart';
import '../../services/project_service.dart';

class ClientProjectDetailsController extends GetxController {
  final ProjectService _projectService = Get.find<ProjectService>();
  final MyProjectsController myProjectsController = Get.find<MyProjectsController>();

  var project = ProjectModel(id: 0, title: '', description: '', status: '').obs;
  var isLoading = false.obs;
  
  ClientProjectDetailsController({required ProjectModel projectData}) {
    project.value = projectData;
  }

  @override
  void onInit() {
    super.onInit();
    refreshProjectDetails();
  }

  Future<void> refreshProjectDetails() async {
    isLoading.value = true;
    try {
      final updated = await _projectService.fetchProjectDetails(project.value.id);
      if (updated != null) {
        project.value = updated;
      }
    } catch (e) {
      print("Error refreshing project details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void goToOffers() {
    Get.to(() => ClientOffersScreen());
  }

  Future<void> editProject() async {
    final result = await Get.to(() => AddProjectScreen(), arguments: project.value);
    if (result == true) {
      refreshProjectDetails();
      myProjectsController.fetchMyProjects();
    }
  }

  void deleteProject() {
    Get.defaultDialog(
      title: 'حذف المشروع',
      titleStyle: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
      middleText: 'هل أنت متأكد من رغبتك في حذف هذا المشروع؟ لا يمكن التراجع عن هذا الإجراء.',
      middleTextStyle: const TextStyle(fontFamily: 'Tajawal'),
      textConfirm: 'حذف',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        // Step 1: Call API to delete
        // final success = await _projectService.deleteProject(project.value.id);
        
        // Mocking deletion for now as logic is not in ProjectService yet
        myProjectsController.deletePendingProject(project.value.id);
        Get.back(); // close dialog
        Get.back(); // return from details
        Get.snackbar(
          'تم الحذف',
          'تم حذف المشروع بنجاح',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      },
    );
  }
}
