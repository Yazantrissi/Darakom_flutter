import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'api_service.dart';
import '../core/api_constants.dart';
import '../models/project_model.dart';
import '../models/project_report_model.dart';

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

  Future<Map<String, dynamic>?> fetchClientDashboard() async {
    try {
      final response = await _apiService.get(ApiConstants.clientDashboard);
      if (response.data['success']) {
        return response.data['data'];
      }
    } catch (e) {
      print("Error fetching client dashboard: $e");
    }
    return null;
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

  // First step: Create project without files
  Future<Map<String, dynamic>> createProjectDetailed(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(ApiConstants.projects, data: data);
      return {
        'success': response.data['success'] ?? false,
        'message': response.data['message'] ?? '',
        'data': response.data['data'],
      };
    } on DioException catch (e) {
      print("Error creating project: ${e.response?.data}");
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'خطأ في الاتصال بالسيرفر',
      };
    } catch (e) {
      return {'success': false, 'message': 'حدث خطأ غير متوقع'};
    }
  }

  // Second step: Upload documents one by one
  Future<bool> uploadProjectDocument(int projectId, Map<String, dynamic> attr) async {
    try {
      FormData formData = FormData();
      
      if (attr['file_bytes'] != null) {
        formData.files.add(MapEntry(
          "file",
          MultipartFile.fromBytes(attr['file_bytes'], filename: attr['file_name']),
        ));
      } else if (attr['file_path'] != null) {
        formData.files.add(MapEntry(
          "file",
          await MultipartFile.fromFile(attr['file_path'], filename: attr['file_name']),
        ));
      }

      formData.fields.add(MapEntry("document_type_id", attr['type_id'].toString()));
      formData.fields.add(MapEntry("description", attr['title'] ?? "Project document"));

      final response = await _apiService.post("client/projects/$projectId/documents", data: formData);
      return response.data['success'] ?? false;
    } catch (e) {
      print("Error uploading document for project $projectId: $e");
      return false;
    }
  }

  Future<List<dynamic>> fetchProjectSteps(int projectId, {required bool isProvider}) async {
    try {
      final prefix = isProvider ? "provider" : "client";
      final response = await _apiService.get("$prefix/projects/$projectId/steps");
      if (response.data['success']) {
        return response.data['data'] as List;
      }
    } catch (e) {
      print("Error fetching project steps: $e");
    }
    return [];
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

  Future<bool> deleteProject(int id) async {
    try {
      final response = await _apiService.delete("${ApiConstants.projects}/$id");
      return response.data['success'] ?? false;
    } catch (e) {
      print("Error deleting project: $e");
      return false;
    }
  }

  Future<List<ProjectReportModel>> fetchProjectReports(int projectId) async {
    try {
      final response = await _apiService.get("client/projects/$projectId/reports");
      if (response.data['success']) {
        final List list = response.data['data'] ?? [];
        return list.map((e) => ProjectReportModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error fetching reports: $e");
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> fetchProjectDocuments(int projectId) async {
    try {
      final response = await _apiService.get("client/projects/$projectId/documents");
      if (response.data['success']) {
        final List list = response.data['data'] ?? [];
        return list.map((e) => e as Map<String, dynamic>).toList();
      }
    } catch (e) {
      print("Error fetching documents: $e");
    }
    return [];
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
