import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/client_project_details_controller.dart';
import '../../models/project_model.dart';
import '../../models/project_report_model.dart';
import 'client_offers_screen.dart';

class ClientProjectDetailsScreen extends StatelessWidget {
  final ProjectModel project;
  ClientProjectDetailsScreen({super.key, required this.project});

  late final ClientProjectDetailsController controller = Get.put(
    ClientProjectDetailsController(projectData: project),
    tag: project.id.toString(),
  );

  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);
  final Color bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: navyColor,
            elevation: 0,
            title: const Text('تفاصيل المشروع', style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontWeight: FontWeight.bold)),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
            ),
            bottom: const TabBar(
              indicatorColor: Colors.orange,
              indicatorWeight: 3,
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(text: 'المعلومات'),
                Tab(text: 'التقارير'),
                Tab(text: 'الملفات'),
              ],
            ),
          ),
          body: Stack(
            children: [
              TabBarView(
                children: [
                  _buildInfoTab(),
                  _buildReportsTab(),
                  _buildFilesTab(),
                ],
              ),
              Obx(() => controller.isDeleting.value 
                ? Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    return Obx(() => Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMainInfoCard(controller.project.value),
                const SizedBox(height: 24),
                _buildSectionTitle('وصف المشروع'),
                const SizedBox(height: 12),
                _buildDescriptionCard(controller.project.value),
                const SizedBox(height: 24),
                _buildAdditionalDetailsGrid(controller.project.value),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        _buildActionButtons(),
      ],
    ));
  }

  Widget _buildReportsTab() {
    return Obx(() {
      if (controller.reports.isEmpty) {
        return _buildEmptyState('لا توجد تقارير إنجاز حالياً', Icons.description_outlined);
      }

      return ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: controller.reports.length,
        separatorBuilder: (ctx, i) => const SizedBox(height: 16),
        itemBuilder: (ctx, index) {
          final report = controller.reports[index];
          return _buildReportCard(report);
        },
      );
    });
  }

  Widget _buildFilesTab() {
    return Obx(() {
      if (controller.documents.isEmpty) {
        return _buildEmptyState('لا توجد ملفات مرفقة بهذا المشروع', Icons.folder_open_rounded);
      }

      return GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: controller.documents.length,
        itemBuilder: (ctx, index) {
          final doc = controller.documents[index];
          return _buildFileCard(doc);
        },
      );
    });
  }

  Widget _buildMainInfoCard(ProjectModel projectData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  projectData.title,
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: navyColor),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: orangeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(
                  '${projectData.offersCount ?? 0} عروض',
                  style: TextStyle(fontFamily: 'Tajawal', color: orangeColor, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.location_on_outlined, '${projectData.governorate ?? "غير محدد"} - ${projectData.address ?? ""}'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.calendar_today_outlined, 'تاريخ النشر: ${projectData.publishDate ?? "---"}'),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(ProjectModel projectData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Text(
        projectData.description.isNotEmpty ? projectData.description : 'لا يوجد وصف متاح لهذا المشروع.',
        style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, color: navyColor, height: 1.6),
      ),
    );
  }

  Widget _buildAdditionalDetailsGrid(ProjectModel projectData) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 2.2,
      children: [
        _buildDetailItem(Icons.straighten, 'المساحة', '${projectData.area} م²'),
        _buildDetailItem(Icons.category_outlined, 'النوع', projectData.work_type == 'construction' ? 'إنشاء' : 'تشطيب'),
        _buildDetailItem(Icons.engineering_outlined, 'التخصص المطلوب', projectData.specialization ?? "غير محدد"),
        _buildDetailItem(Icons.timer_outlined, 'مدة الطرح', '${projectData.duration} يوم'),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Icon(icon, color: orangeColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: TextStyle(fontFamily: 'Tajawal', fontSize: 10, color: Colors.grey.shade500)),
                Text(value, style: TextStyle(fontFamily: 'Tajawal', fontSize: 12, fontWeight: FontWeight.bold, color: navyColor), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(ProjectReportModel report) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(report.date, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              if (report.reportedProgress != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text('%${report.reportedProgress} منجز', style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(report.description, style: TextStyle(fontSize: 14, color: navyColor, height: 1.5)),
          if (report.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: report.images.length,
                separatorBuilder: (ctx, i) => const SizedBox(width: 8),
                itemBuilder: (ctx, idx) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(report.images[idx], width: 60, height: 60, fit: BoxFit.cover),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildFileCard(Map<String, dynamic> doc) {
    bool isPdf = doc['type'] == 'pdf';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isPdf ? Icons.picture_as_pdf_rounded : Icons.image_outlined, color: isPdf ? Colors.redAccent : orangeColor, size: 40),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(doc['description'] ?? 'ملف', style: TextStyle(fontSize: 12, color: navyColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () {
               // Logic to open URL
            },
            child: const Text('فتح', style: TextStyle(fontSize: 11)),
          )
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (controller.project.value.status == 'new' || controller.project.value.status == 'pending')
          ElevatedButton(
            onPressed: controller.goToOffers,
            style: ElevatedButton.styleFrom(
              backgroundColor: orangeColor,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text('عرض العروض المستلمة', style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.editProject,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('تعديل', style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: navyColor,
                    minimumSize: const Size(0, 50),
                    side: BorderSide(color: navyColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.deleteProject,
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  label: const Text('حذف', style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    minimumSize: const Size(0, 50),
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: navyColor));
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade400),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildEmptyState(String msg, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(msg, style: TextStyle(color: Colors.grey.shade500, fontSize: 15)),
        ],
      ),
    );
  }
}
