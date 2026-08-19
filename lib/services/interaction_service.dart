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

  Future<bool> submitComplaint(int projectId, String text) async {
    try {
      final response = await _apiService.post(
        ApiConstants.clientComplaints, 
        data: {
          'text': text,
          'project_id': projectId,
        }
      );
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

  Future<bool> submitRating(int projectId, Map<String, dynamic> data) async {
    try {
      // Backend expects 'rate' and 'comment'
      final response = await _apiService.post(
        "client/projects/$projectId/ratings", 
        data: {
          'rate': data['rating'],
          'comment': data['comment'],
        }
      );
      return response.data['success'];
    } catch (e) {
      print("Error submitting rating: $e");
      return false;
    }
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

  Future<List<UserModel>> searchProviders(String query) async {
    try {
      final response = await _apiService.get(ApiConstants.profiles, queryParameters: {'search': query});
      if (response.data['success']) {
        final List list = response.data['data']['data'] ?? []; // Handling paginated response
        return list.map((e) => UserModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error searching providers: $e");
    }
    return [];
  }
}
