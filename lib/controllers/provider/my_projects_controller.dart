import 'package:get/get.dart';
import '../../models/project_model.dart';

class ProviderProjectsController extends GetxController {
  // التبويبات (مشاريع عامة = 0 / مشاريع خاصة = 1)
  var currentTabIndex = 0.obs;

  // قائمة المشاريع العامة (Mock Data)
  final List<ProjectModel> publicProjects = [
    ProjectModel(
      id: 7001,
      title: 'فيلا حي الياسمين',
      clientName: 'محمد العتيبي',
      progressPercentage: 65,
      status: 'قيد التنفيذ',
      description: '',
    ),
    ProjectModel(
      id: 7002,
      title: 'تجديد عمارة سكنية',
      clientName: 'أحمد خالد',
      progressPercentage: 30,
      status: 'قيد التنفيذ',
      description: '',
    ),
  ].obs;

  // قائمة المشاريع الخاصة
  final List<ProjectModel> privateProjects = [
    ProjectModel(
      id: 8001,
      title: 'تصميم مكتب تجاري',
      clientName: 'شركة النور',
      progressPercentage: 85,
      status: 'قيد التنفيذ',
      description: '',
    ),
  ].obs;

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  void addCompletedStage(int projectId) {
    // محاكاة إضافة مرحلة منجزة
    Get.snackbar(
      'تحديث المشروع',
      'تم فتح واجهة إضافة مرحلة منجزة للمشروع رقم: $projectId',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void viewProjectTracking(int projectId) {
    // محاكاة عرض سير المشروع
    Get.snackbar(
      'سير المشروع',
      'سيتم الانتقال لواجهة تتبع سير العمل للمشروع رقم: $projectId',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}