import 'package:get/get.dart';
import '../../services/api_service.dart';
import '../../services/profile_service.dart';
import '../../core/api_constants.dart';
import '../../models/project_model.dart';
import '../../models/offer_model.dart';

class ProviderDashboardController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final ProfileService _profileService = Get.find<ProfileService>();

  var currentIndex = 0.obs;
  var isLoading = false.obs;
  
  var userName = "مزود الخدمة".obs;
  var fullUserName = "اسم مزود الخدمة".obs;
  var userEmail = "provider@example.com".obs;

  var stats = {
    'activeProjects': 0,
    'pendingOffers': 0,
    'totalEarnings': '0 ر.س',
  }.obs;

  var newOpportunities = <ProjectModel>[].obs;
  var activeProjects = <ProjectModel>[].obs;
  var myOffers = <OfferModel>[].obs;

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
    try {
      isLoading.value = true;
      final response = await _apiService.get(ApiConstants.providerDashboard);
      
      if (response.data['success']) {
        final data = response.data['data'];
        stats['activeProjects'] = data['stats']['activeProjects'] ?? 0;
        stats['pendingOffers'] = data['stats']['pendingOffers'] ?? 0;
        stats['totalEarnings'] = "${data['stats']['totalEarnings'] ?? 0} ر.س";

        newOpportunities.value = (data['opportunities'] as List)
            .map((e) => ProjectModel.fromJson(e))
            .toList();
            
        activeProjects.value = (data['active_projects'] as List)
            .map((e) => ProjectModel.fromJson(e))
            .toList();
            
        myOffers.value = (data['recent_offers'] as List)
            .map((e) => OfferModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Error fetching provider dashboard: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
  }
}
