import 'package:get/get.dart' hide Response;
import 'api_service.dart';
import '../core/api_constants.dart';
import '../models/complaint_model.dart';
import '../models/rating_model.dart';
import '../models/user_model.dart';
import 'package:dio/dio.dart';

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

  Future<Map<String, dynamic>> submitComplaint({
    required int projectId, 
    required String text, 
    required int againstUserId,
    String type = 'against_provider',
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.clientComplaints, 
        data: {
          'text': text,
          'project_id': projectId,
          'against_user_id': againstUserId,
          'type': type,
        }
      );
      return {
        'success': response.data['success'] ?? false,
        'message': response.data['message'] ?? 'تم إرسال الشكوى',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'فشل إرسال الشكوى',
      };
    } catch (e) {
      return {'success': false, 'message': 'حدث خطأ غير متوقع'};
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

  Future<Map<String, dynamic>> submitRating(int projectId, Map<String, dynamic> data) async {
    try {
      // Backend expects 'rate' and 'comment'
      final response = await _apiService.post(
        "client/projects/$projectId/ratings", 
        data: {
          'rate': data['rating'],
          'comment': data['comment'],
        }
      );
      return {
        'success': response.data['success'] ?? false,
        'message': response.data['message'] ?? 'تم إرسال التقييم بنجاح',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'فشل إرسال التقييم',
      };
    } catch (e) {
      return {'success': false, 'message': 'حدث خطأ غير متوقع'};
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

  Future<List<dynamic>> fetchServiceCategories() async {
    try {
      final response = await _apiService.get(ApiConstants.serviceCategories);
      if (response.data['success']) {
        return response.data['data'] as List;
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
    return [];
  }

  Future<List<UserModel>> fetchProvidersByCategory(int categoryId) async {
    try {
      final response = await _apiService.get("${ApiConstants.serviceCategories}/$categoryId");
      if (response.data['success']) {
        final List profiles = response.data['data']['profiles'] ?? [];
        return profiles.map((e) => UserModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error fetching providers by category: $e");
    }
    return [];
  }

  Future<bool> sendProjectInvitation(int projectId, int providerProfileId) async {
    try {
      final response = await _apiService.post(
        "${ApiConstants.inviteProvider}/$projectId/invitations",
        data: {'provider_profile_id': providerProfileId}
      );
      return response.data['success'];
    } catch (e) {
      print("Error sending invitation: $e");
      return false;
    }
  }

  Future<List<UserModel>> searchProviders(String query) async {
    try {
      final response = await _apiService.get(ApiConstants.profiles, queryParameters: {'search': query});
      if (response.data['success']) {
        final List list = response.data['data']['data'] ?? []; 
        return list.map((e) => UserModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error searching providers: $e");
    }
    return [];
  }
}
