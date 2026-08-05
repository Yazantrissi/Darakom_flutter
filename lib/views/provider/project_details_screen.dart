import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'submit_offer_screen.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> projectData;

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
              _buildDetailSection(Icons.description_outlined, 'وصف المشروع', projectData['description'] ?? 'لا يوجد وصف متاح لهذا المشروع حالياً.'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildDetailCard(Icons.straighten_outlined, 'المساحة', '350 م²')), // Mock data
                  const SizedBox(width: 16),
                  Expanded(child: _buildDetailCard(Icons.map_outlined, 'المحافظة', projectData['location'])),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailSection(Icons.location_on_outlined, 'العنوان التفصيلي', 'المزة - فيلات غربية - شارع الجلاء'), // Mock data
              const SizedBox(height: 24),
              _buildSectionTitle('المرفقات'),
              const SizedBox(height: 12),
              _buildAttachmentsList(),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Get.to(() => SubmitOfferScreen(projectName: projectData['projectName'])),
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
          Text(projectData['projectName'], style: TextStyle(fontFamily: 'Tajawal', fontSize: 20, fontWeight: FontWeight.bold, color: navyColor)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person_outline, size: 16, color: Colors.grey.shade400),
              const SizedBox(width: 8),
              Text('العميل: ${projectData['clientName']}', style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade600, fontSize: 14)),
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
    // Mock attachments
    final attachments = [
      {'name': 'المخطط الهندسي.pdf', 'icon': Icons.picture_as_pdf_outlined},
      {'name': 'صورة الموقع 1.jpg', 'icon': Icons.image_outlined},
    ];

    return Column(
      children: attachments.map((att) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(att['icon'] as IconData, color: navyColor),
            const SizedBox(width: 16),
            Expanded(child: Text(att['name'] as String, style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14))),
            Icon(Icons.download_for_offline_outlined, color: orangeColor),
          ],
        ),
      )).toList(),
    );
  }
}