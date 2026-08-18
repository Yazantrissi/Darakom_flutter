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
  
  var tenderType = 'normal'.obs; 
  var finishingDuration = 1.0.obs;

  var projectAttachments = <AttachmentModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchInitialData();
    if (Get.arguments != null && Get.arguments is ProjectModel) {
      initializeForEdit(Get.arguments as ProjectModel);
    } else {
      addAttachment();
    }
  }

  Future<void> _fetchInitialData() async {
    isLoading.value = true;
    try {
      final p = await _authService.fetchProvinces();
      provinces.assignAll(p);
      
      final r = await _authService.fetchRoles();
      roles.assignAll(r);
    } catch (e) {
      print("Error fetching initial data for project: $e");
    } finally {
      isLoading.value = false;
    }
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
    
    addAttachment();
  }

  void switchTab(bool isConstruction) {
    isConstructionTab.value = isConstruction;
  }

  void changeTenderType(String? type) {
    if (type != null) {
      tenderType.value = type == 'مستعجل' ? 'urgent' : 'normal';
      finishingDuration.value = 1.0;
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

    final Map<String, dynamic> data = {
      'title': projectNameController.text,
      'project_type_id': selectedRole.value?.id ?? 1, 
      'province_id': selectedProvince.value?.id,
      'work_type': isConstructionTab.value ? 'construction' : 'finishing',
      'tender_type': tenderType.value,
      'visibility': 'public',
      'invitation_type': 'public',
      'location_details': addressController.text.isEmpty ? "No details" : addressController.text,
      'building_no': buildingNoController.text,
      'description': descriptionController.text,
      'area': int.tryParse(areaController.text) ?? 100,
      'tender_duration': isConstructionTab.value ? constructionDurationDays.value.toInt() : finishingDuration.value.toInt(),
      'tender_duration_unit': tenderType.value == 'urgent' ? 'hour' : 'day',
    };

    if (!isConstructionTab.value) {
       data['craftsman_type'] = selectedCraftsmanType.value ?? 'painting';
    }

    List<Map<String, dynamic>> attachments = [];
    for (var attr in projectAttachments) {
      if (attr.fileBytes.value != null || attr.filePath.value != null) {
        attachments.add({
          'file_path': attr.filePath.value,
          'file_bytes': attr.fileBytes.value,
          'file_name': attr.fileName.value,
        });
      }
    }

    final result = await _projectService.createProjectDetailed(data, attachments: attachments);
    isLoading.value = false;

    if (result['success']) {
      Get.snackbar('تم بنجاح', 'تم حفظ المشروع وتحديثه.', backgroundColor: Colors.green, colorText: Colors.white);
      Get.back(result: true);
    } else {
      Get.snackbar('خطأ', 'فشل في إرسال البيانات: ${result['message']}', backgroundColor: Colors.redAccent, colorText: Colors.white);
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
