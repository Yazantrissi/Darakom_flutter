import 'package:get/get.dart' hide Response;
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

  Future<bool> createProject(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(ApiConstants.projects, data: data);
      return response.data['success'];
    } catch (e) {
      print("Error creating project: $e");
      return false;
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
}
