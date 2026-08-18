import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'api_service.dart';
import '../core/api_constants.dart';
import '../models/user_model.dart';
import '../models/province_model.dart';
import '../models/role_model.dart';
import '../models/document_type_model.dart';

class AuthService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<List<ProvinceModel>> fetchProvinces() async {
    try {
      final response = await _apiService.get(ApiConstants.provinces);
      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => ProvinceModel.fromJson(e))
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
      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => RoleModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Error fetching roles: $e");
    }
    return [];
  }

  Future<List<DocumentTypeModel>> fetchDocumentTypes() async {
    try {
      final response = await _apiService.get(ApiConstants.documentTypes);
      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => DocumentTypeModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Error fetching document types: $e");
    }
    return [];
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await _apiService.post(ApiConstants.login, data: {
        'email': email,
        'password': password,
      });

      if (response.data['success']) {
        return UserModel.fromJson(response.data['data']);
      }
    } catch (e) {
      print("Login error: $e");
    }
    return null;
  }

  Future<UserModel?> register(Map<String, dynamic> data, {List<Map<String, dynamic>>? documents}) async {
    try {
      FormData formData = FormData.fromMap(data);

      if (documents != null) {
        for (int i = 0; i < documents.length; i++) {
          final doc = documents[i];
          if (doc['file_bytes'] != null) {
             formData.files.add(MapEntry(
              "documents[$i][file]",
              MultipartFile.fromBytes(doc['file_bytes'], filename: doc['file_name']),
            ));
          } else if (doc['file_path'] != null) {
            formData.files.add(MapEntry(
              "documents[$i][file]",
              await MultipartFile.fromFile(doc['file_path'], filename: doc['file_name']),
            ));
          }
          formData.fields.add(MapEntry("documents[$i][type]", doc['type_id'].toString()));
          if (doc['description'] != null) {
            formData.fields.add(MapEntry("documents[$i][description]", doc['description']));
          }
        }
      }

      final response = await _apiService.post(ApiConstants.register, data: formData);

      if (response.data['success']) {
        return UserModel.fromJson(response.data['data']);
      }
    } catch (e) {
      print("Registration error: $e");
    }
    return null;
  }

  Future<bool> forgotPassword(String email) async {
    try {
      final response = await _apiService.post(ApiConstants.forgotPassword, data: {'email': email});
      if (response.data['success']) {
        Get.snackbar('تم', response.data['message'], backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      }
    } catch (e) {
      print("Forgot password error: $e");
    }
    return false;
  }

  Future<bool> resetPassword(String email, String otp, String password, String passwordConfirmation) async {
    try {
      final response = await _apiService.post(ApiConstants.resetPassword, data: {
        'email': email,
        'otp': otp,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });
      if (response.data['success']) {
        Get.snackbar('تم بنجاح', response.data['message'], backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      }
    } on DioException catch (e) {
      Get.snackbar('خطأ', e.response?.data['message'] ?? 'فشل إعادة تعيين كلمة المرور', backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      print("Reset password error: $e");
    }
    return false;
  }

  Future<bool> changePassword(String currentPassword, String password, String passwordConfirmation) async {
    try {
      final response = await _apiService.post(ApiConstants.changePassword, data: {
        'current_password': currentPassword,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });
      if (response.data['success']) {
        Get.snackbar('تم بنجاح', response.data['message'], backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      }
    } on DioException catch (e) {
      Get.snackbar('خطأ', e.response?.data['message'] ?? 'فشل تغيير كلمة المرور', backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      print("Change password error: $e");
    }
    return false;
  }
}
