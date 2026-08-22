import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../core/api_constants.dart';
import '../core/api_response.dart';
import '../models/user_model.dart';
import '../models/province_model.dart';
import '../models/role_model.dart';
import '../models/document_type_model.dart';

class AuthService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<List<ProvinceModel>> fetchProvinces() async {
    try {
      final response = await _apiService.get(ApiConstants.provinces);
      if (ApiResponse.isSuccess(response.data)) {
        final list = ApiResponse.dataOf(response.data) as List? ?? [];
        return list
            .map((e) => ProvinceModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      print("Error fetching provinces: $e");
    }
    return [];
  }

  Future<List<RoleModel>> fetchRoles() async {
    try {
      final response = await _apiService.get(ApiConstants.roles);
      if (ApiResponse.isSuccess(response.data)) {
        final list = ApiResponse.dataOf(response.data) as List? ?? [];
        return list
            .map((e) => RoleModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      print("Error fetching roles: $e");
    }
    return [];
  }

  /// Builds specialty dropdown items from GET /provider-types.
  /// Main types + craftsman subtypes (subtype rows map to provider_type=حرفي).
  Future<List<RoleModel>> fetchProviderTypesAsRoles() async {
    try {
      final response = await _apiService.get(ApiConstants.providerTypes);
      if (!ApiResponse.isSuccess(response.data)) return [];

      final data = ApiResponse.dataOf(response.data);
      if (data is! Map) return [];

      final mainTypes = (data['main_types'] as List?) ?? [];
      final subtypes = (data['craftsman_subtypes'] as List?) ?? [];
      final roles = <RoleModel>[];
      var id = 1;

      for (final t in mainTypes) {
        final name = t.toString();
        if (name == 'حرفي') {
          // Represent craftsman via subtypes in the single specialty dropdown
          continue;
        }
        roles.add(RoleModel(
          id: id++,
          name: name,
          providerType: name,
        ));
      }

      for (final s in subtypes) {
        final name = s.toString();
        roles.add(RoleModel(
          id: id++,
          name: name,
          providerType: 'حرفي',
          craftsmanSubtype: name,
        ));
      }

      return roles;
    } catch (e) {
      print("Error fetching provider types: $e");
    }
    return [];
  }

  Future<List<DocumentTypeModel>> fetchDocumentTypes() async {
    try {
      final response = await _apiService.get(ApiConstants.documentTypes);
      if (ApiResponse.isSuccess(response.data)) {
        final list = ApiResponse.dataOf(response.data) as List? ?? [];
        return list
            .map((e) => DocumentTypeModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      print("Error fetching document types: $e");
    }
    return [];
  }

  Future<void> _saveToken(String? token) async {
    if (token == null || token.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  void _showError(String message) {
    Get.snackbar(
      'خطأ',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await _apiService.post(ApiConstants.login, data: {
        'email': email,
        'password': password,
      });

      final body = ApiResponse.fromBody(response.data);
      if (body['success'] == true && body['data'] != null) {
        final user = UserModel.fromJson(Map<String, dynamic>.from(body['data']));
        await _saveToken(user.token);
        return user;
      }

      final errMsg = _errorsMessage(response.data) ??
          ApiResponse.messageOf(response.data, fallback: 'فشل تسجيل الدخول');
      _showError(errMsg);
      return null;
    } on DioException catch (e) {
      _showError(ApiResponse.extractError(e, fallback: 'فشل تسجيل الدخول'));
    } catch (e) {
      print("Login error: $e");
      _showError('فشل تسجيل الدخول');
    }
    return null;
  }

  String? _errorsMessage(dynamic data) {
    if (data is! Map) return null;
    final errors = data['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final messages = <String>[];
      errors.forEach((_, value) {
        if (value is List) {
          messages.addAll(value.map((e) => e.toString()));
        } else if (value != null) {
          messages.add(value.toString());
        }
      });
      if (messages.isNotEmpty) return messages.join('\n');
    }
    return null;
  }

  Future<UserModel?> register(
    Map<String, dynamic> data, {
    List<Map<String, dynamic>>? documents,
  }) async {
    try {
      final firstName = data['first_name']?.toString() ?? '';
      final lastName = data['last_name']?.toString() ?? '';
      final combinedName = '$firstName $lastName'.trim();
      final name = (data['name']?.toString().trim().isNotEmpty == true)
          ? data['name'].toString().trim()
          : combinedName;
      final role = (data['role'] ?? data['type'] ?? 'client').toString();

      final map = <String, dynamic>{
        'name': name,
        'email': data['email'],
        'phone': data['phone'],
        'password': data['password'],
        'password_confirmation': data['password_confirmation'],
        'role': role,
        'type': role,
      };

      if (data['city'] != null) map['city'] = data['city'];
      if (data['address'] != null) map['address'] = data['address'];
      if (data['bio'] != null) map['bio'] = data['bio'];
      if (data['specialty'] != null) map['specialty'] = data['specialty'];
      if (data['syndicate_number'] != null) {
        map['syndicate_number'] = data['syndicate_number'];
      }
      if (data['province_id'] != null) map['province_id'] = data['province_id'];
      if (data['provider_type'] != null) {
        map['provider_type'] = data['provider_type'];
      }
      if (data['craftsman_subtype'] != null) {
        map['craftsman_subtype'] = data['craftsman_subtype'];
      }

      final formData = FormData.fromMap(map);

      if (documents != null && documents.isNotEmpty) {
        final doc = documents.first;
        if (doc['type_id'] != null) {
          formData.fields.add(MapEntry('document_type_id', doc['type_id'].toString()));
        }
        if (doc['file_bytes'] != null) {
          formData.files.add(MapEntry(
            'document_file',
            MultipartFile.fromBytes(
              doc['file_bytes'],
              filename: doc['file_name'] ?? 'document.bin',
            ),
          ));
        } else if (doc['file_path'] != null) {
          formData.files.add(MapEntry(
            'document_file',
            await MultipartFile.fromFile(
              doc['file_path'],
              filename: doc['file_name'],
            ),
          ));
        }
      }

      final response = await _apiService.post(ApiConstants.register, data: formData);
      final body = ApiResponse.fromBody(response.data);

      if (body['success'] == true && body['data'] != null) {
        final user = UserModel.fromJson(Map<String, dynamic>.from(body['data']));
        await _saveToken(user.token);
        return user;
      }

      _showError(
        _errorsMessage(response.data) ??
            ApiResponse.messageOf(response.data, fallback: 'فشل إنشاء الحساب'),
      );
    } on DioException catch (e) {
      _showError(ApiResponse.extractError(e, fallback: 'فشل إنشاء الحساب'));
    } catch (e) {
      print("Registration error: $e");
      _showError('فشل إنشاء الحساب');
    }
    return null;
  }

  Future<bool> logout() async {
    try {
      final response = await _apiService.post(ApiConstants.logout);
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      return ApiResponse.isSuccess(response.data);
    } catch (e) {
      print("Logout error: $e");
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    }
    return false;
  }

  Future<bool> forgotPassword(String email) async {
    try {
      final response = await _apiService.post(
        ApiConstants.forgotPassword,
        data: {'email': email},
      );
      if (ApiResponse.isSuccess(response.data)) {
        Get.snackbar(
          'تم',
          ApiResponse.messageOf(response.data),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      }
      _showError(
        _errorsMessage(response.data) ??
            ApiResponse.messageOf(response.data, fallback: 'فشل إرسال رمز التحقق'),
      );
    } on DioException catch (e) {
      _showError(ApiResponse.extractError(e));
    } catch (e) {
      print("Forgot password error: $e");
    }
    return false;
  }

  Future<bool> resetPassword(
    String email,
    String otp,
    String password,
    String passwordConfirmation,
  ) async {
    try {
      final response = await _apiService.post(ApiConstants.resetPassword, data: {
        'email': email,
        'otp': otp,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });
      if (ApiResponse.isSuccess(response.data)) {
        Get.snackbar(
          'تم بنجاح',
          ApiResponse.messageOf(response.data),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      }
      _showError(
        _errorsMessage(response.data) ??
            ApiResponse.messageOf(response.data, fallback: 'فشل إعادة تعيين كلمة المرور'),
      );
    } on DioException catch (e) {
      _showError(ApiResponse.extractError(e, fallback: 'فشل إعادة تعيين كلمة المرور'));
    } catch (e) {
      print("Reset password error: $e");
    }
    return false;
  }

  Future<bool> changePassword(
    String currentPassword,
    String password,
    String passwordConfirmation,
  ) async {
    try {
      final response = await _apiService.post(ApiConstants.changePassword, data: {
        'current_password': currentPassword,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });
      if (ApiResponse.isSuccess(response.data)) {
        Get.snackbar(
          'تم بنجاح',
          ApiResponse.messageOf(response.data),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      }
      _showError(
        _errorsMessage(response.data) ??
            ApiResponse.messageOf(response.data, fallback: 'فشل تغيير كلمة المرور'),
      );
    } on DioException catch (e) {
      _showError(ApiResponse.extractError(e, fallback: 'فشل تغيير كلمة المرور'));
    } catch (e) {
      print("Change password error: $e");
    }
    return false;
  }
}
