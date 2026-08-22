import 'package:get/get.dart';
import '../../services/project_service.dart';
import '../../services/profile_service.dart';
import '../../models/project_model.dart';
import '../../views/home/add_project_screen.dart';
import '../../views/home/search_providers_screen.dart';

class ClientDashboardController extends GetxController {
  final ProjectService _projectService = Get.find<ProjectService>();
  final ProfileService _profileService = Get.find<ProfileService>();

  var currentIndex = 0.obs;
  var isLoading = false.obs;

  var userName = 'العميل'.obs;
  var fullUserName = 'اسم العميل'.obs;
  var userEmail = 'email@example.com'.obs;

  var totalProjects = 0.obs;
  var inProgressCount = 0.obs;
  var completedCount = 0.obs;
  var pendingOffersCount = 0.obs;

  var pendingProjects = <ProjectModel>[].obs;
  var activeProjects = <ProjectModel>[].obs;
  var completedProjects = <ProjectModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final user = await _profileService.fetchProfile();
    if (user != null) {
      userName.value = user.name.split(' ').first;
      fullUserName.value = user.name;
      userEmail.value = user.email;
    }
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      final dashboardData = await _projectService.fetchClientDashboard();
      final projects = await _projectService.fetchClientProjects();

      if (dashboardData != null) {
        totalProjects.value =
            _asInt(dashboardData['projects_count'] ?? dashboardData['total_projects']);
        inProgressCount.value = _asInt(
            dashboardData['in_progress_projects'] ?? dashboardData['in_progress_count']);
        completedCount.value =
            _asInt(dashboardData['completed_projects'] ?? dashboardData['completed_count']);
        pendingOffersCount.value = _asInt(dashboardData['pending_offers']);
      }

      pendingProjects.value = projects.where((p) => p.isPendingLifecycle).toList();
      activeProjects.value = projects.where((p) => p.isInProgressLifecycle).toList();
      completedProjects.value = projects.where((p) => p.isCompletedLifecycle).toList();

      if (dashboardData == null) {
        totalProjects.value = projects.length;
        inProgressCount.value = activeProjects.length;
        completedCount.value = completedProjects.length;
      }
    } catch (e) {
      print('Error fetching client dashboard: $e');
    } finally {
      isLoading.value = false;
    }
  }

  int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v') ?? 0;
  }

  void changePage(int index) {
    currentIndex.value = index;
    if (index == 0) fetchDashboardData();
  }

  void goToSearchProviders() {
    Get.to(() => SearchProvidersScreen());
  }

  void addNewProject() {
    Get.to(() => AddProjectScreen())?.then((_) => fetchDashboardData());
  }
}
