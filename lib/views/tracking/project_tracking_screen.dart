import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/tracking/project_tracking_controller.dart';
import '../../models/project_step_model.dart';

class ProjectTrackingScreen extends StatelessWidget {
  ProjectTrackingScreen({super.key});

  final ProjectTrackingController controller = Get.put(ProjectTrackingController());

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
          title: const Text('متابعة المشروع', style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontWeight: FontWeight.bold)),
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
          if (controller.isLoading.value && controller.steps.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: controller.loadTrackingData,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProjectSummary(),
                  const SizedBox(height: 24),
                  _buildProgressSection(),
                  const SizedBox(height: 32),
                  Text('المراحل (Timeline)', style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: navyColor)),
                  const SizedBox(height: 16),
                  _buildTimeline(),
                  const SizedBox(height: 32),
                  _buildActionButtons(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProjectSummary() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(controller.projectTitle, style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: navyColor)),
          const SizedBox(height: 8),
          if (controller.providerName != null)
            Row(
              children: [
                Icon(Icons.engineering_outlined, size: 18, color: Colors.grey.shade500),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${controller.providerName}${controller.providerType != null ? " • ${controller.providerType}" : ""}',
                    style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          if (controller.provinceName != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 18, color: Colors.grey.shade500),
                const SizedBox(width: 8),
                Text(controller.provinceName!, style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
          ],
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.percent_rounded, size: 18, color: Colors.grey.shade500),
              const SizedBox(width: 8),
              Text(
                'التقدم: ${(controller.progress.value * 100).toInt()}/100',
                style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: orangeColor.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: orangeColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('نسبة الإنجاز الإجمالية', style: TextStyle(fontFamily: 'Tajawal', fontSize: 15, fontWeight: FontWeight.bold, color: navyColor)),
              Text('${(controller.progress.value * 100).toInt()}%', style: TextStyle(fontFamily: 'Tajawal', color: orangeColor, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: LinearProgressIndicator(
              value: controller.progress.value,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(orangeColor),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    if (controller.steps.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text('لا توجد مراحل محددة لهذا المشروع بعد', style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade500)),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.steps.length,
      itemBuilder: (context, index) {
        final step = controller.steps[index];
        bool isLast = index == controller.steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: step.isCompleted ? Colors.green : Colors.grey.shade300,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                    ),
                    child: step.isCompleted
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                        : null,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: step.isCompleted ? Colors.green : Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: step.isCompleted ? Colors.green.withOpacity(0.3) : Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              step.title,
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: step.isCompleted ? navyColor : Colors.grey.shade600,
                              ),
                            ),
                            if (step.progressPercent > 0 && !step.isCompleted)
                              Text('%${step.progressPercent}', style: TextStyle(fontSize: 12, color: orangeColor, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        if (step.description != null) ...[
                          const SizedBox(height: 4),
                          Text(step.description!, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                        ],
                        if (step.attachments != null && step.attachments!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: step.attachments!.map((att) {
                              final url = (att['path'] ?? att['url'] ?? '').toString();
                              final title = (att['description'] ?? att['title'] ?? att['file_name'] ?? 'مرفق').toString();
                              final isImage = (att['file_type']?.toString() == 'image') ||
                                  url.toLowerCase().endsWith('.png') ||
                                  url.toLowerCase().endsWith('.jpg') ||
                                  url.toLowerCase().endsWith('.jpeg');
                              return Chip(
                                avatar: Icon(
                                  isImage ? Icons.image_outlined : Icons.picture_as_pdf_outlined,
                                  size: 16,
                                  color: isImage ? orangeColor : Colors.redAccent,
                                ),
                                label: Text(title, style: const TextStyle(fontFamily: 'Tajawal', fontSize: 11)),
                              );
                            }).toList(),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.date_range_outlined, size: 14, color: Colors.grey.shade400),
                            const SizedBox(width: 4),
                            Text(
                              step.date ?? "---",
                              style: TextStyle(fontFamily: 'Tajawal', fontSize: 12, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    if (controller.isProvider) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.addCompletedStage,
              icon: const Icon(Icons.add_task_rounded, color: Colors.white),
              label: const Text('إضافة مرحلة منجزة', style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: orangeColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: controller.showComplaintDialog,
              icon: const Icon(Icons.report_problem_outlined, color: Colors.redAccent),
              label: const Text('تقديم شكوى', style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.redAccent, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        if (controller.canRate || (controller.project.value?.isCompletedLifecycle ?? false)) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.showRatingDialog,
              icon: const Icon(Icons.star_outline_rounded, color: Colors.white),
              label: const Text('تقييم مزود الخدمة', style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: orangeColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        OutlinedButton.icon(
          onPressed: controller.showComplaintDialog,
          icon: const Icon(Icons.report_problem_outlined, color: Colors.redAccent),
          label: const Text('تقديم شكوى على سير العمل', style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: const BorderSide(color: Colors.redAccent, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            backgroundColor: Colors.redAccent.withOpacity(0.05),
          ),
        ),
      ],
    );
  }
}
