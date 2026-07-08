import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA), // رمادي فاتح
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF1A2A44)),
            onPressed: () => Get.back(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'إنشاء حساب جديد',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A2A44), // كحلي عميق
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'يرجى تعبئة البيانات التالية للانضمام إلى منصة داركم',
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 24),

                // أداة التبديل العلوية (Tabs)
                _buildCustomTabBar(),
                const SizedBox(height: 24),

                // البطاقة البيضاء (Card-based layout)
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // الاسم الأول والأخير في صف واحد
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: controller.firstNameController,
                              hint: 'الاسم الأول',
                              icon: Icons.person_outline,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: controller.lastNameController,
                              hint: 'الاسم الأخير',
                              icon: Icons.person_outline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // البريد الإلكتروني
                      _buildTextField(
                        controller: controller.emailController,
                        hint: 'البريد الإلكتروني',
                        icon: Icons.email_outlined,
                        isLtr: true,
                      ),
                      const SizedBox(height: 16),

                      // الحقول الديناميكية الخاصة بمزود الخدمة
                      Obx(() => Visibility(
                        visible: !controller.isCustomerTab.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // التخصص
                            DropdownButtonFormField<String>(
                              value: controller.selectedSpecialization.value,
                              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                              style: const TextStyle(fontFamily: 'Tajawal', color: Colors.black87),
                              decoration: _buildInputDecoration(hint: 'التخصص', icon: Icons.work_outline),
                              items: controller.specializations.map((String type) {
                                return DropdownMenuItem(value: type, child: Text(type));
                              }).toList(),
                              onChanged: controller.changeSpecialization,
                            ),
                            const SizedBox(height: 16),

                            // الرقم النقابي (يظهر بعد اختيار التخصص)
                            if (controller.selectedSpecialization.value != null) ...[
                              _buildTextField(
                                controller: controller.syndicateNumberController,
                                hint: 'الرقم النقابي / رقم التسجيل',
                                icon: Icons.badge_outlined,
                                isLtr: true,
                              ),
                              const SizedBox(height: 16),
                            ],

                            // نوع الحرفة (يظهر فقط إذا كان التخصص "حرفي")
                            if (controller.selectedSpecialization.value == 'حرفي') ...[
                              DropdownButtonFormField<String>(
                                value: controller.selectedCraft.value,
                                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                style: const TextStyle(fontFamily: 'Tajawal', color: Colors.black87),
                                decoration: _buildInputDecoration(hint: 'نوع الحرفة', icon: Icons.handyman_outlined),
                                items: controller.crafts.map((String craft) {
                                  return DropdownMenuItem(value: craft, child: Text(craft));
                                }).toList(),
                                onChanged: controller.changeCraft,
                              ),
                              const SizedBox(height: 16),
                            ],

                            // زر رفع الأوراق الثبوتية
                            OutlinedButton.icon(
                              onPressed: controller.uploadDocuments,
                              icon: const Icon(Icons.upload_file, color: Color(0xFF1A2A44)),
                              label: const Text(
                                'رفع الأوراق الثبوتية',
                                style: TextStyle(fontFamily: 'Tajawal', color: Color(0xFF1A2A44), fontWeight: FontWeight.bold),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      )),

                      // كلمة المرور
                      Obx(() => TextFormField(
                        controller: controller.passwordController,
                        obscureText: controller.isPasswordHidden.value,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontFamily: 'Tajawal'),
                        decoration: _buildInputDecoration(hint: 'كلمة المرور', icon: Icons.lock_outline).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordHidden.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: Colors.grey.shade600,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        ),
                      )),
                      const SizedBox(height: 16),

                      // تأكيد كلمة المرور
                      Obx(() => TextFormField(
                        controller: controller.confirmPasswordController,
                        obscureText: controller.isConfirmPasswordHidden.value,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontFamily: 'Tajawal'),
                        decoration: _buildInputDecoration(hint: 'تأكيد كلمة المرور', icon: Icons.lock_reset_outlined).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isConfirmPasswordHidden.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: Colors.grey.shade600,
                            ),
                            onPressed: controller.toggleConfirmPasswordVisibility,
                          ),
                        ),
                      )),
                      const SizedBox(height: 16),

                      // سياسة الخصوصية
                      Obx(() => Row(
                        children: [
                          Checkbox(
                            value: controller.isPrivacyAccepted.value,
                            activeColor: const Color(0xFFF58A1E),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                            onChanged: (value) => controller.isPrivacyAccepted.value = value ?? false,
                          ),
                          const Expanded(
                            child: Text(
                              'أوافق على شروط الاستخدام وسياسة الخصوصية',
                              style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, color: Color(0xFF1A2A44)),
                            ),
                          ),
                        ],
                      )),
                      const SizedBox(height: 24),

                      // زر إنشاء حساب
                      Obx(() => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF58A1E), // البرتقالي الحيوي
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        ),
                        onPressed: controller.isLoading.value ? null : controller.register,
                        child: controller.isLoading.value
                            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : const Text(
                          'إنشاء حساب',
                          style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // تبويبات الانتقال (Toggle Tabs)
  Widget _buildCustomTabBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.switchTab(true),
              child: Obx(() => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: controller.isCustomerTab.value ? const Color(0xFF1A2A44) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  'عميل',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    color: controller.isCustomerTab.value ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.switchTab(false),
              child: Obx(() => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: !controller.isCustomerTab.value ? const Color(0xFF1A2A44) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  'مزود خدمة',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    color: !controller.isCustomerTab.value ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لإنشاء حقول النصوص
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isLtr = false,
  }) {
    return TextFormField(
      controller: controller,
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      textAlign: TextAlign.right,
      style: const TextStyle(fontFamily: 'Tajawal'),
      decoration: _buildInputDecoration(hint: hint, icon: icon),
    );
  }

  // دالة تصميم الحقول الداخلية
  InputDecoration _buildInputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontFamily: 'Tajawal', color: Colors.grey, fontSize: 14),
      hintTextDirection: TextDirection.rtl,
      prefixIcon: Icon(icon, color: Colors.grey.shade500),
      filled: true,
      fillColor: const Color(0xFFF9FAFC),
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
        borderSide: const BorderSide(color: Color(0xFF1A2A44), width: 1.5),
      ),
    );
  }
}