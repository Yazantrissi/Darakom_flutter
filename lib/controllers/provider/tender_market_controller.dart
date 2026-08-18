import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../views/provider/project_details_screen.dart';
import '../../models/project_model.dart';
import '../../services/project_service.dart';

class TenderMarketController extends GetxController {
  final ProjectService _projectService = Get.find<ProjectService>();

  // التحكم في التبويبات (عامة = 0 / خاصة = 1)
  var currentTabIndex = 0.obs;
  var isLoading = false.obs;

  // قائمة المناقصات العامة (Mock Data for demo)
  var publicTenders = <ProjectModel>[
    ProjectModel(
      id: 1001,
      title: 'بناء فيلا سكنية - دمشق',
      clientName: 'أحمد المحمد',
      location: 'المزة، دمشق',
      budget: '50,000,000 - 70,000,000 ل.س',
      publishDate: 'منذ ساعتين',
      description: '',
      status: 'new',
    ),
    ProjectModel(
      id: 1002,
      title: 'تجديد ديكور شقة - حلب',
      clientName: 'سارة خالد',
      location: 'الشهباء، حلب',
      budget: '15,000,000 ل.س',
      publishDate: 'منذ 5 ساعات',
      description: '',
      status: 'new',
    ),
  ].obs;

  // قائمة المناقصات الخاصة (الموجهة للمزود مباشرة)
  var privateTenders = <ProjectModel>[
    ProjectModel(
      id: 2001,
      title: 'تأسيس شبكة كهرباء - ريف دمشق',
      clientName: 'شركة النور العقارية',
      location: 'صحنايا، ريف دمشق',
      budget: 'اتفاق مسبق',
      publishDate: 'أمس',
      description: '',
      status: 'private',
    ),
  ].obs;

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  void viewTenderDetails(int tenderId) {
    final tender = [...publicTenders, ...privateTenders].firstWhere((element) => element.id == tenderId);
    Get.to(() => ProjectDetailsScreen(projectData: tender));
  }

  Future<void> rejectTender(int projectId) async {
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
        final success = await _projectService.rejectInvitation(projectId);
        isLoading.value = false;
        
        if (success) {
          privateTenders.removeWhere((t) => t.id == projectId);
          Get.snackbar('تم الرفض', 'تم رفض الدعوة بنجاح', backgroundColor: Colors.grey.shade800, colorText: Colors.white);
        } else {
          Get.snackbar('خطأ', 'فشل رفض الدعوة، حاول مرة أخرى', backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      },
    );
  }
}
