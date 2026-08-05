import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/post_model.dart';

class ProviderProfileController extends GetxController {
  // بيانات مزود الخدمة (محاكاة لما تم إدخاله عند التسجيل)
  final firstNameController = TextEditingController(text: 'محمد');
  final lastNameController = TextEditingController(text: 'العتيبي');
  final emailController = TextEditingController(text: 'm.otaibi@example.com');
  final syndicateNumberController = TextEditingController(text: 'ENG-123456');
  
  var selectedGovernorate = 'دمشق'.obs;
  var selectedSpecialization = 'مكتب هندسي'.obs;
  var selectedCraft = Rx<String?>(null);

  var isEditing = false.obs;
  var isLoading = false.obs;

  // قائمة البوستات
  var posts = <PostModel>[].obs;

  // قوائم الخيارات (نفس الموجودة في التسجيل)
  final List<String> governorates = [
    'دمشق', 'ريف دمشق', 'حلب', 'حمص', 'حماة', 'اللاذقية',
    'طرطوس', 'إدلب', 'الرقة', 'دير الزور', 'الحسكة', 'درعا',
    'السويداء', 'القنيطرة'
  ];

  final List<String> specializations = [
    'مكتب هندسي', 'مهندس مدني', 'مهندس معماري', 'استشاري', 'مقاول', 'حرفي'
  ];

  @override
  void onInit() {
    super.onInit();
    // إضافة بيانات تجريبية للبوستات
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

  void toggleEdit() {
    isEditing.value = !isEditing.value;
  }

  Future<void> saveProfile() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isEditing.value = false;
    isLoading.value = false;
    Get.snackbar('نجاح', 'تم تحديث بيانات البروفايل بنجاح', backgroundColor: Colors.green, colorText: Colors.white);
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
    syndicateNumberController.dispose();
    super.onClose();
  }
}
