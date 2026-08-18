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
  
  var userName = "العميل".obs;
  var fullUserName = "اسم العميل".obs;
  var userEmail = "email@example.com".obs;

  // Stats
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
      userName.value = user.name.split(' ')[0];
      fullUserName.value = user.name;
      userEmail.value = user.email;
    }
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    
    // Fetch stats and summary data
    final dashboardData = await _projectService.fetchClientDashboard();
    
    if (dashboardData != null) {
      final stats = dashboardData['stats'];
      totalProjects.value = stats['total_projects'] ?? 0;
      inProgressCount.value = stats['in_progress_count'] ?? 0;
      completedCount.value = stats['completed_count'] ?? 0;
      pendingOffersCount.value = stats['pending_offers'] ?? 0;

      final projects = dashboardData['projects'];
      
      pendingProjects.value = (projects['pending'] as List)
          .map((e) => ProjectModel.fromJson(e))
          .toList();
          
      activeProjects.value = (projects['in_progress'] as List)
          .map((e) => ProjectModel.fromJson(e))
          .toList();
          
      completedProjects.value = (projects['completed'] as List)
          .map((e) => ProjectModel.fromJson(e))
          .toList();
    }
    
    isLoading.value = false;
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
