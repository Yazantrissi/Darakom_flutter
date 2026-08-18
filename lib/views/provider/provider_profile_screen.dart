import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/provider/provider_profile_controller.dart';
import '../../models/province_model.dart';
import '../../models/role_model.dart';

class ProviderProfileScreen extends StatelessWidget {
  ProviderProfileScreen({super.key});

  final ProviderProfileController controller = Get.put(ProviderProfileController());

  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);
  final Color bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildInfoSection(),
                        const SizedBox(height: 32),
                        _buildPostsHeader(),
                        const SizedBox(height: 16),
                        _buildPostsList(),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 24, left: 24, right: 24),
      decoration: BoxDecoration(
        color: navyColor,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32.0), bottomRight: Radius.circular(32.0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
                onPressed: () => Get.back(),
              ),
              const Text('الملف الشخصي', style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Obx(() => IconButton(
                icon: Icon(controller.isEditing.value ? Icons.check_circle_outline : Icons.edit_note_rounded, color: Colors.white, size: 28),
                onPressed: controller.isEditing.value ? controller.saveProfile : controller.toggleEdit,
              )),
            ],
          ),
          const SizedBox(height: 24),
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: orangeColor, width: 3),
                ),
                child: Icon(Icons.engineering_rounded, size: 50, color: navyColor),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: orangeColor, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Obx(() => Text(
            controller.fullUserName.value.isEmpty ? 'جاري التحميل...' : controller.fullUserName.value,
            style: const TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          )),

          Obx(() => Text(
            controller.selectedSpecialization.value?.name ?? "تخصص غير محدد",
            style: TextStyle(fontFamily: 'Tajawal', color: orangeColor, fontSize: 14),
          )),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        children: [
          _buildDetailRow(Icons.person_outline, 'الاسم الأول', controller.firstNameController),
          const Divider(),
          _buildDetailRow(Icons.person_outline, 'الاسم الأخير', controller.lastNameController),
          const Divider(),
          _buildDetailRow(Icons.email_outlined, 'البريد الإلكتروني', controller.emailController),
          const Divider(),
          _buildDetailRow(Icons.phone_android_outlined, 'رقم الهاتف', controller.phoneController),
          const Divider(),
          _buildDropdownRow<ProvinceModel>(
            icon: Icons.location_on_outlined,
            label: 'المحافظة',
            value: controller.selectedGovernorate,
            items: controller.provinces,
            itemText: (p) => p.name,
          ),
          const Divider(),
          _buildDropdownRow<RoleModel>(
            icon: Icons.work_outline,
            label: 'التخصص',
            value: controller.selectedSpecialization,
            items: controller.specializations,
            itemText: (r) => r.name,
          ),
          const Divider(),
          _buildDetailRow(Icons.badge_outlined, 'الرقم النقابي', controller.syndicateNumberController),
          const Divider(),
          _buildDetailRow(Icons.history_rounded, 'سنوات الخبرة', controller.experienceYearsController, keyboardType: TextInputType.number),
          const Divider(),
          _buildDetailRow(Icons.info_outline, 'نبذة عني', controller.bioController, maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, TextEditingController textController, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: maxLines > 1 ? 4 : 0),
            child: Icon(icon, color: Colors.grey.shade400, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade500, fontSize: 12)),
                Obx(() => controller.isEditing.value
                    ? TextField(
                  controller: textController,
                  maxLines: maxLines,
                  keyboardType: keyboardType,
                  style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(isDense: true, border: InputBorder.none, contentPadding: EdgeInsets.zero),
                )
                    : Text(textController.text.isEmpty ? "لا يوجد" : textController.text, style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownRow<T>({
    required IconData icon,
    required String label,
    required Rx<T?> value,
    required List<T> items,
    required String Function(T) itemText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade400, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade500, fontSize: 12)),
                Obx(() => controller.isEditing.value
                    ? DropdownButton<T>(
                  value: value.value,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                  underline: const SizedBox(),
                  items: items.map((e) => DropdownMenuItem(value: e, child: Text(itemText(e), style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14)))).toList(),
                  onChanged: (v) => value.value = v,
                )
                    : Text(value.value != null ? itemText(value.value!) : "غير محدد", style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('أعمالي وبوستاتي', style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: navyColor)),
        IconButton(
          onPressed: controller.addPost,
          icon: Icon(Icons.add_box_rounded, color: orangeColor, size: 28),
        ),
      ],
    );
  }

  Widget _buildPostsList() {
    return Obx(() {
      if (controller.posts.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text('لا توجد أعمال مضافة بعد', style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade500)),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.posts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final post = controller.posts[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: orangeColor.withOpacity(0.1),
                        child: Icon(Icons.engineering, color: orangeColor, size: 20)
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('نُشر في ${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year}',
                            style: TextStyle(fontFamily: 'Tajawal', fontSize: 12, color: Colors.grey.shade500)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(post.description, style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, color: navyColor, height: 1.5)),
                const SizedBox(height: 12),
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Icon(Icons.image_outlined, color: Colors.grey.shade400, size: 40)),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
