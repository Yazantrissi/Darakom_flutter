import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/province_model.dart';
import '../../models/role_model.dart';
import '../../controllers/auth/register_controller.dart';
import '../../widgets/custom_file_upload_section.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
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
                    color: Color(0xFF1A2A44),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'يرجى تعبئة البيانات التالية للانضمام إلى منصة داركم',
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                _buildCustomTabBar(),
                const SizedBox(height: 24),
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
                      _buildTextField(
                        controller: controller.emailController,
                        hint: 'البريد الإلكتروني',
                        icon: Icons.email_outlined,
                        isLtr: true,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
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

                      // حقل اختيار المحافظة (تم نقله إلى هنا بعد تأكيد كلمة المرور)
                      Obx(() => DropdownButtonFormField<ProvinceModel>(
                        value: controller.selectedProvince.value,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                        style: const TextStyle(fontFamily: 'Tajawal', color: Colors.black87),
                        decoration: _buildInputDecoration(
                          hint: 'المحافظة',
                          icon: Icons.location_on_outlined,
                        ),
                        items: controller.provinces.map((ProvinceModel province) {
                          return DropdownMenuItem(value: province, child: Text(province.name));
                        }).toList(),
                        onChanged: (val) => controller.changeProvince(val),
                      )),
                      const SizedBox(height: 16),
                      
                      // حقل رقم الموبايل
                      TextFormField(
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontFamily: 'Tajawal'),
                        decoration: _buildInputDecoration(
                          hint: 'رقم الموبايل',
                          icon: Icons.phone_android_outlined,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Obx(() => Visibility(
                        visible: !controller.isCustomerTab.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButtonFormField<RoleModel>(
                              value: controller.selectedRole.value,
                              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                              style: const TextStyle(fontFamily: 'Tajawal', color: Colors.black87),
                              decoration: _buildInputDecoration(
                                hint: 'التخصص',
                                icon: Icons.work_outline,
                              ),
                              items: controller.roles.map((RoleModel role) {
                                return DropdownMenuItem(value: role, child: Text(role.name));
                              }).toList(),
                              onChanged: (val) => controller.changeRole(val),
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: controller.workAreaController,
                              hint: 'منطقة العمل (مثلاً: دمشق وريفها)',
                              icon: Icons.map_outlined,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: controller.syndicateNumberController,
                              hint: 'الرقم النقابي / رقم التسجيل',
                              icon: Icons.badge_outlined,
                              isLtr: true,
                            ),
                            const SizedBox(height: 16),
                            CustomFileUploadSection(
                              attachments: controller.registerAttachments,
                              onAdd: controller.addRegisterAttachment,
                              onRemove: controller.removeRegisterAttachment,
                              onPick: controller.pickRegisterAttachment,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      )),
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
                      Obx(() => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF58A1E),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isLtr = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      textAlign: TextAlign.right,
      style: const TextStyle(fontFamily: 'Tajawal'),
      decoration: _buildInputDecoration(hint: hint, icon: icon),
    );
  }

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
