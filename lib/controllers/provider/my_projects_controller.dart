import 'package:get/get.dart';
import '../../models/project_model.dart';
import '../../views/provider/add_completed_stage_screen.dart';
import '../../views/tracking/project_tracking_screen.dart';

class ProviderProjectsController extends GetxController {
  // التبويبات (مشاريع عامة = 0 / مشاريع خاصة = 1)
  var currentTabIndex = 0.obs;
  var isLoading = false.obs;

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

  void addCompletedStage(ProjectModel project) {
    Get.to(() => AddCompletedStageScreen(), arguments: {
      'projectId': project.id,
      'projectTitle': project.title,
    })?.then((val) {
      if (val == true) {
        // Refresh project list if needed
      }
    });
  }

  void viewProjectTracking(ProjectModel project) {
    Get.to(() => ProjectTrackingScreen(), arguments: {
      'projectId': project.id,
      'projectTitle': project.title,
      'isProvider': true,
    });
  }
}
