import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../../models/attachment_model.dart';
import '../../models/project_model.dart';
import '../../models/province_model.dart';
import '../../models/role_model.dart';
import '../../services/project_service.dart';
import '../../services/auth_service.dart';
import '../../services/interaction_service.dart';

class AddProjectController extends GetxController {
  final ProjectService _projectService = Get.find<ProjectService>();
  final AuthService _authService = Get.find<AuthService>();

  var isEditMode = false.obs;
  var editingProjectId = 0.obs;

  var isConstructionTab = true.obs;

  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController buildingNoController = TextEditingController(text: "1");

  var provinces = <ProvinceModel>[].obs;
  var selectedProvince = Rx<ProvinceModel?>(null);

  // construction providers / specializations
  var roles = <RoleModel>[].obs;
  var selectedRole = Rx<RoleModel?>(null);

  var constructionDurationDays = 1.0.obs;

  var selectedCraftsmanType = Rx<String?>(null);
  final List<String> craftsmen = [
    'electricity', 'plumbing', 'tiling', 'ac', 'gypsum', 'solar_energy', 'painting'
  ];

  /// Urgent/normal duration mode (UI). Visibility is public|private separately.
  var tenderType = 'normal'.obs;
  /// public | private — defaults to public when UI has no toggle.
  var visibility = 'public'.obs;
  var selectedInvitedProviderId = Rx<int?>(null);
  var finishingDuration = 1.0.obs;

  var projectAttachments = <AttachmentModel>[].obs;
  var isLoading = false.obs;

  static const _craftMap = {
    'electricity': 'فني كهربا',
    'plumbing': 'فني سباكة',
    'painting': 'فني دهان',
    'tiling': 'فني بلاط',
    'ac': 'فني تكييف',
    'gypsum': 'جبس بورد',
    'solar_energy': 'فني كهربا',
  };

  int? _resolveServiceCategoryId() {
    if (isConstructionTab.value) return selectedRole.value?.id;
    final subtype = _craftMap[selectedCraftsmanType.value] ?? selectedCraftsmanType.value;
    final match = roles.firstWhereOrNull((r) => r.name == subtype);
    return match?.id ?? selectedRole.value?.id;
  }

  @override
  void onInit() {
    super.onInit();
    _fetchInitialData();
    final args = Get.arguments;
    if (args is ProjectModel) {
      initializeForEdit(args);
    } else if (args is Map) {
      // Optional private invite binding without UI changes
      final invitedId = args['invited_provider_id'] ?? args['providerId'];
      if (invitedId != null) {
        selectedInvitedProviderId.value =
            invitedId is int ? invitedId : int.tryParse('$invitedId');
        visibility.value = 'private';
      }
      if (args['visibility'] != null) {
        visibility.value = args['visibility'].toString();
      }
      addAttachment();
    } else {
      addAttachment();
    }
  }

  Future<void> _fetchInitialData() async {
    isLoading.value = true;
    try {
      final p = await _authService.fetchProvinces();
      provinces.assignAll(p);

      // Flatten nested service categories for specialization dropdown
      final cats = await Get.find<InteractionService>().fetchServiceCategories();
      roles.assignAll(_flattenServiceCategories(cats));
    } catch (e) {
      print("Error fetching initial data for project: $e");
    } finally {
      isLoading.value = false;
      if (isEditMode.value && editingProjectId.value != 0) {
        final current = Get.arguments;
        if (current is ProjectModel) {
          _bindLookupsForEdit(current);
        }
      }
    }
  }

  List<RoleModel> _flattenServiceCategories(List<dynamic> cats) {
    final result = <RoleModel>[];
    for (final e in cats) {
      if (e is! Map) continue;
      final m = Map<String, dynamic>.from(e);
      final children = m['children'] as List?;
      if (children != null && children.isNotEmpty) {
        for (final c in children) {
          if (c is! Map) continue;
          final cm = Map<String, dynamic>.from(c);
          result.add(RoleModel(
            id: cm['id'] is int ? cm['id'] : int.tryParse('${cm['id']}') ?? 0,
            name: cm['name']?.toString() ?? cm['label']?.toString() ?? '',
          ));
        }
      } else {
        result.add(RoleModel(
          id: m['id'] is int ? m['id'] : int.tryParse('${m['id']}') ?? 0,
          name: m['name']?.toString() ?? m['label']?.toString() ?? '',
        ));
      }
    }
    return result;
  }

  void initializeForEdit(ProjectModel project) {
    isEditMode.value = true;
    editingProjectId.value = project.id;

    projectNameController.text = project.title;
    descriptionController.text = project.description;
    addressController.text = project.address ?? "";
    areaController.text = project.area ?? "";
    buildingNoController.text = project.building_no ?? "1";

    isConstructionTab.value = project.work_type != 'finishing';
    visibility.value = project.visibility ?? project.tender_type ?? 'public';
    selectedInvitedProviderId.value = project.invitedProviderId;

    _bindLookupsForEdit(project);
    addAttachment();
  }

