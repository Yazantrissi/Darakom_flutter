import 'package:get/get.dart';
import '../../services/project_service.dart';
import '../../services/offer_service.dart';
import '../../services/profile_service.dart';
import '../../models/project_model.dart';
import '../../models/offer_model.dart';

class ProviderDashboardController extends GetxController {
  final ProjectService _projectService = Get.find<ProjectService>();
  final OfferService _offerService = Get.find<OfferService>();
  final ProfileService _profileService = Get.find<ProfileService>();

  var currentIndex = 0.obs;
  var isLoading = false.obs;

  var userName = 'مزود الخدمة'.obs;
  var fullUserName = 'اسم مزود الخدمة'.obs;
  var userEmail = 'provider@example.com'.obs;

  var stats = {
    'activeProjects': 0,
    'pendingOffers': 0,
    'totalEarnings': '0 ل.س',
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
      userName.value = user.name.split(' ').first;
      fullUserName.value = user.name;
      userEmail.value = user.email;
    }
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;

      final dashboardData = await _projectService.fetchProviderDashboard();
      final tenders = await _projectService.fetchPublicTenders();
      final projects = await _projectService.fetchProviderProjects();
      final offers = await _offerService.fetchProviderOffers();

      if (dashboardData != null) {
        stats['activeProjects'] = _asInt(dashboardData['active_projects']);
        stats['pendingOffers'] = _asInt(dashboardData['pending_offers']);
        // Lifecycle: support pending_projects key when present
        stats['pendingProjects'] = _asInt(dashboardData['pending_projects']);
        // Earnings not provided by API — keep SYP placeholder from accepted offers sum
        final acceptedSum = offers
            .where((o) => o.status == 'accepted')
            .fold<double>(0, (sum, o) => sum + o.cost);
        stats['totalEarnings'] = '${acceptedSum.toStringAsFixed(0)} ل.س';
      } else {
        stats['activeProjects'] =
            projects.where((p) => p.isInProgressLifecycle).length;
        stats['pendingOffers'] = offers.where((o) => o.status == 'pending').length;
      }

      newOpportunities.value = tenders.take(5).toList();
      activeProjects.value =
          projects.where((p) => p.isInProgressLifecycle).toList();
      myOffers.value = offers.take(5).toList();
    } catch (e) {
      print('Error fetching provider dashboard: $e');
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
}
