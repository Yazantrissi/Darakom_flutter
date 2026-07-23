import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  // الألوان الأساسية
  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);
  final Color bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // الواجهة من اليمين لليسار
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            // 1. الهيدر الكحلي المنحني
            _buildCustomHeader(),

            // 2. محتوى الحقول القابل للتمرير
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // حقل الاسم الأول
                    _buildEditableField(
                      controller: controller.firstNameController,
                      label: 'الاسم الأول',
                    ),
                    const SizedBox(height: 16),

                    // حقل الاسم الأخير
                    _buildEditableField(
                      controller: controller.lastNameController,
                      label: 'الاسم الأخير',
                    ),
                    const SizedBox(height: 16),

                    // حقل البريد الإلكتروني
                    _buildEditableField(
                      controller: controller.emailController,
                      label: 'البريد الإلكتروني',
                      isLtr: true,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // حقل رقم الهاتف
                    _buildEditableField(
                      controller: controller.phoneController,
                      label: 'رقم الهاتف',
                      isLtr: true,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    // حقل العنوان
                    _buildEditableField(
                      controller: controller.addressController,
                      label: 'العنوان',
                    ),
                    const SizedBox(height: 16),

                    // حقل النبذة (Bio)
                    _buildEditableField(
                      controller: controller.bioController,
                      label: 'Bio',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 32),

                    // زر حفظ التغييرات
                    Obx(() => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orangeColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: controller.isLoading.value ? null : controller.saveChanges,
                      child: controller.isLoading.value
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : const Text(
                        'حفظ التغييرات',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- دوال بناء الواجهة --- //

  // 1. الهيدر المخصص المطابق للتصميم
  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 24, left: 24, right: 24),
      decoration: BoxDecoration(
        color: navyColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
          bottomRight: Radius.circular(32.0),
        ),
      ),
      child: Column(
        children: [
          // شريط العنوان وزر العودة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // زر العودة ذو الخلفية الشفافة
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  // في الواجهات العربية يتم استخدام السهم المتجه لليمين للعودة
                  icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
                  onPressed: () => Get.back(),
                ),
              ),
              const Text(
                'البروفايل',
                style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 48), // مساحة فارغة لمعادلة مكان زر العودة وضمان توسيط العنوان
            ],
          ),
          const SizedBox(height: 32),

          // صورة المستخدم مع الإطار البرتقالي وأيقونة التعديل
          Stack(
            clipBehavior: Clip.none,
            children: [
              // حاوية الصورة
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: navyColor, // لون الخلفية مطابق للهيدر
                  borderRadius: BorderRadius.circular(24.0), // حواف ناعمة (Squircle)
                  border: Border.all(color: orangeColor, width: 2.5), // إطار برتقالي
                ),
                child: const Center(
                  child: Icon(Icons.person_outline_rounded, color: Colors.white, size: 50),
                ),
              ),
              // أيقونة القلم الدائرية
              Positioned(
                bottom: -4,
                left: -4,
                child: GestureDetector(
                  onTap: controller.editProfilePicture,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: orangeColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: navyColor, width: 2), // إطار كحلي لفصل الأيقونة
                    ),
                    child: const Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // اسم المستخدم
          const Text(
            'محمد العتيبي', // سيتم ربطها بالمتحكم لاحقاً
            style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // 2. تصميم الحقول النصية (العنوان في الأعلى، وأيقونة القلم في الداخل)
  Widget _buildEditableField({
    required TextEditingController controller,
    required String label,
    bool isLtr = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // محاذاة النص لليمين (بسبب الـ RTL)
      children: [
        // عنوان الحقل (الـ Label الموجود أعلى كل حقل)
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajawal',
            color: Colors.grey.shade600,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // مربع الإدخال
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
          textAlign: TextAlign.right, // النص يكتب من اليمين
          maxLines: maxLines,
          style: TextStyle(fontFamily: 'Tajawal', fontSize: 15, color: navyColor, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            // أيقونة القلم داخل الحقل على اليسار
            suffixIcon: Icon(Icons.edit_outlined, color: orangeColor, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: navyColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}