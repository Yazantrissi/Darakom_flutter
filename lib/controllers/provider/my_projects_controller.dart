import 'package:get/get.dart';
import '../../models/project_model.dart';
import '../../services/project_service.dart';
import '../../views/provider/add_completed_stage_screen.dart';
import '../../views/tracking/project_tracking_screen.dart';

class ProviderProjectsController extends GetxController {
  final ProjectService _projectService = Get.find<ProjectService>();

  var currentTabIndex = 0.obs;
  var isLoading = false.obs;

  final publicProjects = <ProjectModel>[].obs;
  final privateProjects = <ProjectModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    isLoading.value = true;
    try {
      final projects = await _projectService.fetchProviderProjects();

      // Public tab: visibility public (or null) AND in_progress/completed assigned
      publicProjects.assignAll(
        projects
            .where((p) =>
                p.isPublicVisibility &&
                (p.isInProgressLifecycle || p.isCompletedLifecycle))
            .toList(),
      );

      // Private tab: visibility private
      privateProjects.assignAll(
        projects.where((p) => p.isPrivateVisibility).toList(),
      );
    } catch (e) {
      print('Error fetching provider projects: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  void addCompletedStage(ProjectModel project) {
    Get.to(() => AddCompletedStageScreen(), arguments: {
      'projectId': project.id,
      'projectTitle': project.title,
    })?.then((val) {
      if (val == true) fetchProjects();
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
