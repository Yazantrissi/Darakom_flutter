import 'package:get/get.dart';
import '../../services/interaction_service.dart';
import '../../models/user_model.dart';

class FavoritesController extends GetxController {
  final InteractionService _interactionService = Get.find<InteractionService>();

  var isLoading = false.obs;
  var favoriteProviders = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    isLoading.value = true;
    favoriteProviders.value = await _interactionService.fetchFavorites();
    isLoading.value = false;
  }

  void sendDirectOffer(String providerName) {
    Get.snackbar('تقديم عرض', 'جاري الانتقال لتقديم عرض مباشر لـ "$providerName"...');
  }

  void viewProfile(String providerName) {
    Get.snackbar('الملف الشخصي', 'جاري فتح الملف الشخصي لـ "$providerName"...');
  }
}
