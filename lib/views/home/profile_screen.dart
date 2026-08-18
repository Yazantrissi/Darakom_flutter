import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/profile_controller.dart';
import '../../models/province_model.dart';

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
        body: Stack(
          children: [
            Column(
              children: [
                _buildCustomHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildEditableField(
                          controller: controller.firstNameController,
                          label: 'الاسم الأول',
                        ),
                        const SizedBox(height: 16),
                        _buildEditableField(
                          controller: controller.lastNameController,
                          label: 'الاسم الأخير',
                        ),
                        const SizedBox(height: 16),
                        _buildEditableField(
                          controller: controller.emailController,
                          label: 'البريد الإلكتروني',
                          isLtr: true,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        _buildEditableField(
                          controller: controller.phoneController,
                          label: 'رقم الهاتف',
                          isLtr: true,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        _buildProvinceDropdown(),
                        const SizedBox(height: 16),
                        _buildEditableField(
                          controller: controller.addressController,
                          label: 'العنوان',
                        ),
                        const SizedBox(height: 16),
                        _buildEditableField(
                          controller: controller.bioController,
                          label: 'Bio',
                          maxLines: 4,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: orangeColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onPressed: () => controller.saveChanges(),
                          child: const Text(
                            'حفظ التغييرات',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Loading Overlay
            Obx(() => controller.isLoading.value 
              ? Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ) 
              : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
                  onPressed: () => Get.back(),
                ),
              ),
              const Text(
                'البروفايل',
                style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 32),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: navyColor,
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(color: orangeColor, width: 2.5),
                ),
                child: const Center(
                  child: Icon(Icons.person_outline_rounded, color: Colors.white, size: 50),
                ),
              ),
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
                      border: Border.all(color: navyColor, width: 2),
                    ),
                    child: const Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
            controller.fullUserName.value.isEmpty ? 'جاري التحميل...' : controller.fullUserName.value,
            style: const TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          )),
        ],
      ),
    );
  }

  Widget _buildProvinceDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المحافظة',
          style: TextStyle(
            fontFamily: 'Tajawal',
            color: Colors.grey.shade600,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => DropdownButtonFormField<ProvinceModel>(
          value: controller.selectedProvince.value,
          icon: Icon(Icons.keyboard_arrow_down, color: orangeColor, size: 20),
          style: TextStyle(fontFamily: 'Tajawal', fontSize: 15, color: navyColor, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
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
          items: controller.provinces.map((province) {
            return DropdownMenuItem(
              value: province,
              child: Text(province.name),
            );
          }).toList(),
          onChanged: (val) => controller.selectedProvince.value = val,
        )),
      ],
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String label,
    bool isLtr = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
          textAlign: TextAlign.right,
          maxLines: maxLines,
          style: TextStyle(fontFamily: 'Tajawal', fontSize: 15, color: navyColor, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
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
