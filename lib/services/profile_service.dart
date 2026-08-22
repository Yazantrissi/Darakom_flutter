import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:dio/dio.dart';
import 'api_service.dart';
import '../core/api_constants.dart';
import '../core/api_response.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';

class ProfileService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<UserModel?> fetchProfile() async {
    try {
      final response = await _apiService.get(ApiConstants.profile);
      if (ApiResponse.isSuccess(response.data)) {
        final data = ApiResponse.dataOf(response.data);
        if (data is Map) {
          return UserModel.fromJson(Map<String, dynamic>.from(data));
        }
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
    return null;
  }

  /// Accepts either a Map or Dio FormData (from controllers).
  Future<Map<String, dynamic>> updateProfile(dynamic data) async {
    try {
      dynamic body;

      if (data is FormData) {
        // Controllers may send FormData with Flutter field names — clone and remap.
        final map = <String, dynamic>{};
        for (final e in data.fields) {
          map[e.key] = e.value;
        }
        _normalizeProfileFields(map);
        body = FormData.fromMap(map);
        for (final f in data.files) {
          final key = f.key == 'profile_picture' ? 'avatar_file' : f.key;
          body.files.add(MapEntry(key, f.value));
        }
      } else {
        final payload = Map<String, dynamic>.from(data as Map);
        _normalizeProfileFields(payload);

        if (payload['avatar_bytes'] != null ||
            payload['avatar_path'] != null ||
            payload['avatar_file'] is MultipartFile ||
            payload['profile_picture'] is MultipartFile) {
          final formMap = Map<String, dynamic>.from(payload)
            ..remove('avatar_bytes')
            ..remove('avatar_path')
            ..remove('avatar_file')
            ..remove('avatar_file_name')
            ..remove('profile_picture');

          final formData = FormData.fromMap(formMap);
          if (payload['avatar_bytes'] != null) {
            formData.files.add(MapEntry(
              'avatar_file',
              MultipartFile.fromBytes(
                payload['avatar_bytes'],
                filename: payload['avatar_file_name'] ?? 'avatar.jpg',
              ),
            ));
          } else if (payload['avatar_path'] != null) {
            formData.files.add(MapEntry(
              'avatar_file',
              await MultipartFile.fromFile(
                payload['avatar_path'],
                filename: payload['avatar_file_name'] ?? 'avatar.jpg',
              ),
            ));
          } else if (payload['avatar_file'] is MultipartFile) {
            formData.files.add(MapEntry('avatar_file', payload['avatar_file']));
          } else if (payload['profile_picture'] is MultipartFile) {
            formData.files.add(MapEntry('avatar_file', payload['profile_picture']));
          }
          body = formData;
        } else {
          body = payload;
        }
      }

      final response = await _apiService.put(ApiConstants.updateProfile, data: body);
      return ApiResponse.fromBody(response.data);
    } on DioException catch (e) {
      return ApiResponse.failureFromDio(e);
    } catch (e) {
      print('Error updating profile: $e');
      return {
        'success': false,
        'message': 'فشل تحديث الملف الشخصي',
        'data': null,
        'errors': null,
      };
    }
  }

  void _normalizeProfileFields(Map<String, dynamic> payload) {
    final first = payload['first_name']?.toString().trim() ?? '';
    final last = payload['last_name']?.toString().trim() ?? '';
    if ((payload['name'] == null || '${payload['name']}'.isEmpty) &&
        (first.isNotEmpty || last.isNotEmpty)) {
      payload['name'] = '$first $last'.trim();
    }

    if (payload['city'] == null && payload['province_name'] != null) {
      payload['city'] = payload['province_name'];
    }

    if (payload['specialty'] == null && payload['role_name'] != null) {
      payload['specialty'] = payload['role_name'];
    }

    if (payload['experience_years'] is String) {
      payload['experience_years'] =
          int.tryParse(payload['experience_years']) ?? payload['experience_years'];
    }

    // Drop Flutter-only keys Laravel doesn't expect
    payload.remove('first_name');
    payload.remove('last_name');
    payload.remove('province_name');
    payload.remove('role_id');
    payload.remove('role_name');
    payload.remove('email'); // email usually not updatable here
    // Keep province_id, provider_type, craftsman_subtype for provider updates
  }

  Future<List<PostModel>> fetchPreviousWorks() async {
    try {
      final response = await _apiService.get(ApiConstants.previousWorks);
      if (ApiResponse.isSuccess(response.data)) {
        final list = ApiResponse.dataOf(response.data) as List? ?? [];
        return list.map((e) {
          final m = Map<String, dynamic>.from(e as Map);
          return PostModel(
            id: m['id']?.toString() ?? '',
            description: m['description']?.toString() ?? m['title']?.toString() ?? '',
            images: m['cover_image'] != null && '${m['cover_image']}'.isNotEmpty
                ? [m['cover_image'].toString()]
                : <String>[],
            createdAt: DateTime.tryParse(m['created_at']?.toString() ?? '') ?? DateTime.now(),
          );
        }).toList();
      }
    } catch (e) {
      print('Error fetching previous works: $e');
    }
    return [];
  }

  Future<Map<String, dynamic>> createPreviousWork({
    required String title,
    required String description,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.previousWorks,
        data: {
          'title': title,
          'description': description,
        },
      );
      return ApiResponse.fromBody(response.data);
    } on DioException catch (e) {
      return ApiResponse.failureFromDio(e);
    } catch (e) {
      return {
        'success': false,
        'message': 'فشل إضافة العمل السابق',
        'data': null,
        'errors': null,
      };
    }
  }
}
