import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'api_service.dart';
import '../core/api_constants.dart';
import '../core/api_response.dart';
import '../models/project_model.dart';
import '../models/project_report_model.dart';

class ProjectService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  List<ProjectModel> _parseProjects(dynamic data) {
    final list = data is List ? data : <dynamic>[];
    return list
        .map((e) => ProjectModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<ProjectModel>> fetchClientProjects() async {
    try {
      final response = await _apiService.get(ApiConstants.clientProjects);
      if (ApiResponse.isSuccess(response.data)) {
        return _parseProjects(ApiResponse.dataOf(response.data));
      }
    } catch (e) {
      print("Error fetching client projects: $e");
    }
    return [];
  }

  Future<Map<String, dynamic>?> fetchClientDashboard() async {
    try {
      final response = await _apiService.get(ApiConstants.clientDashboard);
      if (ApiResponse.isSuccess(response.data)) {
        final data = ApiResponse.dataOf(response.data);
        if (data is Map<String, dynamic>) return data;
        if (data is Map) return Map<String, dynamic>.from(data);
      }
    } catch (e) {
      print("Error fetching client dashboard: $e");
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchProviderDashboard() async {
    try {
      final response = await _apiService.get(ApiConstants.providerDashboard);
      if (ApiResponse.isSuccess(response.data)) {
        final data = ApiResponse.dataOf(response.data);
        if (data is Map<String, dynamic>) return data;
        if (data is Map) return Map<String, dynamic>.from(data);
      }
    } catch (e) {
      print("Error fetching provider dashboard: $e");
    }
    return null;
  }

  Future<List<ProjectModel>> fetchPublicTenders() async {
    try {
      final response = await _apiService.get(ApiConstants.publicTenders);
      if (ApiResponse.isSuccess(response.data)) {
        return _parseProjects(ApiResponse.dataOf(response.data));
      }
    } catch (e) {
      print("Error fetching public tenders: $e");
    }
    return [];
  }

  Future<List<ProjectModel>> fetchPrivateTenders() async {
    try {
      final response = await _apiService.get(ApiConstants.privateTenders);
      if (ApiResponse.isSuccess(response.data)) {
        return _parseProjects(ApiResponse.dataOf(response.data));
      }
    } catch (e) {
      print("Error fetching private tenders: $e");
    }
    return [];
  }

  Future<List<ProjectModel>> fetchProviderProjects() async {
    try {
      final response = await _apiService.get(ApiConstants.providerProjects);
      if (ApiResponse.isSuccess(response.data)) {
        return _parseProjects(ApiResponse.dataOf(response.data));
      }
    } catch (e) {
      print("Error fetching provider projects: $e");
    }
    return [];
  }

  Map<String, dynamic> _normalizeProjectPayload(Map<String, dynamic> data) {
    final payload = Map<String, dynamic>.from(data);
    payload['service_category_id'] = payload['service_category_id'] ??
        payload['project_type_id'] ??
        payload['category_id'];
    if (payload['budget'] == null) {
      final area = int.tryParse(payload['area']?.toString() ?? '') ?? 100;
      payload['budget'] = area * 10000;
    } else {
      payload['budget'] = int.tryParse(payload['budget'].toString()) ?? payload['budget'];
    }
    if (payload['location'] == null) {
      payload['location'] = payload['location_details'] ?? payload['address'];
    }
    return payload;
  }

  Future<FormData> _buildProjectFormData(
    Map<String, dynamic> payload, {
    List<Map<String, dynamic>>? attachments,
  }) async {
    final formData = FormData();
    payload.forEach((key, value) {
      if (value != null) {
        formData.fields.add(MapEntry(key, value.toString()));
      }
    });

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

  Future<Map<String, dynamic>> createProjectDetailed(
    Map<String, dynamic> data, {
    List<Map<String, dynamic>>? attachments,
  }) async {
    try {
      final payload = _normalizeProjectPayload(data);
      final hasFiles = attachments != null &&
          attachments.any(
            (att) =>
                att['file_bytes'] != null ||
                (att['file_path'] != null && att['file_path'].toString().isNotEmpty),
          );

      final response = await _apiService.post(
        ApiConstants.projects,
        data: hasFiles
            ? await _buildProjectFormData(payload, attachments: attachments)
            : payload,
      );
      return ApiResponse.fromBody(response.data);
    } on DioException catch (e) {
      print("Error creating project: ${e.response?.data}");
      return ApiResponse.failureFromDio(e);
    } catch (e) {
      return {'success': false, 'message': 'حدث خطأ غير متوقع', 'data': null, 'errors': null};
    }
  }

  Future<Map<String, dynamic>> updateProjectDetailed(int id, Map<String, dynamic> data) async {
    try {
      final payload = _normalizeProjectPayload(data);
      final response = await _apiService.put(ApiConstants.projectById(id), data: payload);
      return ApiResponse.fromBody(response.data);
    } on DioException catch (e) {
      print("Error updating project: ${e.response?.data}");
      return ApiResponse.failureFromDio(e);
    } catch (e) {
      return {'success': false, 'message': 'حدث خطأ غير متوقع', 'data': null, 'errors': null};
    }
  }

  Future<bool> uploadProjectDocument(int projectId, Map<String, dynamic> attr) async {
    try {
      final formData = FormData();
      final fileName = attr['file_name']?.toString() ?? 'document';
      MultipartFile? multipart;

      if (attr['file_bytes'] != null) {
        multipart = MultipartFile.fromBytes(
          attr['file_bytes'] as List<int>,
          filename: fileName,
        );
      } else if (attr['file_path'] != null && attr['file_path'].toString().isNotEmpty) {
        multipart = await MultipartFile.fromFile(
          attr['file_path'].toString(),
          filename: fileName,
        );
      }

      if (multipart == null) return false;
      formData.files.add(MapEntry('documents[]', multipart));

      final response = await _apiService.post(
        ApiConstants.projects,
        data: formData,
      );
      return ApiResponse.isSuccess(response.data);
    } catch (e) {
      print("uploadProjectDocument failed for project $projectId: $e");
      return false;
    }
  }

  Future<List<dynamic>> fetchProjectSteps(int projectId, {required bool isProvider}) async {
    try {
      final path = isProvider
          ? ApiConstants.providerProjectSteps(projectId)
          : ApiConstants.clientProjectSteps(projectId);
      final response = await _apiService.get(path);
      if (ApiResponse.isSuccess(response.data)) {
        return (ApiResponse.dataOf(response.data) as List?) ?? [];
      }
    } catch (e) {
      print("Error fetching project steps: $e");
    }
    return [];
  }

  Future<ProjectModel> _enrichWithAcceptedOffer(ProjectModel project, int id) async {
    if (project.performerUserId != null) return project;
    try {
      final offersRes = await _apiService.get(ApiConstants.clientProjectOffers(id));
      if (!ApiResponse.isSuccess(offersRes.data)) return project;

      final list = ApiResponse.dataOf(offersRes.data) as List? ?? [];
      Map<String, dynamic>? accepted;
      for (final item in list) {
        final map = Map<String, dynamic>.from(item as Map);
        if (map['status']?.toString() == 'accepted') {
          accepted = map;
          break;
        }
      }
      if (accepted == null) return project;

      final enriched = <String, dynamic>{
        'id': project.id,
        'title': project.title,
        'description': project.description,
        'status': project.status,
        'offers_count': project.offersCount,
        'budget': project.budget,
        'location': project.address,
        'deadline': project.endDate,
        'created_at': project.publishDate,
        'service_category': project.type != null ? {'name': project.type} : null,
        'client': project.clientName != null ? {'name': project.clientName} : null,
        'invitation_id': project.invitationId,
        'provider': accepted['provider'],
        'provider_id': accepted['provider_id'] ?? accepted['provider']?['id'],
        'performer_user_id': accepted['provider_id'] ?? accepted['provider']?['id'],
      };
      return ProjectModel.fromJson(enriched);
    } catch (_) {
      return project;
    }
  }

  Future<ProjectModel?> fetchProjectDetails(int id) async {
    try {
      Response response = await _apiService.get(ApiConstants.clientProject(id));
      if (!ApiResponse.isSuccess(response.data)) {
        response = await _apiService.get(ApiConstants.providerProject(id));
      }

      if (ApiResponse.isSuccess(response.data)) {
        final raw = ApiResponse.dataOf(response.data);
        if (raw is! Map) return null;
        var project = ProjectModel.fromJson(Map<String, dynamic>.from(raw));
        project = await _enrichWithAcceptedOffer(project, id);
        return project;
      }
    } on DioException catch (e) {
      print("Error fetching project details: $e");
      try {
        final fallback = await _apiService.get(ApiConstants.providerProject(id));
        if (ApiResponse.isSuccess(fallback.data)) {
          final raw = ApiResponse.dataOf(fallback.data);
          if (raw is Map) {
            var project = ProjectModel.fromJson(Map<String, dynamic>.from(raw));
            return await _enrichWithAcceptedOffer(project, id);
          }
        }
      } catch (_) {}
    } catch (e) {
      print("Error fetching project details: $e");
    }
    return null;
  }

  Future<bool> deleteProject(int id) async {
    try {
      final response = await _apiService.delete(ApiConstants.projectById(id));
      return ApiResponse.isSuccess(response.data);
    } catch (e) {
      print("Error deleting project: $e");
      return false;
    }
  }

  Future<List<ProjectReportModel>> fetchProjectReports(
    int projectId, {
    bool isProvider = false,
  }) async {
    try {
      final path = isProvider
          ? ApiConstants.providerProjectReports(projectId)
          : ApiConstants.clientProjectReports(projectId);
      final response = await _apiService.get(path);
      if (ApiResponse.isSuccess(response.data)) {
        final list = ApiResponse.dataOf(response.data) as List? ?? [];
        return list
            .map((e) => ProjectReportModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      print("Error fetching reports: $e");
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> fetchProjectDocuments(int projectId) async {
    try {
      final project = await fetchProjectDetails(projectId);
      if (project?.attachments != null) {
        return List<Map<String, dynamic>>.from(project!.attachments!);
      }
    } catch (e) {
      print("Error fetching project documents: $e");
    }
    return [];
  }

  /// Declines a provider invitation. [invitationId] is the invitation id (not project id).
  Future<bool> rejectInvitation(int invitationId) async {
    try {
      final response = await _apiService.post(ApiConstants.declineInvitation(invitationId));
      return ApiResponse.isSuccess(response.data);
    } catch (e) {
      print("Error rejecting invitation: $e");
      return false;
    }
  }

  Future<bool> acceptInvitation(int invitationId) async {
    try {
      final response = await _apiService.post(ApiConstants.acceptInvitation(invitationId));
      return ApiResponse.isSuccess(response.data);
    } catch (e) {
      print("Error accepting invitation: $e");
      return false;
    }
  }

  Future<bool> completeProjectStage(
    int projectId,
    Map<String, dynamic> data, {
    List<Map<String, dynamic>>? attachments,
  }) async {
    try {
      final description = data['details']?.toString() ??
          data['description']?.toString() ??
          data['comment']?.toString() ??
          '';

      int? stepId = data['step_id'] ?? data['stepId'];
      if (stepId == null) {
        final steps = await fetchProjectSteps(projectId, isProvider: true);
        for (final step in steps) {
          final status = step['status']?.toString();
          if (status != 'completed') {
            stepId = step['id'] is int
                ? step['id'] as int
                : int.tryParse(step['id']?.toString() ?? '');
            break;
          }
        }
      }

      if (stepId == null) return false;

      final formData = FormData.fromMap({
        'status': 'completed',
        if (description.isNotEmpty) 'description': description,
      });

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

      final updateRes = await _apiService.put(
        '/provider/steps/$stepId',
        data: formData,
      );
      return ApiResponse.isSuccess(updateRes.data);
    } catch (e) {
      print("Error completing project stage: $e");
      return false;
    }
  }
}
