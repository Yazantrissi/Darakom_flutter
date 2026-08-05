import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/provider/submit_offer_controller.dart';
import '../../widgets/custom_file_upload_section.dart';

class SubmitOfferScreen extends StatelessWidget {
  final String projectName;
  final bool isEditMode;
  SubmitOfferScreen({super.key, required this.projectName, this.isEditMode = false});

  final SubmitOfferController controller = Get.put(SubmitOfferController());

  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);
  final Color bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    // تعيين اسم المشروع تلقائياً في البداية
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.offerProjectNameController.text.isEmpty) {
        controller.offerProjectNameController.text = projectName;
      }
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: navyColor,
          title: Text(isEditMode ? 'تعديل عرض السعر' : 'تقديم عرض سعر', style: const TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontWeight: FontWeight.bold)),
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
              _buildSectionTitle('البيانات الأساسية للعرض'),
              const SizedBox(height: 16),
              _buildTextField(controller: controller.offerProjectNameController, label: 'اسم المشروع في العرض', icon: Icons.edit_note_rounded),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField(controller: controller.totalDurationController, label: 'المدة الإجمالية (يوم)', icon: Icons.timer_outlined, isNumber: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(controller: controller.totalPriceController, label: 'السعر الإجمالي (ل.س)', icon: Icons.payments_outlined, isNumber: true)),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(controller: controller.startDateController, label: 'تاريخ البدء المتوقع', icon: Icons.calendar_today_outlined),
              
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle('مراحل المشروع'),
                  TextButton.icon(
                    onPressed: controller.addStage,
                    icon: Icon(Icons.add_circle_outline, color: orangeColor),
                    label: Text('إضافة مرحلة', style: TextStyle(fontFamily: 'Tajawal', color: orangeColor, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(() => Column(
                children: List.generate(controller.projectStages.length, (index) {
                  return _buildStageCard(index);
                }),
              )),

              const SizedBox(height: 32),
              _buildSectionTitle('المرفقات والصور'),
              const SizedBox(height: 16),
              CustomFileUploadSection(
                attachments: controller.offerAttachments,
                onAdd: controller.addAttachment,
                onRemove: controller.removeAttachment,
                onPick: controller.pickAttachment,
              ),

              const SizedBox(height: 40),
              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.submitOffer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: navyColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(isEditMode ? 'تعديل العرض' : 'إرسال العرض النهائي', style: const TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              )),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: navyColor));
  }

  Widget _buildStageCard(int index) {
    final stage = controller.projectStages[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: navyColor, borderRadius: BorderRadius.circular(8)),
                child: Text('المرحلة ${index + 1}', style: const TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                onPressed: () => controller.removeStage(index),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(controller: stage.nameController, label: 'اسم المرحلة', icon: Icons.title_rounded),
          const SizedBox(height: 12),
          _buildTextField(controller: stage.durationController, label: 'مدة المرحلة (أيام)', icon: Icons.hourglass_bottom_rounded, isNumber: true),
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'Tajawal', color: Colors.grey, fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade100)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1A2A44))),
      ),
    );
  }
}