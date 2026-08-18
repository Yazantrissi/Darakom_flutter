import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../models/province_model.dart';
import '../../models/role_model.dart';
import '../../services/profile_service.dart';

class ProviderProfileController extends GetxController {
  final ProfileService _profileService = Get.find<ProfileService>();

  // أدوات التحكم بالنصوص
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final syndicateNumberController = TextEditingController();
  final experienceYearsController = TextEditingController();
  final bioController = TextEditingController();
  
  var selectedGovernorate = Rx<ProvinceModel?>(null);
  var selectedSpecialization = Rx<RoleModel?>(null);

  var isEditing = false.obs;
  var isLoading = false.obs;
  var fullUserName = "".obs;

  // قائمة البوستات (تحتاج ربط مستقبلي مع API الأعمال)
  var posts = <PostModel>[].obs;

  // قوائم الخيارات (مطابقة للتسجيل والباك إند)
  final List<ProvinceModel> provinces = [
    ProvinceModel(id: 1, name: 'دمشق'),
    ProvinceModel(id: 2, name: 'ريف دمشق'),
    ProvinceModel(id: 3, name: 'حلب'),
    ProvinceModel(id: 4, name: 'حمص'),
    ProvinceModel(id: 5, name: 'حماة'),
    ProvinceModel(id: 6, name: 'اللاذقية'),
    ProvinceModel(id: 7, name: 'طرطوس'),
    ProvinceModel(id: 8, name: 'إدلب'),
    ProvinceModel(id: 9, name: 'الرقة'),
    ProvinceModel(id: 10, name: 'دير الزور'),
    ProvinceModel(id: 11, name: 'الحسكة'),
    ProvinceModel(id: 12, name: 'درعا'),
    ProvinceModel(id: 13, name: 'السويداء'),
    ProvinceModel(id: 14, name: 'القنيطرة'),
  ];

  final List<RoleModel> specializations = [
    RoleModel(id: 1, name: 'مقاول'),
    RoleModel(id: 2, name: 'مهندس معماري'),
    RoleModel(id: 3, name: 'مهندس مدني'),
    RoleModel(id: 4, name: 'مهندس مدني استشاري'),
    RoleModel(id: 5, name: 'المكاتب الهندسية'),
    RoleModel(id: 6, name: 'حرفي'),
  ];

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    // إضافة بيانات تجريبية للبوستات حتى يتم إنشاء API خاص بها
    _loadMockPosts();
  }

  void _loadMockPosts() {
    posts.addAll([
      PostModel(
        id: '1',
        description: 'مشروع تصميم فيلا سكنية في ريف دمشق - طراز حديث',
        images: [],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      PostModel(
        id: '2',
        description: 'الإشراف على تنفيذ برج تجاري في وسط المدينة',
        images: [],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ]);
  }

  // تحميل بيانات المستخدم من الـ API
  Future<void> _loadUserData() async {
    try {
      isLoading.value = true;
      final user = await _profileService.fetchProfile();
      if (user != null) {
        fullUserName.value = user.name;
        firstNameController.text = user.firstName ?? user.name.split(' ')[0];
        lastNameController.text = user.lastName ?? (user.name.contains(' ') ? user.name.split(' ')[1] : "");
        emailController.text = user.email;
        phoneController.text = user.phone ?? "";
        syndicateNumberController.text = user.syndicateNumber ?? "";
        experienceYearsController.text = user.experienceYears?.toString() ?? "";
        bioController.text = user.bio ?? "";
        
        if (user.provinceId != null) {
          selectedGovernorate.value = provinces.firstWhereOrNull((p) => p.id == user.provinceId);
        }
        
        if (user.roleId != null) {
          selectedSpecialization.value = specializations.firstWhereOrNull((r) => r.id == user.roleId);
        }
      } else {
        Get.snackbar(
          'تنبيه',
          'فشل في جلب بيانات الملف الشخصي لمزود الخدمة.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error loading provider data: $e");
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحميل بيانات المزود.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;
  }

  Future<void> saveProfile() async {
    isLoading.value = true;
    
    final data = {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'province_id': selectedGovernorate.value?.id,
      'role_id': selectedSpecialization.value?.id,
      'syndicate_number': syndicateNumberController.text,
      'experience_years': experienceYearsController.text,
      'bio': bioController.text,
    };

    final success = await _profileService.updateProfile(data);
    
    if (success) {
      fullUserName.value = "${firstNameController.text} ${lastNameController.text}";
      isEditing.value = false;
      Get.snackbar('نجاح', 'تم تحديث بيانات البروفايل بنجاح', backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('خطأ', 'فشل في تحديث البيانات', backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
    
    isLoading.value = false;
  }

  Future<void> addPost() async {
    final TextEditingController descController = TextEditingController();
    
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('إضافة بوست جديد', style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'اكتب وصفاً للعمل أو المشروع...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  await picker.pickMultiImage();
                },
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: const Text('إضافة صور'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade100, foregroundColor: Colors.black87),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (descController.text.isNotEmpty) {
                    posts.insert(0, PostModel(
                      id: DateTime.now().toString(),
                      description: descController.text,
                      images: [],
                      createdAt: DateTime.now(),
                    ));
                    Get.back();
                    Get.snackbar('تم', 'تم نشر البوست بنجاح', backgroundColor: Colors.orange, colorText: Colors.white);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF58A1E), padding: const EdgeInsets.all(16)),
                child: const Text('نشر الآن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    syndicateNumberController.dispose();
    experienceYearsController.dispose();
    bioController.dispose();
    super.onClose();
  }
}
