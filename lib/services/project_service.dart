import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'api_service.dart';
import '../core/api_constants.dart';
import '../models/project_model.dart';

class ProjectService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<List<ProjectModel>> fetchClientProjects() async {
    try {
      final response = await _apiService.get(ApiConstants.clientProjects);
      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => ProjectModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Error fetching client projects: $e");
    }
    return [];
  }

  Future<List<ProjectModel>> fetchPublicTenders() async {
    try {
      final response = await _apiService.get(ApiConstants.publicTenders);
      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((e) => ProjectModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Error fetching public tenders: $e");
    }
    return [];
  }

  Future<bool> createProject(Map<String, dynamic> data, {List<Map<String, dynamic>>? attachments}) async {
    final result = await createProjectDetailed(data, attachments: attachments);
    return result['success'];
  }

  Future<Map<String, dynamic>> createProjectDetailed(Map<String, dynamic> data, {List<Map<String, dynamic>>? attachments}) async {
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

      final response = await _apiService.post(ApiConstants.projects, data: formData);
      return {
        'success': response.data['success'] ?? false,
        'message': response.data['message'] ?? '',
      };
    } on DioException catch (e) {
      print("Error creating project: ${e.response?.data}");
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'خطأ في الاتصال بالسيرفر',
        'errors': e.response?.data['errors'],
      };
    } catch (e) {
      print("Error creating project: $e");
      return {
        'success': false,
        'message': 'حدث خطأ غير متوقع',
      };
    }
  }

  Future<ProjectModel?> fetchProjectDetails(int id) async {
    try {
      final response = await _apiService.get("${ApiConstants.projects}/$id");
      if (response.data['success']) {
        return ProjectModel.fromJson(response.data['data']);
      }
    } catch (e) {
      print("Error fetching project details: $e");
    }
    return null;
  }

  Future<bool> rejectInvitation(int projectId) async {
    try {
      final response = await _apiService.post("${ApiConstants.providerInvitations}/$projectId/reject");
      return response.data['success'];
    } catch (e) {
      print("Error rejecting invitation: $e");
      return false;
    }
  }

  Future<bool> completeProjectStage(int projectId, Map<String, dynamic> data, {List<Map<String, dynamic>>? attachments}) async {
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

      final response = await _apiService.post("provider/projects/$projectId/reports", data: formData);
      return response.data['success'];
    } catch (e) {
      print("Error completing stage: $e");
      return false;
    }
  }
}
