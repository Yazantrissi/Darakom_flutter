import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/complaint_model.dart';
import '../../models/project_model.dart';
import '../../services/interaction_service.dart';
import '../../services/project_service.dart';

class ComplaintsController extends GetxController {
  final InteractionService _interactionService = Get.find<InteractionService>();
  final ProjectService _projectService = Get.find<ProjectService>();

  var isLoading = false.obs;
  var showForm = false.obs;
  var isProvider = false.obs;

  var pendingComplaints = <ComplaintModel>[].obs;
  var resolvedComplaints = <ComplaintModel>[].obs;
  var rejectedComplaints = <ComplaintModel>[].obs;

  var linkedProjects = <ProjectModel>[].obs;
  var uniqueProviders = <Map<String, dynamic>>[].obs;
  var uniqueClients = <Map<String, dynamic>>[].obs;
  var filteredProjects = <ProjectModel>[].obs;

  var selectedProviderId = Rxn<int>();
  var selectedClientId = Rxn<int>();
  var selectedProjectId = Rxn<int>();
  final TextEditingController descriptionController = TextEditingController();

  String? prefillProviderName;
  String? prefillProjectTitle;
  String? prefillClientName;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    isProvider.value = prefs.getString('user_type') == 'provider';
    await fetchComplaints();
    await loadLinkedParties();
    _applyPrefillArgs();
  }

  void _applyPrefillArgs() {
    final args = Get.arguments;
    if (args is! Map || args['prefill'] != true) return;

    showForm.value = true;
    prefillProviderName = args['providerName']?.toString();
    prefillProjectTitle = args['projectTitle']?.toString();
    prefillClientName = args['clientName']?.toString();

    final providerId = args['providerId'];
    final clientId = args['clientId'];
    final projectId = args['projectId'];
    if (providerId != null) {
      selectedProviderId.value =
          providerId is int ? providerId : int.tryParse('$providerId');
    }
    if (clientId != null) {
      selectedClientId.value =
          clientId is int ? clientId : int.tryParse('$clientId');
    }
    if (projectId != null) {
      selectedProjectId.value =
          projectId is int ? projectId : int.tryParse('$projectId');
    }
  }

  Future<void> fetchComplaints() async {
    try {
      isLoading.value = true;
      final complaints = isProvider.value
          ? await _interactionService.fetchProviderComplaints()
          : await _interactionService.fetchClientComplaints();

      const pendingStatuses = {
        'pending_review',
        'pending',
        'open',
        'in_review',
      };

      pendingComplaints.value =
          complaints.where((c) => pendingStatuses.contains(c.status)).toList();
      resolvedComplaints.value =
          complaints.where((c) => c.status == 'resolved').toList();
      rejectedComplaints.value =
          complaints.where((c) => c.status == 'rejected').toList();
    } catch (e) {
      print("Error in fetchComplaints: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadLinkedParties() async {
    if (isProvider.value) {
      final projects = await _projectService.fetchProviderProjects();
      linkedProjects.assignAll(
        projects.where((p) =>
            p.clientId != null &&
            (p.isInProgressLifecycle || p.isCompletedLifecycle)),
      );

      final map = <int, Map<String, dynamic>>{};
      for (final p in linkedProjects) {
        final id = p.clientId!;
        map.putIfAbsent(id, () => {
              'id': id,
              'name': p.clientName ?? 'عميل',
            });
      }
      uniqueClients.assignAll(map.values.toList());

      if (selectedClientId.value != null) {
        onClientSelected(selectedClientId.value);
      }
      return;
    }

    final projects = await _projectService.fetchClientProjects();
    linkedProjects.assignAll(
      projects.where((p) =>
          p.performerUserId != null &&
          (p.isInProgressLifecycle || p.isCompletedLifecycle)),
    );

    final map = <int, Map<String, dynamic>>{};
    for (final p in linkedProjects) {
      final id = p.performerUserId!;
      map.putIfAbsent(id, () => {
            'id': id,
            'name': p.providerName ?? 'مزود خدمة',
          });
    }
    uniqueProviders.assignAll(map.values.toList());

    if (selectedProviderId.value != null) {
      onProviderSelected(selectedProviderId.value);
    }
  }

  void onProviderSelected(int? providerId) {
    selectedProviderId.value = providerId;
    selectedProjectId.value = null;
    if (providerId == null) {
      filteredProjects.clear();
      return;
    }
    filteredProjects.assignAll(
      linkedProjects.where((p) => p.performerUserId == providerId).toList(),
    );
    if (filteredProjects.length == 1) {
      selectedProjectId.value = filteredProjects.first.id;
    } else if (prefillProjectTitle != null) {
      final match = filteredProjects.firstWhereOrNull(
        (p) => p.title == prefillProjectTitle || p.id == selectedProjectId.value,
      );
      selectedProjectId.value = match?.id ?? selectedProjectId.value;
    }
  }

  void onClientSelected(int? clientId) {
    selectedClientId.value = clientId;
    selectedProjectId.value = null;
    if (clientId == null) {
      filteredProjects.clear();
      return;
    }
    filteredProjects.assignAll(
      linkedProjects.where((p) => p.clientId == clientId).toList(),
    );
    if (filteredProjects.length == 1) {
      selectedProjectId.value = filteredProjects.first.id;
    }
  }

  void openNewComplaintDialog() {
    if (isProvider.value) {
      if (uniqueClients.isEmpty) {
        Get.snackbar(
          'تنبيه',
          'لا يوجد عملاء مرتبطون بمشاريعك حالياً',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
      selectedClientId.value ??= uniqueClients.first['id'] as int?;
      onClientSelected(selectedClientId.value);
    } else {
      if (uniqueProviders.isEmpty) {
        Get.snackbar(
          'تنبيه',
          'لا يوجد مزودون مرتبطون بمشاريعك حالياً',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
      selectedProviderId.value ??= uniqueProviders.first['id'] as int?;
      onProviderSelected(selectedProviderId.value);
    }

    descriptionController.clear();

    Get.defaultDialog(
      title: 'تقديم شكوى جديدة',
      titleStyle: const TextStyle(
        fontFamily: 'Tajawal',
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.redAccent,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (prefillClientName != null)
                Text(
                  'العميل: $prefillClientName',
                  style: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                ),
              const SizedBox(height: 8),
              if (isProvider.value)
                DropdownButtonFormField<int>(
                  value: selectedClientId.value,
                  decoration: const InputDecoration(
                    labelText: 'العميل',
                    labelStyle: TextStyle(fontFamily: 'Tajawal'),
                    border: OutlineInputBorder(),
                  ),
                  items: uniqueClients
                      .map(
                        (c) => DropdownMenuItem<int>(
                          value: c['id'] as int,
                          child: Text(
                            c['name']?.toString() ?? 'عميل',
                            style: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: onClientSelected,
                )
              else
                DropdownButtonFormField<int>(
                  value: selectedProviderId.value,
                  decoration: const InputDecoration(
                    labelText: 'مزود الخدمة',
                    labelStyle: TextStyle(fontFamily: 'Tajawal'),
                    border: OutlineInputBorder(),
                  ),
                  items: uniqueProviders
                      .map(
                        (p) => DropdownMenuItem<int>(
                          value: p['id'] as int,
                          child: Text(
                            p['name']?.toString() ?? 'مزود',
                            style: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: onProviderSelected,
                ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: selectedProjectId.value,
                decoration: const InputDecoration(
                  labelText: 'المشروع',
                  labelStyle: TextStyle(fontFamily: 'Tajawal'),
                  border: OutlineInputBorder(),
                ),
                items: filteredProjects
                    .map(
                      (p) => DropdownMenuItem<int>(
                        value: p.id,
                        child: Text(
                          p.title,
                          style: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (id) => selectedProjectId.value = id,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'اشرح تفاصيل المشكلة...',
                  hintStyle: TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          );
        }),
      ),
      textConfirm: 'إرسال',
      textCancel: 'تراجع',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        Get.back();
        await submitNewComplaint();
      },
    );
  }

  Future<void> submitNewComplaint([int? projectId, String? description]) async {
    final pid = projectId ?? selectedProjectId.value;
    final text = description ?? descriptionController.text.trim();
    if (pid == null || text.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى اختيار المشروع وكتابة تفاصيل الشكوى',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    final project = linkedProjects.firstWhereOrNull((p) => p.id == pid) ??
        await _projectService.fetchProjectDetails(pid);

    final againstId = isProvider.value
        ? (selectedClientId.value ?? project?.clientId)
        : (selectedProviderId.value ?? project?.performerUserId);

    if (againstId == null) {
      isLoading.value = false;
      Get.snackbar(
        'تنبيه',
        isProvider.value
            ? 'لا يمكن تقديم شكوى حالياً، العميل غير محدد'
            : 'لا يمكن تقديم شكوى حالياً، المقاول غير محدد',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final result = await _interactionService.submitComplaint(
      projectId: pid,
      text: text,
      againstUserId: againstId,
      subject: 'شكوى على مشروع ${project?.title ?? prefillProjectTitle ?? ''}',
      asProvider: isProvider.value,
      type: isProvider.value ? 'against_client' : 'against_provider',
    );
    isLoading.value = false;

    if (result['success'] == true) {
      Get.snackbar(
        'تم الإرسال',
        result['message'] ?? 'تم رفع الشكوى للإدارة وسيتم التواصل معك قريباً',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      descriptionController.clear();
      showForm.value = false;
      selectedProviderId.value = null;
      selectedClientId.value = null;
      selectedProjectId.value = null;
      fetchComplaints();
    } else {
      Get.snackbar(
        'خطأ',
        result['message'] ?? 'فشل إرسال الشكوى، حاول مرة أخرى',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}
