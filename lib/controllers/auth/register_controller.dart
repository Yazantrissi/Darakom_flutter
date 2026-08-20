import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/attachment_model.dart';
import '../../models/province_model.dart';
import '../../models/role_model.dart';
import '../../models/document_type_model.dart';
import '../../services/auth_service.dart';
import '../../views/home/client_dashboard_screen.dart';
import '../../views/provider/provider_dashboard_screen.dart';

class RegisterController extends GetxController {
  final AuthService _authService = Get.put(AuthService());

  // أدوات التحكم بالنصوص
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController syndicateNumberController = TextEditingController();

  // المتغيرات التفاعلية
  var isCustomerTab = true.obs;
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var isLoading = false.obs;
  var isInitialLoading = false.obs; // For fetching initial data
  var isPrivacyAccepted = false.obs;

  // قوائم البيانات (Empty initially, fetched from API)
  var provinces = <ProvinceModel>[].obs;
  var roles = <RoleModel>[].obs;
  var documentTypes = <DocumentTypeModel>[].obs;

  Rx<ProvinceModel?> selectedProvince = Rx<ProvinceModel?>(null);
  Rx<RoleModel?> selectedRole = Rx<RoleModel?>(null);

  // --- قائمة المرفقات الديناميكية ---
  var registerAttachments = <AttachmentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    addRegisterAttachment();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    isInitialLoading.value = true;
    try {
      final pList = await _authService.fetchProvinces();
      provinces.assignAll(pList);
      
      final rList = await _authService.fetchRoles();
      roles.assignAll(rList);
      
      final dtList = await _authService.fetchDocumentTypes();
      documentTypes.assignAll(dtList);
      
    } catch (e) {
      print("Error fetching initial data: $e");
    } finally {
      isInitialLoading.value = false;
    }
  }

  void switchTab(bool isCustomer) {
    isCustomerTab.value = isCustomer;
    selectedRole.value = null;
    syndicateNumberController.clear();
  }

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  void changeProvince(ProvinceModel? value) => selectedProvince.value = value;
  void changeRole(RoleModel? value) => selectedRole.value = value;

  // --- دوال رفع الملفات ---
  void addRegisterAttachment() {
    registerAttachments.add(AttachmentModel());
  }

  void removeRegisterAttachment(int index) {
    registerAttachments[index].dispose();
    registerAttachments.removeAt(index);
  }

  Future<void> pickRegisterAttachment(int index) async {
    if (documentTypes.isEmpty) return;
    
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
        withData: kIsWeb,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        registerAttachments[index].fileName.value = file.name;
        if (kIsWeb) {
          registerAttachments[index].fileBytes.value = file.bytes;
        } else {
          registerAttachments[index].filePath.value = file.path;
        }
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء رفع الملف', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> register() async {
    if (!_validateInput()) return;

    isLoading.value = true;

    Map<String, dynamic> data = {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'password': passwordController.text,
      'password_confirmation': confirmPasswordController.text,
      'province_id': selectedProvince.value?.id,
      'type': isCustomerTab.value ? 'client' : 'provider',
    };

    if (!isCustomerTab.value) {
      data['role_id'] = selectedRole.value?.id;
      data['experience_start'] = "2020-01-01"; // Placeholder or add UI field
      data['syndicate_number'] = syndicateNumberController.text;
    }

    List<Map<String, dynamic>> docs = [];
    for (var attr in registerAttachments) {
      if (attr.fileBytes.value != null || attr.filePath.value != null) {
        // Use the first document type as default if none selected (or map to image/pdf based on extension)
        final defaultTypeId = documentTypes.isNotEmpty ? documentTypes.first.id : 1;
        
        docs.add({
          'file_path': attr.filePath.value,
          'file_bytes': attr.fileBytes.value,
          'file_name': attr.fileName.value,
          'type_id': defaultTypeId, 
          'description': attr.titleController.text,
        });
      }
    }

    final user = await _authService.register(data, documents: docs.isEmpty ? null : docs);
    isLoading.value = false;

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      if (user.token != null) {
        await prefs.setString('token', user.token!);
      }
      await prefs.setString('user_type', user.type);

      Get.snackbar('تم بنجاح', 'تم إنشاء الحساب بنجاح', backgroundColor: Colors.green, colorText: Colors.white);
      
      if (user.type == 'provider') {
        Get.offAll(() => ProviderDashboardScreen());
      } else {
        Get.offAll(() => ClientDashboardScreen());
      }
    } else {
      Get.snackbar('خطأ', 'فشل إنشاء الحساب، يرجى التحقق من البيانات', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  bool _validateInput() {
    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty || emailController.text.isEmpty || phoneController.text.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى ملء البيانات الأساسية ورقم الموبايل', backgroundColor: Colors.orange, colorText: Colors.white);
      return false;
    }
    if (selectedProvince.value == null) {
      Get.snackbar('تنبيه', 'يرجى اختيار المحافظة', backgroundColor: Colors.orange, colorText: Colors.white);
      return false;
    }
    if (!isCustomerTab.value && selectedRole.value == null) {
       Get.snackbar('تنبيه', 'يرجى اختيار التخصص', backgroundColor: Colors.orange, colorText: Colors.white);
       return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('تنبيه', 'كلمات المرور غير متطابقة', backgroundColor: Colors.orange, colorText: Colors.white);
      return false;
    }
    if (!isPrivacyAccepted.value) {
      Get.snackbar('تنبيه', 'يجب الموافقة على سياسة الخصوصية أولاً', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    syndicateNumberController.dispose();
    for (var attachment in registerAttachments) {
      attachment.dispose();
    }
    super.onClose();
  }
}
