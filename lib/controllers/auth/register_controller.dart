import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
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
  final TextEditingController workAreaController = TextEditingController();

  // المتغيرات التفاعلية
  var isCustomerTab = true.obs;
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var isLoading = false.obs;
  var isPrivacyAccepted = false.obs;

  // قوائم البيانات
  var provinces = <ProvinceModel>[
    ProvinceModel(id: 1, name: 'دمشق'),
    ProvinceModel(id: 2, name: 'حلب'),
    ProvinceModel(id: 3, name: 'ريف دمشق'),
    ProvinceModel(id: 4, name: 'درعا'),
    ProvinceModel(id: 5, name: 'السويداء'),
    ProvinceModel(id: 6, name: 'القنيطرة'),
    ProvinceModel(id: 7, name: 'اللاذقية'),
    ProvinceModel(id: 8, name: 'طرطوس'),
    ProvinceModel(id: 9, name: 'إدلب'),
    ProvinceModel(id: 10, name: 'حماة'),
    ProvinceModel(id: 11, name: 'الحسكة'),
    ProvinceModel(id: 12, name: 'الرقة'),
    ProvinceModel(id: 13, name: 'دير الزور'),
    ProvinceModel(id: 14, name: 'حمص'),
  ].obs;

  var roles = <RoleModel>[
    RoleModel(id: 1, name: 'مقاول'),
    RoleModel(id: 2, name: 'مهندس معماري'),
    RoleModel(id: 3, name: 'مهندس مدني'),
    RoleModel(id: 4, name: 'مهندس مدني استشاري'),
    RoleModel(id: 5, name: 'المكاتب الهندسية'),
    RoleModel(id: 6, name: 'حرفي'),
  ].obs;

  var documentTypes = <DocumentTypeModel>[
    DocumentTypeModel(id: 1, name: 'image'),
    DocumentTypeModel(id: 2, name: 'pdf'),
  ].obs;

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
    // تم تثبيت البيانات محلياً بناءً على طلب المستخدم لتجنب مشاكل الاتصال بالباك إند
    isLoading.value = false;
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
    
    // Using simple document type selection for now
    FilePickerResult? result;

    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
      );

      if (result != null && result.files.single.path != null) {
        registerAttachments[index].fileName.value = result.files.single.name;
        registerAttachments[index].filePath.value = result.files.single.path;
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
      data['work_area'] = workAreaController.text;
      data['experience_start'] = "2020-01-01"; // Placeholder, should be picked from UI
    }

    List<Map<String, dynamic>> docs = [];
    for (var attr in registerAttachments) {
      if (attr.filePath.value != null) {
        docs.add({
          'file_path': attr.filePath.value,
          'file_name': attr.fileName.value,
          'type_id': 1, // Placeholder, should be picked from UI
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
      Get.snackbar('خطأ', 'حدث خطأ أثناء إنشاء الحساب', backgroundColor: Colors.red, colorText: Colors.white);
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
    passwordController.dispose();
    confirmPasswordController.dispose();
    syndicateNumberController.dispose();
    workAreaController.dispose();
    for (var attachment in registerAttachments) {
      attachment.dispose();
    }
    super.onClose();
  }
}
