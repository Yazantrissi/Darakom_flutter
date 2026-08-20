import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'api_service.dart';
import '../core/api_constants.dart';
import '../models/offer_model.dart';

class OfferService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<List<OfferModel>> fetchProviderOffers() async {
    try {
      final response = await _apiService.get(ApiConstants.providerOffers);
      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => OfferModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Error fetching provider offers: $e");
    }
    return [];
  }

  Future<List<OfferModel>> fetchProjectOffers(int projectId) async {
    try {
      final response = await _apiService.get("client/projects/$projectId/offers");
      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => OfferModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Error fetching project offers: $e");
    }
    return [];
  }

  Future<List<OfferModel>> fetchClientPublicOffers() async {
    try {
      final response = await _apiService.get(ApiConstants.clientPublicOffers);
      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => OfferModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Error fetching public offers: $e");
    }
    return [];
  }

  Future<List<OfferModel>> fetchClientPrivateOffers() async {
    try {
      final response = await _apiService.get(ApiConstants.clientPrivateOffers);
      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => OfferModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Error fetching private offers: $e");
    }
    return [];
  }

  Future<bool> submitOffer(int projectId, Map<String, dynamic> data, {List<Map<String, dynamic>>? attachments}) async {
    final result = await submitOfferDetailed(projectId, data, attachments: attachments);
    return result['success'];
  }

  Future<Map<String, dynamic>> submitOfferDetailed(int projectId, Map<String, dynamic> data, {List<Map<String, dynamic>>? attachments}) async {
    try {
      FormData formData = FormData.fromMap(data);

      if (attachments != null) {
        for (var attr in attachments) {
          if (attr['file_bytes'] != null) {
             formData.files.add(MapEntry(
              "documents[]",
              MultipartFile.fromBytes(attr['file_bytes'], filename: attr['file_name']),
            ));
          } else if (attr['file_path'] != null) {
            formData.files.add(MapEntry(
              "documents[]",
              await MultipartFile.fromFile(attr['file_path'], filename: attr['file_name']),
            ));
          }
        }
      }

      final response = await _apiService.post(
        "provider/projects/$projectId/offers",
        data: formData,
      );
      return {
        'success': response.data['success'] ?? false,
        'message': response.data['message'] ?? '',
      };
    } on DioException catch (e) {
      print("Error submitting offer: ${e.response?.data}");
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'خطأ في الاتصال بالسيرفر',
      };
    } catch (e) {
      print("Error submitting offer: $e");
      return {
        'success': false,
        'message': 'حدث خطأ غير متوقع',
      };
    }
  }

  Future<bool> acceptOffer(int projectId, int offerId) async {
    try {
      final response = await _apiService.post(
        "${ApiConstants.acceptOffer}$projectId/offers/$offerId/accept",
      );
      return response.data['success'];
    } catch (e) {
      print("Error accepting offer: $e");
      return false;
    }
  }

  Future<bool> rejectOffer(int projectId, int offerId) async {
    try {
      final response = await _apiService.post(
        "${ApiConstants.rejectOffer}$projectId/offers/$offerId/reject",
      );
      return response.data['success'];
    } catch (e) {
      print("Error rejecting offer: $e");
      return false;
    }
  }

  Future<OfferModel?> fetchOfferDetails(int projectId, int offerId) async {
    try {
      final response = await _apiService.get("client/projects/$projectId/offers/$offerId");
      if (response.data['success']) {
        return OfferModel.fromJson(response.data['data']);
      }
    } catch (e) {
      print("Error fetching offer details: $e");
    }
    return null;
  }
}
