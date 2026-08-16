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
    final allProjects = await _projectService.fetchClientProjects();
    
    pendingProjects.value = allProjects.where((p) => p.status == 'new' || p.status == 'pending').toList();
    activeProjects.value = allProjects.where((p) => p.status == 'active').toList();
    completedProjects.value = allProjects.where((p) => p.status == 'completed').toList();
    
    isLoading.value = false;
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  void goToSearchProviders() {
    Get.to(() => SearchProvidersScreen());
  }

  void addNewProject() {
    Get.to(() => AddProjectScreen())?.then((_) => fetchDashboardData());
  }
}