  void _bindLookupsForEdit(ProjectModel project) {
    if (project.provinceId != null && provinces.isNotEmpty) {
      selectedProvince.value =
          provinces.firstWhereOrNull((p) => p.id == project.provinceId);
    }
    if (project.serviceCategoryId != null && roles.isNotEmpty) {
      selectedRole.value =
          roles.firstWhereOrNull((r) => r.id == project.serviceCategoryId);
    }
  }

  void switchTab(bool isConstruction) {
    isConstructionTab.value = isConstruction;
  }

  void changeTenderType(String? type) {
    if (type != null) {
      // UI urgency toggle — not the same as visibility public/private
      tenderType.value = type == 'مستعجل' ? 'urgent' : 'normal';
      finishingDuration.value = 1.0;
    }
  }

  void setVisibility(String value) {
    if (value == 'public' || value == 'private') {
      visibility.value = value;
    }
  }

  void addAttachment() {
    projectAttachments.add(AttachmentModel());
  }

  void removeAttachment(int index) {
    projectAttachments[index].dispose();
    projectAttachments.removeAt(index);
  }

  Future<void> pickAttachment(int index) async {
    String? selectedType = projectAttachments[index].type.value;

    if (selectedType == null) {
      Get.snackbar('تنبيه', 'الرجاء اختيار نوع الملف أولاً', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: selectedType == 'صور' ? FileType.image : FileType.any,
        withData: kIsWeb,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        projectAttachments[index].fileName.value = file.name;
        if (kIsWeb) {
          projectAttachments[index].fileBytes.value = file.bytes;
        } else {
          projectAttachments[index].filePath.value = file.path;
        }
      }
    } catch (e) {
      print("Error picking attachment: $e");
    }
  }

  Future<void> submitProject() async {
    if (projectNameController.text.isEmpty || selectedProvince.value == null) {
      Get.snackbar('تنبيه', 'يرجى إكمال البيانات الأساسية واختيار المحافظة', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    final vis = visibility.value == 'private' ? 'private' : 'public';

    final categoryId = _resolveServiceCategoryId();
    if (categoryId == null) {
      isLoading.value = false;
      Get.snackbar('تنبيه', 'يرجى اختيار تصنيف الخدمة', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    final Map<String, dynamic> data = {
      'title': projectNameController.text,
      'service_category_id': categoryId,
      'province_id': selectedProvince.value?.id,
      'work_type': isConstructionTab.value ? 'construction' : 'finishing',
      'visibility': vis,
      'tender_type': vis,
      'location': selectedProvince.value?.name,
      'location_details':
          addressController.text.isEmpty ? "No details" : addressController.text,
      'building_no': buildingNoController.text,
      'description': descriptionController.text.isEmpty
          ? 'مساحة ${areaController.text.isEmpty ? "100" : areaController.text} م² - ${addressController.text}'
          : descriptionController.text,
      'area': int.tryParse(areaController.text) ?? 100,
      'budget': (int.tryParse(areaController.text) ?? 100) * 10000,
      'tender_duration': isConstructionTab.value
          ? constructionDurationDays.value.toInt()
          : finishingDuration.value.toInt(),
      'tender_duration_unit': tenderType.value == 'urgent' ? 'hour' : 'day',
    };

    if (vis == 'private' && selectedInvitedProviderId.value != null) {
      data['invited_provider_id'] = selectedInvitedProviderId.value;
    }

    if (!isConstructionTab.value) {
      data['craftsman_type'] = selectedCraftsmanType.value ?? 'painting';
    }

    final docs = <Map<String, dynamic>>[];
    for (final att in projectAttachments) {
      if (att.fileBytes.value != null ||
          (att.filePath.value != null && att.filePath.value!.isNotEmpty)) {
        docs.add({
          'file_path': att.filePath.value,
          'file_bytes': att.fileBytes.value,
          'file_name': att.fileName.value,
          'title': att.type.value ?? att.fileName.value,
        });
      }
    }

    final result = isEditMode.value
        ? await _projectService.updateProjectDetailed(editingProjectId.value, data)
        : await _projectService.createProjectDetailed(
            data,
            attachments: docs.isNotEmpty ? docs : null,
          );

    if (result['success']) {
      isLoading.value = false;
      Get.snackbar('تم بنجاح', result['message'] ?? 'تم حفظ المشروع بنجاح.',
          backgroundColor: Colors.green, colorText: Colors.white);
      Get.back(result: true);
    } else {
      isLoading.value = false;
      Get.snackbar('خطأ', '${result['message']}',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    projectNameController.dispose();
    descriptionController.dispose();
    areaController.dispose();
    addressController.dispose();
    buildingNoController.dispose();
    for (var attachment in projectAttachments) {
      attachment.dispose();
    }
    super.onClose();
  }
}
