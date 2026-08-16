import 'package:get/get.dart' hide Response;
import 'api_service.dart';
import '../core/api_constants.dart';
import '../models/offer_model.dart';

class OfferService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<List<OfferModel>> fetchProviderOffers() async {
    try {
      final response = await _apiService.get(ApiConstants.providerOffers);
      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => OfferModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Error fetching provider offers: $e");
    }
    return [];
  }

  Future<bool> submitOffer(int projectId, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
        "${ApiConstants.baseUrl}/provider/projects/$projectId/offers",
        data: data,
      );
      return response.data['success'];
    } catch (e) {
      print("Error submitting offer: $e");
      return false;
    }
  }
}
