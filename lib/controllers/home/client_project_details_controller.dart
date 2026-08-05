import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'my_projects_controller.dart';
import '../../views/home/client_offers_screen.dart';
import '../../views/home/add_project_screen.dart';

class ClientProjectDetailsController extends GetxController {
  var project = <String, dynamic>{}.obs;
  ClientProjectDetailsController({required Map<String, dynamic> projectData}) {
    project.value = projectData;
  }

  final MyProjectsController myProjectsController = Get.find<MyProjectsController>();

  void goToOffers() {
    Get.to(() => ClientOffersScreen());
  }

  Future<void> editProject() async {
    final result = await Get.to(() => AddProjectScreen(), arguments: project.value);
    if (result != null && result is Map<String, dynamic>) {
      project.value = result;
      project.refresh();
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
      onConfirm: () {
        myProjectsController.deletePendingProject(project.value['id']);
        Get.back(); // إغلاق الديالوج
        Get.back(); // العودة من صفحة التفاصيل
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
