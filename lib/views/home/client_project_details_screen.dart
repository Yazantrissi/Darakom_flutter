import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/client_project_details_controller.dart';

class ClientProjectDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> project;
  ClientProjectDetailsScreen({super.key, required this.project});

  late final ClientProjectDetailsController controller = Get.put(
    ClientProjectDetailsController(projectData: project),
    tag: project['id'].toString(),
  );

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
        body: Obx(() => Column(
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
        )),
      ),
    );
  }

  Widget _buildMainInfoCard(Map<String, dynamic> projectData) {
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
                  projectData['projectName'],
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: navyColor),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: orangeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(
                  '${projectData['offersCount']} عروض',
                  style: TextStyle(fontFamily: 'Tajawal', color: orangeColor, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.location_on_outlined, '${projectData['governorate']} - ${projectData['address']}'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.calendar_today_outlined, 'تاريخ النشر: ${projectData['publishDate']}'),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(Map<String, dynamic> projectData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Text(
        projectData['description'] ?? 'لا يوجد وصف متاح لهذا المشروع.',
        style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, color: navyColor, height: 1.6),
      ),
    );
  }

  Widget _buildAdditionalDetailsGrid(Map<String, dynamic> projectData) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 2.2,
      children: [
        _buildDetailItem(Icons.straighten, 'المساحة', '${projectData['area']} م²'),
        _buildDetailItem(Icons.category_outlined, 'النوع', projectData['type']),
        _buildDetailItem(Icons.engineering_outlined, 'التخصص المطلوب', projectData['specialization']),
        _buildDetailItem(Icons.timer_outlined, 'مدة الطرح', '${projectData['duration']} يوم'),
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
}
