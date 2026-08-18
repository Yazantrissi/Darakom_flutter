import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/add_project_controller.dart';
import '../../models/province_model.dart';
import '../../models/role_model.dart';
import '../../widgets/custom_file_upload_section.dart';

class AddProjectScreen extends StatelessWidget {
  AddProjectScreen({super.key});

  final AddProjectController controller = Get.put(AddProjectController());

  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);
  final Color bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: navyColor,
          elevation: 0,
          title: Obx(() => Text(
            controller.isEditMode.value ? 'تعديل المشروع' : 'إضافة مشروع جديد',
            style: const TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontWeight: FontWeight.bold),
          )),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value && controller.provinces.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return Column(
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildCustomTabBar(),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: controller.isConstructionTab.value
                      ? _buildConstructionForm()
                      : _buildFinishingForm(),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.switchTab(true),
              child: Obx(() => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: controller.isConstructionTab.value ? navyColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  'إنشاء',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    color: controller.isConstructionTab.value ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
                margin: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: !controller.isConstructionTab.value ? navyColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  'تشطيب',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    color: !controller.isConstructionTab.value ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConstructionForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSharedFields(),
        const SizedBox(height: 16),

        _buildRoleDropdown(),
        const SizedBox(height: 24),

        _buildSectionTitle('مدة الطرح (بالأيام)'),
        Obx(() => _buildSlider(
          value: controller.constructionDurationDays.value,
          min: 1, max: 30,
          label: '${controller.constructionDurationDays.value.toInt()} يوم',
          onChanged: (val) => controller.constructionDurationDays.value = val,
        )),
        const SizedBox(height: 24),

        CustomFileUploadSection(
          attachments: controller.projectAttachments,
          onAdd: controller.addAttachment,
          onRemove: controller.removeAttachment,
          onPick: controller.pickAttachment,
        ),

        const SizedBox(height: 32),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildFinishingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSharedFields(),
        const SizedBox(height: 16),

        _buildCraftsmanDropdown(),
        const SizedBox(height: 16),

        _buildTenderTypeDropdown(),
        const SizedBox(height: 24),

        Obx(() {
          bool isUrgent = controller.tenderType.value == 'urgent';
          double maxVal = isUrgent ? 15.0 : 30.0;
          String unit = isUrgent ? 'ساعة' : 'يوم';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('مدة الطرح ($unit)'),
              _buildSlider(
                value: controller.finishingDuration.value,
                min: 1, max: maxVal,
                label: '${controller.finishingDuration.value.toInt()} $unit',
                onChanged: (val) => controller.finishingDuration.value = val,
              ),
            ],
          );
        }),
        const SizedBox(height: 24),

        CustomFileUploadSection(
          attachments: controller.projectAttachments,
          onAdd: controller.addAttachment,
          onRemove: controller.removeAttachment,
          onPick: controller.pickAttachment,
        ),

        const SizedBox(height: 32),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildSharedFields() {
    return Column(
      children: [
        _buildTextField(controller: controller.projectNameController, label: 'اسم المشروع', icon: Icons.edit_note_rounded),
        const SizedBox(height: 16),
        _buildTextField(controller: controller.descriptionController, label: 'وصف المشروع', icon: Icons.description_outlined, maxLines: 3),
        const SizedBox(height: 16),
        _buildTextField(controller: controller.areaController, label: 'المساحة (متر مربع)', icon: Icons.straighten_outlined, isNumber: true),
        const SizedBox(height: 16),
        _buildProvinceDropdown(),
        const SizedBox(height: 16),
        _buildTextField(controller: controller.addressController, label: 'العنوان التفصيلي', icon: Icons.location_on_outlined),
        const SizedBox(height: 16),
        _buildTextField(controller: controller.buildingNoController, label: 'رقم البناء', icon: Icons.home_work_outlined),
      ],
    );
  }

  Widget _buildProvinceDropdown() {
    return Obx(() => DropdownButtonFormField<ProvinceModel>(
      value: controller.selectedProvince.value,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      style: TextStyle(fontFamily: 'Tajawal', color: navyColor, fontSize: 15),
      decoration: _inputDecoration('المحافظة', Icons.map_outlined),
      items: controller.provinces.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
      onChanged: (val) => controller.selectedProvince.value = val,
    ));
  }

  Widget _buildRoleDropdown() {
    return Obx(() => DropdownButtonFormField<RoleModel>(
      value: controller.selectedRole.value,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      style: TextStyle(fontFamily: 'Tajawal', color: navyColor, fontSize: 15),
      decoration: _inputDecoration('نوع المشروع / التخصص المطلب', Icons.engineering_outlined),
      items: controller.roles.map((r) => DropdownMenuItem(value: r, child: Text(r.name))).toList(),
      onChanged: (val) => controller.selectedRole.value = val,
    ));
  }

  Widget _buildCraftsmanDropdown() {
    return Obx(() => DropdownButtonFormField<String>(
      value: controller.selectedCraftsmanType.value,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      style: TextStyle(fontFamily: 'Tajawal', color: navyColor, fontSize: 15),
      decoration: _inputDecoration('اختر الحرفي المطلوب', Icons.handyman_outlined),
      items: controller.craftsmen.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
      onChanged: (val) => controller.selectedCraftsmanType.value = val,
    ));
  }

  Widget _buildTenderTypeDropdown() {
    return Obx(() => DropdownButtonFormField<String>(
      value: controller.tenderType.value == 'urgent' ? 'مستعجل' : 'عادي',
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      style: TextStyle(fontFamily: 'Tajawal', color: navyColor, fontSize: 15),
      decoration: _inputDecoration('نوع الطرح', Icons.flash_on_rounded),
      items: ['عادي', 'مستعجل'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
      onChanged: controller.changeTenderType,
    ));
  }

  Widget _buildSubmitButton() {
    return Obx(() => ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: orangeColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
      onPressed: controller.isLoading.value ? null : controller.submitProject,
      child: controller.isLoading.value
          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
          : Text(
              controller.isEditMode.value ? 'حفظ التعديلات' : 'إضافة المشروع',
              style: const TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
    ));
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: navyColor));
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      style: const TextStyle(fontFamily: 'Tajawal'),
      decoration: _inputDecoration(label, icon),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'Tajawal', color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: navyColor, width: 1.5)),
      );
  }

  Widget _buildSlider({required double value, required double min, required double max, required String label, required Function(double) onChanged}) {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            activeColor: orangeColor,
            inactiveColor: Colors.grey.shade300,
            onChanged: onChanged,
          ),
        ),
        Container(
          width: 80,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: orangeColor), borderRadius: BorderRadius.circular(8)),
          child: Text(label, style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: orangeColor)),
        ),
      ],
    );
  }
}
