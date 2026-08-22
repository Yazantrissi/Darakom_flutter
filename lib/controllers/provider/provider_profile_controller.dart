import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/post_model.dart';
import '../../models/province_model.dart';
import '../../models/role_model.dart';
import '../../services/profile_service.dart';
import '../../services/auth_service.dart';
import '../../services/interaction_service.dart';
import '../provider/provider_dashboard_controller.dart';

class ProviderProfileController extends GetxController {
  final ProfileService _profileService = Get.find<ProfileService>();
  final AuthService _authService = Get.find<AuthService>();
  final InteractionService _interactionService = Get.find<InteractionService>();

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
  var fullUserName = ''.obs;

  var posts = <PostModel>[].obs;
  var provinces = <ProvinceModel>[].obs;
  var specializations = <RoleModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future.wait([
      _loadLookups(),
      _loadUserData(),
      _loadPreviousWorks(),
    ]);
  }

  Future<void> _loadLookups() async {
    try {
      final p = await _authService.fetchProvinces();
      provinces.assignAll(p);

      final providerRoles = await _authService.fetchProviderTypesAsRoles();
      if (providerRoles.isNotEmpty) {
        specializations.assignAll(providerRoles);
      } else {
        final cats = await _interactionService.fetchServiceCategories();
        specializations.assignAll(_flattenCategories(cats));
      }
    } catch (e) {
      print('Error loading provider profile lookups: $e');
    }
  }

  List<RoleModel> _flattenCategories(List<dynamic> cats) {
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
            name: cm['name']?.toString() ?? '',
            providerType: m['name']?.toString(),
            craftsmanSubtype: (cm['is_craftsman_subtype'] == true)
                ? cm['name']?.toString()
                : null,
          ));
        }
      } else {
        result.add(RoleModel(
          id: m['id'] is int ? m['id'] : int.tryParse('${m['id']}') ?? 0,
          name: m['name']?.toString() ?? '',
          providerType: m['name']?.toString(),
        ));
      }
    }
    return result;
  }

  Future<void> _loadPreviousWorks() async {
    final works = await _profileService.fetchPreviousWorks();
    posts.assignAll(works);
  }

  Future<void> _loadUserData() async {
    try {
      isLoading.value = true;
      final user = await _profileService.fetchProfile();
      if (user != null) {
        fullUserName.value = user.name;
        firstNameController.text = user.firstName ?? user.name.split(' ').first;
        lastNameController.text = user.lastName ??
            (user.name.contains(' ') ? user.name.split(' ').sublist(1).join(' ') : '');
        emailController.text = user.email;
        phoneController.text = user.phone ?? '';
        syndicateNumberController.text = user.syndicateNumber ?? '';
        experienceYearsController.text = user.experienceYears?.toString() ?? '';
        bioController.text = user.bio ?? '';

        if (user.city != null && user.city!.isNotEmpty) {
          selectedGovernorate.value =
              provinces.firstWhereOrNull((p) => p.name == user.city);
        } else if (user.provinceId != null) {
          selectedGovernorate.value =
              provinces.firstWhereOrNull((p) => p.id == user.provinceId);
        }

        if (user.providerType != null && user.providerType!.isNotEmpty) {
          selectedSpecialization.value = specializations.firstWhereOrNull(
            (r) =>
                r.craftsmanSubtype == user.craftsmanSubtype ||
                r.providerType == user.providerType ||
                r.name == user.providerType ||
                r.name == user.craftsmanSubtype,
          );
        } else if (user.specialty != null && user.specialty!.isNotEmpty) {
          selectedSpecialization.value =
              specializations.firstWhereOrNull((r) => r.name == user.specialty);
        } else if (user.roleId != null) {
          selectedSpecialization.value =
              specializations.firstWhereOrNull((r) => r.id == user.roleId);
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
      print('Error loading provider data: $e');
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

    final spec = selectedSpecialization.value;
    final data = {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'name': '${firstNameController.text} ${lastNameController.text}'.trim(),
      'phone': phoneController.text,
      'city': selectedGovernorate.value?.name,
      'province_id': selectedGovernorate.value?.id,
      'specialty': spec?.name,
      'provider_type': spec?.providerType ?? spec?.name,
      if (spec?.craftsmanSubtype != null)
        'craftsman_subtype': spec!.craftsmanSubtype,
      'syndicate_number': syndicateNumberController.text,
      'experience_years': experienceYearsController.text,
      'bio': bioController.text,
    };

    final result = await _profileService.updateProfile(data);

    if (result['success'] == true) {
      fullUserName.value = '${firstNameController.text} ${lastNameController.text}';
      isEditing.value = false;

      if (Get.isRegistered<ProviderDashboardController>()) {
        final dash = Get.find<ProviderDashboardController>();
        dash.fullUserName.value = fullUserName.value;
        dash.userName.value = firstNameController.text;
        dash.userEmail.value = emailController.text;
      }

      Get.snackbar(
        'نجاح',
        result['message']?.toString().isNotEmpty == true
            ? result['message']
            : 'تم تحديث بيانات البروفايل بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'خطأ',
        result['message'] ?? 'فشل في تحديث البيانات',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }

    isLoading.value = false;
  }

  Future<void> addPost() async {
    final TextEditingController titleController = TextEditingController();
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
              const Text('إضافة بوست جديد',
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'عنوان العمل...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
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
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade100, foregroundColor: Colors.black87),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (descController.text.isEmpty) return;
                  Get.back();
                  isLoading.value = true;
                  final result = await _profileService.createPreviousWork(
                    title: titleController.text.isEmpty ? 'عمل سابق' : titleController.text,
                    description: descController.text,
                  );
                  isLoading.value = false;
                  if (result['success'] == true) {
                    await _loadPreviousWorks();
                    Get.snackbar('تم', result['message'] ?? 'تم نشر البوست بنجاح',
                        backgroundColor: Colors.orange, colorText: Colors.white);
                  } else {
                    Get.snackbar('خطأ', result['message'] ?? 'فشل النشر',
                        backgroundColor: Colors.redAccent, colorText: Colors.white);
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF58A1E), padding: const EdgeInsets.all(16)),
                child: const Text('نشر الآن',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
