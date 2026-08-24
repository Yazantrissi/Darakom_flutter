import 'package:dio/dio.dart';

class ApiResponse {
  static const String serverErrorMessage =
      'حدث خطأ في الخادم. يرجى المحاولة لاحقاً';
  static const String forbiddenMessage =
      'ليس لديك صلاحية لتنفيذ هذا الإجراء';
  static const String unauthorizedMessage =
      'غير مصرح لك بالوصول. يرجى تسجيل الدخول.';

  static bool isSuccess(dynamic body) {
    return body is Map && body['success'] == true;
  }

  static dynamic dataOf(dynamic body) {
    if (body is Map) return body['data'];
    return null;
  }

  static String messageOf(dynamic body, {String fallback = 'حدث خطأ'}) {
    if (body is Map &&
        body['message'] != null &&
        body['message'].toString().isNotEmpty) {
      return body['message'].toString();
    }
    return fallback;
  }

  /// Parses Laravel API errors: 401 / 403 / 422 / 5xx.
  static String extractError(
    DioException e, {
    String fallback = 'حدث خطأ في الاتصال بالسيرفر',
  }) {
    final status = e.response?.statusCode;

    if (status == 401) return unauthorizedMessage;
    if (status == 403) {
      final data = e.response?.data;
      if (data is Map &&
          data['message'] != null &&
          data['message'].toString().isNotEmpty) {
        return data['message'].toString();
      }
      return forbiddenMessage;
    }
    if (status != null && status >= 500) return serverErrorMessage;

    final data = e.response?.data;
    if (data is Map) {
      // 422: prefer flattened Arabic validation messages
      final fromErrors = _flattenErrors(data['errors']);
      if (fromErrors.isNotEmpty) return fromErrors;
      if (data['message'] != null && data['message'].toString().isNotEmpty) {
        return data['message'].toString();
      }
    }

    if (e.message != null && e.message!.isNotEmpty) {
      return e.message!;
    }
    return fallback;
  }

  static Map<String, dynamic> failureFromDio(DioException e) {
    final data = e.response?.data;
    return {
      'success': false,
      'message': extractError(e),
      'data': null,
      'errors': data is Map ? data['errors'] : null,
      'status': e.response?.statusCode,
    };
  }

  static Map<String, dynamic> fromBody(dynamic body) {
    if (body is Map) {
      final flattened = _flattenErrors(body['errors']);
      final message = flattened.isNotEmpty
          ? flattened
          : (body['message']?.toString() ?? '');
      return {
        'success': body['success'] == true,
        'message': message,
        'data': body['data'],
        'errors': body['errors'],
      };
    }
    return {
      'success': false,
      'message': 'استجابة غير صالحة',
      'data': null,
      'errors': null,
    };
  }

  static String _flattenErrors(dynamic errors) {
    if (errors == null) return '';
    final messages = <String>[];

    if (errors is Map) {
      errors.forEach((_, value) {
        if (value is List) {
          for (final item in value) {
            if (item != null && item.toString().isNotEmpty) {
              messages.add(item.toString());
            }
          }
        } else if (value != null && value.toString().isNotEmpty) {
          messages.add(value.toString());
        }
      });
    } else if (errors is List) {
      for (final item in errors) {
        if (item != null && item.toString().isNotEmpty) {
          messages.add(item.toString());
        }
      }
    } else if (errors.toString().isNotEmpty) {
      messages.add(errors.toString());
    }

    return messages.join('\n');
  }
}
