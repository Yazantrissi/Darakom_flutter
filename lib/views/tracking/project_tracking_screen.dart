import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/tracking/project_tracking_controller.dart';

class ProjectTrackingScreen extends StatelessWidget {
  ProjectTrackingScreen({super.key});

  final ProjectTrackingController controller = Get.put(ProjectTrackingController());

  // الألوان الأساسية
  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);
  final Color bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // واجهة عربية
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. بطاقة ملخص المشروع
              _buildProjectSummary(),
              const SizedBox(height: 24),

              // 2. بطاقة شريط الإنجاز العام
              _buildProgressSection(),
              const SizedBox(height: 32),

              // 3. قسم المراحل (Timeline)
              Text('المراحل (Timeline)', style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: navyColor)),
              const SizedBox(height: 16),
              _buildTimeline(),
              const SizedBox(height: 32),

              // 4. --- الزر الجديد: تقديم شكوى ---
              _buildComplaintButton(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // --- دوال مساعدة لبناء واجهة الشاشة --- //

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
          Text('فيلا سكنية - حي الياسمين', style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: navyColor)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.engineering_outlined, size: 18, color: Colors.grey.shade500),
              const SizedBox(width: 8),
              Text('المنفذ: مؤسسة البناء الحديث', style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_month_outlined, size: 18, color: Colors.grey.shade500),
              const SizedBox(width: 8),
              Text('تاريخ التسليم: 2026-11-01', style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, color: Colors.grey.shade600)),
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
              Obx(() => Text('${(controller.progress.value * 100).toInt()}%', style: TextStyle(fontFamily: 'Tajawal', color: orangeColor, fontSize: 18, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: LinearProgressIndicator(
              value: controller.progress.value,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(orangeColor),
              minHeight: 10,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.milestones.length,
      itemBuilder: (context, index) {
        final milestone = controller.milestones[index];
        bool isLast = index == controller.milestones.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // العامود الخاص بالخط والدوائر
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: milestone['isCompleted'] ? Colors.green : Colors.grey.shade300,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                    ),
                    child: milestone['isCompleted']
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                        : null,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: milestone['isCompleted'] ? Colors.green : Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // بطاقة تفاصيل المرحلة
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: milestone['isCompleted'] ? Colors.green.withOpacity(0.3) : Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          milestone['title'],
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: milestone['isCompleted'] ? navyColor : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.date_range_outlined, size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text(
                              milestone['date'],
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

  // تصميم الزر الجديد لتقديم الشكوى
  Widget _buildComplaintButton() {
    return OutlinedButton.icon(
      onPressed: controller.showComplaintDialog, // استدعاء دالة الشكوى من المتحكم
      icon: const Icon(Icons.report_problem_outlined, color: Colors.redAccent),
      label: const Text(
        'تقديم شكوى على سير العمل',
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.redAccent,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: Colors.redAccent, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        backgroundColor: Colors.redAccent.withOpacity(0.05), // خلفية حمراء شفافة جداً
      ),
    );
  }
}