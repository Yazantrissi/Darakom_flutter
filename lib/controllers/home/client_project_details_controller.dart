import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'my_projects_controller.dart';
import '../../models/project_model.dart';
import '../../models/project_report_model.dart';
import '../../views/home/client_offers_screen.dart';
import '../../views/home/add_project_screen.dart';
import '../../services/project_service.dart';

class ClientProjectDetailsController extends GetxController {
  final ProjectService _projectService = Get.find<ProjectService>();
  final MyProjectsController myProjectsController = Get.find<MyProjectsController>();

  var project = ProjectModel(id: 0, title: '', description: '', status: '', executionStatus: 'not_started').obs;
  var isLoading = false.obs;
  var isDeleting = false.obs;

  var reports = <ProjectReportModel>[].obs;
  var documents = <Map<String, dynamic>>[].obs;
  
  ClientProjectDetailsController({required ProjectModel projectData}) {
    project.value = projectData;
  }

  @override
  void onInit() {
    super.onInit();
    refreshProjectDetails();
    fetchReports();
    fetchDocuments();
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

  Future<void> fetchReports() async {
    try {
      final list = await _projectService.fetchProjectReports(project.value.id);
      reports.assignAll(list);
    } catch (e) {
      print("Error fetching reports: $e");
    }
  }

  Future<void> fetchDocuments() async {
    try {
      final list = await _projectService.fetchProjectDocuments(project.value.id);
      documents.assignAll(list);
    } catch (e) {
      print("Error fetching documents: $e");
    }
  }

  void goToOffers() {
    Get.to(() => ClientOffersScreen(projectId: project.value.id));
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
        Get.back(); // close dialog
        isDeleting.value = true;
        
        final success = await _projectService.deleteProject(project.value.id);
        isDeleting.value = false;
        
        if (success) {
          myProjectsController.fetchMyProjects();
          Get.back(); // return from details
          Get.snackbar(
            'تم الحذف',
            'تم حذف المشروع بنجاح',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'خطأ',
            'فشل حذف المشروع، قد يكون لديه عروض مقبولة',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      },
    );
  }
}
