import 'package:get/get.dart' hide Response;
import 'package:dio/dio.dart';
import 'api_service.dart';
import '../core/api_constants.dart';
import '../core/api_response.dart';
import '../models/complaint_model.dart';
import '../models/rating_model.dart';
import '../models/user_model.dart';

class InteractionService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<List<ComplaintModel>> fetchClientComplaints() async {
    try {
      final response = await _apiService.get(ApiConstants.clientComplaints);
      if (ApiResponse.isSuccess(response.data)) {
        final list = ApiResponse.dataOf(response.data) as List? ?? [];
        return list
            .map((e) => ComplaintModel.fromJson(Map<String, dynamic>.from(e)))
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
    String? subject,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.clientComplaints,
        data: {
          'subject': subject ?? 'شكوى على مشروع',
          'message': text,
          'against_user_id': againstUserId,
          'reported_user_id': againstUserId,
          'project_id': projectId,
          'type': type,
        },
      );
      return ApiResponse.fromBody(response.data);
    } on DioException catch (e) {
      return ApiResponse.failureFromDio(e);
    } catch (e) {
      return {
        'success': false,
        'message': 'حدث خطأ غير متوقع',
        'data': null,
        'errors': null,
      };
    }
  }

  Future<List<RatingModel>> fetchClientRatings() async {
    try {
      final response = await _apiService.get(ApiConstants.clientRatings);
      if (ApiResponse.isSuccess(response.data)) {
        final list = ApiResponse.dataOf(response.data) as List? ?? [];
        return list
            .map((e) => RatingModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      print("Error fetching ratings: $e");
    }
    return [];
  }

  Future<Map<String, dynamic>> submitRating(int projectId, Map<String, dynamic> data) async {
    try {
      final score = data['score'] ?? data['rating'] ?? data['rate'] ?? 0;
      final response = await _apiService.post(
        ApiConstants.rateProject(projectId),
        data: {
          'rating': score,
          'score': score is num ? score.round() : int.tryParse(score.toString()) ?? 0,
          'comment': data['comment'],
          if (data['reviewed_user_id'] != null) 'reviewed_user_id': data['reviewed_user_id'],
        },
      );
      return ApiResponse.fromBody(response.data);
    } on DioException catch (e) {
      return ApiResponse.failureFromDio(e);
    } catch (e) {
      return {
        'success': false,
        'message': 'حدث خطأ غير متوقع',
        'data': null,
        'errors': null,
      };
    }
  }

  Future<List<UserModel>> fetchFavorites() async {
    try {
      final response = await _apiService.get(ApiConstants.favorites);
      if (ApiResponse.isSuccess(response.data)) {
        final list = ApiResponse.dataOf(response.data) as List? ?? [];
        return list.map((e) {
          final map = Map<String, dynamic>.from(e as Map);
          final favoriteUser = map['favorite_user'];
          if (favoriteUser is Map) {
            return UserModel.fromJson(Map<String, dynamic>.from(favoriteUser));
          }
          return UserModel.fromJson(map);
        }).toList();
      }
    } catch (e) {
      print("Error fetching favorites: $e");
    }
    return [];
  }

  Future<bool> toggleFavorite(int providerId) async {
    try {
      final response = await _apiService.post(
        ApiConstants.toggleFavorite,
        data: {
          'favorite_user_id': providerId,
          'provider_id': providerId,
        },
      );
      return ApiResponse.isSuccess(response.data);
    } catch (e) {
      print("Error toggling favorite: $e");
      return false;
    }
  }

  Future<List<dynamic>> fetchServiceCategories() async {
    try {
      final response = await _apiService.get(ApiConstants.serviceCategories);
      if (ApiResponse.isSuccess(response.data)) {
        return (ApiResponse.dataOf(response.data) as List?) ?? [];
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
    return [];
  }

  Future<List<UserModel>> _fetchClientProviders({
    String? q,
    String? providerType,
    int? provinceId,
    int? categoryId,
  }) async {
    try {
      final query = <String, dynamic>{};
      if (q != null && q.trim().isNotEmpty) query['q'] = q.trim();
      if (providerType != null && providerType.isNotEmpty) {
        query['provider_type'] = providerType;
      }
      if (provinceId != null) query['province_id'] = provinceId;
      if (categoryId != null) query['category_id'] = categoryId;

      final response = await _apiService.get(
        ApiConstants.clientProviders,
        queryParameters: query.isEmpty ? null : query,
      );

      if (ApiResponse.isSuccess(response.data)) {
        final list = ApiResponse.dataOf(response.data) as List? ?? [];
        return list
            .map((e) => UserModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    } catch (e) {
      print("Error fetching client providers: $e");
    }
    return [];
  }

  Future<List<UserModel>> fetchProvidersByCategory(int categoryId) async {
    return _fetchClientProviders(categoryId: categoryId);
  }

  Future<bool> sendProjectInvitation(int projectId, int providerId) async {
    try {
      final response = await _apiService.post(
        ApiConstants.inviteProvider(projectId),
        data: {'provider_id': providerId},
      );
      return ApiResponse.isSuccess(response.data);
    } catch (e) {
      print("Error sending invitation: $e");
      return false;
    }
  }

  Future<List<UserModel>> searchProviders(String query) async {
    return _fetchClientProviders(q: query);
  }
}
