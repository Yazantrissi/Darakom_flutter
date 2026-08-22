import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'submit_offer_screen.dart';
import '../../models/project_model.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final ProjectModel projectData;

  const ProjectDetailsScreen({super.key, required this.projectData});

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
          title: const Text('تفاصيل المشروع', style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontWeight: FontWeight.bold)),
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
              _buildProjectHeader(),
              const SizedBox(height: 24),
              _buildDetailSection(Icons.description_outlined, 'وصف المشروع', projectData.description.isNotEmpty ? projectData.description : 'لا يوجد وصف متاح لهذا المشروع حالياً.'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailCard(
                      Icons.straighten_outlined,
                      'المساحة',
                      projectData.area != null && projectData.area!.isNotEmpty
                          ? '${projectData.area} م²'
                          : 'غير محدد',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDetailCard(
                      Icons.map_outlined,
                      'المحافظة',
                      projectData.governorate ?? projectData.address ?? 'غير محدد',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailSection(
                Icons.location_on_outlined,
                'العنوان التفصيلي',
                projectData.address?.isNotEmpty == true
                    ? projectData.address!
                    : (projectData.governorate ?? 'لا يوجد عنوان تفصيلي'),
              ),
              if (projectData.budget != null && projectData.budget!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildDetailSection(
                  Icons.payments_outlined,
                  'الميزانية',
                  '${projectData.budget} ${projectData.currency ?? 'ل.س'}',
                ),
              ],
              const SizedBox(height: 24),
              _buildSectionTitle('المرفقات'),
              const SizedBox(height: 12),
              _buildAttachmentsList(),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Get.to(() => SubmitOfferScreen(
                      projectId: projectData.id,
                      projectName: projectData.title,
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('تقديم عرض', style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(projectData.title, style: TextStyle(fontFamily: 'Tajawal', fontSize: 20, fontWeight: FontWeight.bold, color: navyColor)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person_outline, size: 16, color: Colors.grey.shade400),
              const SizedBox(width: 8),
              Text('العميل: ${projectData.clientName ?? ""}', style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade600, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(IconData icon, String title, String content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: orangeColor),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 16, color: navyColor)),
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, color: Colors.grey.shade600, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: orangeColor),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(fontFamily: 'Tajawal', fontSize: 12, color: Colors.grey.shade500)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, fontWeight: FontWeight.bold, color: navyColor)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: navyColor));
  }

  Widget _buildAttachmentsList() {
    // No project-documents endpoint on Laravel — keep same card layout with empty state.
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file_outlined, color: navyColor),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'لا توجد مرفقات متاحة حالياً',
              style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}