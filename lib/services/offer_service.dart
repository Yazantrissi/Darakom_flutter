import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'api_service.dart';
import '../core/api_constants.dart';
import '../core/api_response.dart';
import '../models/offer_model.dart';

class OfferService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  List<OfferModel> _parseOffers(dynamic data) {
    final list = data is List ? data : <dynamic>[];
    return list
        .map((e) => OfferModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<OfferModel>> fetchProviderOffers() async {
    try {
      final response = await _apiService.get(ApiConstants.providerOffers);
      if (ApiResponse.isSuccess(response.data)) {
        return _parseOffers(ApiResponse.dataOf(response.data));
      }
    } catch (e) {
      print("Error fetching provider offers: $e");
    }
    return [];
  }

  Future<List<OfferModel>> fetchProjectOffers(int projectId) async {
    try {
      final response = await _apiService.get(ApiConstants.clientProjectOffers(projectId));
      if (ApiResponse.isSuccess(response.data)) {
        return _parseOffers(ApiResponse.dataOf(response.data));
      }
    } catch (e) {
      print("Error fetching project offers: $e");
    }
    return [];
  }

  Future<List<OfferModel>> fetchClientPublicOffers() async {
    try {
      final response = await _apiService.get(ApiConstants.clientPublicOffers);
      if (ApiResponse.isSuccess(response.data)) {
        return _parseOffers(ApiResponse.dataOf(response.data));
      }
    } catch (e) {
      print("Error fetching public offers: $e");
    }
    return [];
  }

  Future<List<OfferModel>> fetchClientPrivateOffers() async {
    try {
      final response = await _apiService.get(ApiConstants.clientPrivateOffers);
      if (ApiResponse.isSuccess(response.data)) {
        return _parseOffers(ApiResponse.dataOf(response.data));
      }
    } catch (e) {
      print("Error fetching private offers: $e");
    }
    return [];
  }

  Future<bool> submitOffer(
    int projectId,
    Map<String, dynamic> data, {
    List<Map<String, dynamic>>? attachments,
  }) async {
    final result = await submitOfferDetailed(projectId, data, attachments: attachments);
    return result['success'] == true;
  }

  Future<FormData> _buildOfferFormData(
    Map<String, dynamic> payload, {
    List<Map<String, dynamic>>? attachments,
  }) async {
    final formData = FormData.fromMap(payload);

    if (payload['stages'] != null) {
      formData.fields.removeWhere((field) => field.key == 'stages');
      formData.fields.add(
        MapEntry('stages', jsonEncode(payload['stages'])),
      );
    }

    var docIndex = 0;
    for (final att in attachments ?? []) {
      final fileName = att['file_name']?.toString() ?? 'document';
      MultipartFile? multipart;

      if (att['file_bytes'] != null) {
        multipart = MultipartFile.fromBytes(
          att['file_bytes'] as List<int>,
          filename: fileName,
        );
      } else if (att['file_path'] != null && att['file_path'].toString().isNotEmpty) {
        multipart = await MultipartFile.fromFile(
          att['file_path'].toString(),
          filename: fileName,
        );
      }

      if (multipart != null) {
        formData.files.add(MapEntry('documents[]', multipart));
        final title = att['title']?.toString();
        if (title != null && title.isNotEmpty) {
          formData.fields.add(MapEntry('document_titles[$docIndex]', title));
        }
        docIndex++;
      }
    }

    return formData;
  }

  Future<Map<String, dynamic>> submitOfferDetailed(
    int projectId,
    Map<String, dynamic> data, {
    List<Map<String, dynamic>>? attachments,
  }) async {
    try {
      final amountRaw = data['amount'] ?? data['price'] ?? data['cost'] ?? 0;
      final amount = (amountRaw is num)
          ? amountRaw.round()
          : (int.tryParse(amountRaw.toString()) ?? 0);
      final deliveryDays = data['delivery_days'] ?? data['duration'] ?? 1;
      final notes = data['notes'] ??
          data['provider_comment'] ??
          data['details'] ??
          '';

      final payload = <String, dynamic>{
        'amount': amount,
        'delivery_days': int.tryParse(deliveryDays.toString()) ?? 1,
        if (notes != null && notes.toString().isNotEmpty) 'notes': notes.toString(),
        if (data['stages'] != null) 'stages': data['stages'],
      };

      final hasFiles = attachments != null &&
          attachments.any(
            (att) =>
                att['file_bytes'] != null ||
                (att['file_path'] != null && att['file_path'].toString().isNotEmpty),
          );
      final useMultipart = hasFiles || data['stages'] != null;

      final response = await _apiService.post(
        ApiConstants.providerSubmitOffer(projectId),
        data: useMultipart
            ? await _buildOfferFormData(payload, attachments: attachments)
            : payload,
      );
      return ApiResponse.fromBody(response.data);
    } on DioException catch (e) {
      print("Error submitting offer: ${e.response?.data}");
      return ApiResponse.failureFromDio(e);
    } catch (e) {
      print("Error submitting offer: $e");
      return {
        'success': false,
        'message': 'حدث خطأ غير متوقع',
        'data': null,
        'errors': null,
      };
    }
  }

  Future<Map<String, dynamic>> acceptOfferDetailed(int projectId, int offerId) async {
    try {
      final response = await _apiService.post(
        ApiConstants.acceptOffer(projectId, offerId),
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

  Future<bool> acceptOffer(int projectId, int offerId) async {
    final result = await acceptOfferDetailed(projectId, offerId);
    return result['success'] == true;
  }

  Future<Map<String, dynamic>> rejectOfferDetailed(int projectId, int offerId) async {
    try {
      final response = await _apiService.post(
        ApiConstants.rejectOffer(projectId, offerId),
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

  Future<bool> rejectOffer(int projectId, int offerId) async {
    final result = await rejectOfferDetailed(projectId, offerId);
    return result['success'] == true;
  }

  Future<bool> deleteOffer(int offerId) async {
    try {
      final response = await _apiService.delete(ApiConstants.providerOffer(offerId));
      return ApiResponse.isSuccess(response.data);
    } catch (e) {
      print("Error deleting offer: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> updateOfferDetailed(
    int offerId,
    Map<String, dynamic> data, {
    List<Map<String, dynamic>>? attachments,
  }) async {
    try {
      final amountRaw = data['amount'] ?? data['price'] ?? data['cost'] ?? 0;
      final amount = (amountRaw is num)
          ? amountRaw.round()
          : (int.tryParse(amountRaw.toString()) ?? 0);
      final deliveryDays = data['delivery_days'] ?? data['duration'] ?? 1;
      final notes = data['notes'] ??
          data['provider_comment'] ??
          data['details'] ??
          '';

      final payload = <String, dynamic>{
        'amount': amount,
        'delivery_days': int.tryParse(deliveryDays.toString()) ?? 1,
        if (notes != null && notes.toString().isNotEmpty) 'notes': notes.toString(),
        if (data['stages'] != null) 'stages': data['stages'],
        '_method': 'PUT',
      };

      final formData = await _buildOfferFormData(payload, attachments: attachments);

      final response = await _apiService.post(
        ApiConstants.providerOffer(offerId),
        data: formData,
      );
      return ApiResponse.fromBody(response.data);
    } on DioException catch (e) {
      print("Error updating offer: ${e.response?.data}");
      return ApiResponse.failureFromDio(e);
    } catch (e) {
      print("Error updating offer: $e");
      return {
        'success': false,
        'message': 'حدث خطأ غير متوقع',
        'data': null,
        'errors': null,
      };
    }
  }

  Future<OfferModel?> fetchOfferDetails(int projectId, int offerId) async {
    try {
      final response = await _apiService.get(ApiConstants.clientProjectOffers(projectId));
      if (ApiResponse.isSuccess(response.data)) {
        final list = ApiResponse.dataOf(response.data) as List? ?? [];
        for (final item in list) {
          final map = Map<String, dynamic>.from(item as Map);
          if (map['id'] == offerId || map['id']?.toString() == offerId.toString()) {
            return OfferModel.fromJson(map);
          }
        }
      }
    } catch (e) {
      print("Error fetching offer details: $e");
    }
    return null;
  }
}
