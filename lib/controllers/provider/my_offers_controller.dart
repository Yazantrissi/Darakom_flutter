import 'package:get/get.dart';
import '../../services/offer_service.dart';
import '../../models/offer_model.dart';

class MyOffersController extends GetxController {
  final OfferService _offerService = Get.find<OfferService>();

  var currentTabIndex = 0.obs;
  var isLoading = false.obs;

  var publicOffers = <OfferModel>[].obs;
  var privateOffers = <OfferModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOffers();
  }

  Future<void> fetchOffers() async {
    isLoading.value = true;
    final allOffers = await _offerService.fetchProviderOffers();
    
    // For now, assuming status or some other field distinguishes public/private if needed
    // or just splitting for demo. In real backend, these might be separate endpoints.
    publicOffers.value = allOffers; // Defaulting all to public for now
    privateOffers.value = [];
    
    isLoading.value = false;
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  void deleteOffer(int id, bool isPublic) {
    if (isPublic) {
      publicOffers.removeWhere((element) => element.id == id);
    } else {
      privateOffers.removeWhere((element) => element.id == id);
    }
    Get.snackbar('تم الحذف', 'تم حذف العرض بنجاح', snackPosition: SnackPosition.BOTTOM);
  }
}
