import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/profile_service.dart';
import '../../models/province_model.dart';
import 'client_dashboard_controller.dart';
import 'package:dio/dio.dart' as dio;

class ProfileController extends GetxController {
  final ProfileService _profileService = Get.find<ProfileService>();
  final ImagePicker _picker = ImagePicker();

  // أدوات التحكم بالنصوص للحقول القابلة للتعديل
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  var isLoading = false.obs;
  var fullUserName = "".obs;
  var profileImageUrl = "".obs; // URL from backend
  
  // للصورة المختارة حديثاً
  var pickedImagePath = "".obs;
  var pickedImageBytes = Rx<Uint8List?>(null);

  var selectedProvince = Rx<ProvinceModel?>(null);

  // قائمة المحافظات (نفس الموجودة في التسجيل)
  final List<ProvinceModel> provinces = [
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
  ];

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  // تحميل بيانات المستخدم من الـ API
  Future<void> _loadUserData() async {
    try {
      isLoading.value = true;
      final user = await _profileService.fetchProfile();
      if (user != null) {
        fullUserName.value = user.name;
        profileImageUrl.value = user.profilePicture ?? "";
        firstNameController.text = user.firstName ?? user.name.split(' ')[0];
        lastNameController.text = user.lastName ?? (user.name.contains(' ') ? user.name.split(' ').sublist(1).join(' ') : "");
        emailController.text = user.email;
        phoneController.text = user.phone ?? "";
        addressController.text = user.address ?? "";
        bioController.text = user.bio ?? "";
        
        if (user.provinceId != null) {
          selectedProvince.value = provinces.firstWhereOrNull((p) => p.id == user.provinceId);
        }
      } else {
        Get.snackbar(
          'تنبيه',
          'فشل في جلب بيانات الملف الشخصي. تأكد من اتصالك بالإنترنت.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error loading user data: $e");
      Get.snackbar(
        'خطأ',
        'حدث خطأ غير متوقع أثناء تحميل البيانات.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // دالة اختيار الصورة الشخصية
  Future<void> editProfilePicture() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        if (kIsWeb) {
          pickedImageBytes.value = await image.readAsBytes();
        } else {
          pickedImagePath.value = image.path;
        }
      }
    } catch (e) {
      print("Error picking image: $e");
      Get.snackbar('خطأ', 'فشل في اختيار الصورة');
    }
  }

  // دالة حفظ التغييرات وإرسالها للباك إيند
  Future<void> saveChanges() async {
    isLoading.value = true;

    final Map<String, dynamic> data = {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'address': addressController.text,
      'bio': bioController.text,
      'province_id': selectedProvince.value?.id,
    };

    // Handling multipart if image is picked
    dynamic payload;
    if (pickedImagePath.isNotEmpty || pickedImageBytes.value != null) {
      final formData = dio.FormData.fromMap(data);
      if (kIsWeb && pickedImageBytes.value != null) {
        formData.files.add(MapEntry(
          'profile_picture',
          dio.MultipartFile.fromBytes(pickedImageBytes.value!, filename: 'profile.jpg'),
        ));
      } else if (pickedImagePath.isNotEmpty) {
        formData.files.add(MapEntry(
          'profile_picture',
          await dio.MultipartFile.fromFile(pickedImagePath.value, filename: 'profile.jpg'),
        ));
      }
      payload = formData;
    } else {
      payload = data;
    }

    final success = await _profileService.updateProfile(payload);
    isLoading.value = false;

    if (success) {
      final fullName = "${firstNameController.text} ${lastNameController.text}";
      fullUserName.value = fullName;
      
      // تحديث لوحة التحكم إذا كانت موجودة ليعكس الاسم الجديد في القائمة الجانبية
      if (Get.isRegistered<ClientDashboardController>()) {
        final dashboard = Get.find<ClientDashboardController>();
        dashboard.fullUserName.value = fullName;
        dashboard.userName.value = firstNameController.text;
        dashboard.userEmail.value = emailController.text;
      }

      Get.snackbar(
        'تم الحفظ',
        'تم تحديث بيانات البروفايل بنجاح.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } else {
      Get.snackbar(
        'خطأ',
        'فشل في تحديث بيانات البروفايل.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    bioController.dispose();
    super.onClose();
  }
}
