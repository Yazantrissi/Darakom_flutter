import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api_constants.dart';
import '../core/api_response.dart';
import '../views/auth/login_screen.dart';

class ApiService extends GetxService {
  late final Dio _dio;
  bool _handlingUnauthorized = false;

  static const _publicPaths = {
    ApiConstants.login,
    ApiConstants.register,
    ApiConstants.forgotPassword,
    ApiConstants.resetPassword,
  };

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 60),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    if (kDebugMode) {
      debugPrint('[ApiService] baseUrl = ${ApiConstants.baseUrl}');
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['Accept'] = 'application/json';

          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            options.headers.remove('Authorization');
          }

          if (options.data is FormData) {
            options.headers.remove('Content-Type');
            options.contentType = null;
          } else if (options.data != null) {
            options.headers['Content-Type'] = 'application/json';
          }

          return handler.next(options);
        },
        onResponse: (response, handler) async {
          if (response.statusCode == 401 &&
              !_isPublicPath(response.requestOptions.path)) {
            await _handleUnauthorized();
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          final status = e.response?.statusCode;

          if (status == 401 && !_isPublicPath(e.requestOptions.path)) {
            await _handleUnauthorized();
            return handler.next(e);
          }

          if (status != null && status >= 500) {
            return handler.next(
              DioException(
                requestOptions: e.requestOptions,
                response: e.response,
                type: e.type,
                error: e.error,
                message: ApiResponse.serverErrorMessage,
              ),
            );
          }

          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.sendTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.connectionError) {
            return handler.next(
              DioException(
                requestOptions: e.requestOptions,
                response: e.response,
                type: e.type,
                error: e.error,
                message:
                    'تعذر الاتصال بالخادم. تأكد أن Laravel يعمل على ${ApiConstants.origin}',
              ),
            );
          }

          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  bool _isPublicPath(String path) {
    final normalized = path.startsWith('/') ? path : '/$path';
    return _publicPaths.any(
      (p) => normalized == p || normalized.endsWith(p),
    );
  }

  Future<void> _handleUnauthorized() async {
    if (_handlingUnauthorized) return;
    _handlingUnauthorized = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (Get.isSnackbarOpen) Get.closeAllSnackbars();
      Get.snackbar(
        'انتهت الجلسة',
        'يرجى تسجيل الدخول مرة أخرى',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      Get.offAll(() => LoginScreen());
    } finally {
      _handlingUnauthorized = false;
    }
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }

  Future<Response> patch(String path, {dynamic data}) {
    return _dio.patch(path, data: data);
  }

  Future<Response> delete(String path, {dynamic data}) {
    return _dio.delete(path, data: data);
  }
}
