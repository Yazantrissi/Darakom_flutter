import 'package:get/get.dart' hide Response;
import 'api_service.dart';
import '../core/api_constants.dart';
import '../models/complaint_model.dart';
import '../models/rating_model.dart';
import '../models/user_model.dart';

class InteractionService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<List<ComplaintModel>> fetchClientComplaints() async {
    try {
      final response = await _apiService.get(ApiConstants.clientComplaints);
      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => ComplaintModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Error fetching complaints: $e");
    }
    return [];
  }

  Future<bool> submitComplaint(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(ApiConstants.clientComplaints, data: data);
      return response.data['success'];
    } catch (e) {
      print("Error submitting complaint: $e");
      return false;
    }
  }

  Future<List<RatingModel>> fetchClientRatings() async {
    try {
      final response = await _apiService.get(ApiConstants.clientRatings);
      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => RatingModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Error fetching ratings: $e");
    }
    return [];
  }

  Future<List<UserModel>> fetchFavorites() async {
    try {
      final response = await _apiService.get(ApiConstants.favorites);
      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => UserModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Error fetching favorites: $e");
    }
    return [];
  }

  Future<bool> toggleFavorite(int providerId) async {
    try {
      final response = await _apiService.post(ApiConstants.toggleFavorite, data: {'provider_id': providerId});
      return response.data['success'];
    } catch (e) {
      print("Error toggling favorite: $e");
      return false;
    }
  }
}
