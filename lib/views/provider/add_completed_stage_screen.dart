import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/provider/add_completed_stage_controller.dart';
import '../../widgets/custom_file_upload_section.dart';

class AddCompletedStageScreen extends StatelessWidget {
  AddCompletedStageScreen({super.key});

  final AddCompletedStageController controller = Get.put(AddCompletedStageController());

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
          title: const Text('إضافة مرحلة منجزة', style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // اسم المشروع
              _buildProjectHeader(),
              const SizedBox(height: 32),

              // وصف المرحلة
              Text('وصف الأعمال المنجزة:', style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: navyColor)),
              const SizedBox(height: 12),
              TextField(
                controller: controller.commentController,
                maxLines: 5,
                style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'اكتب تفاصيل ما تم إنجازه في هذه المرحلة...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
              const SizedBox(height: 32),

              // قسم المرفقات
              CustomFileUploadSection(
                attachments: controller.attachments,
                onAdd: controller.addAttachment,
                onRemove: controller.removeAttachment,
                onPick: controller.pickAttachment,
              ),
              const SizedBox(height: 40),

              // زر الحفظ
              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.submitStageUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: controller.isLoading.value
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('تأكيد الإنجاز', style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: navyColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: navyColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.assignment_outlined, color: navyColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              controller.projectTitle,
              style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: navyColor),
            ),
          ),
        ],
      ),
    );
  }
}
