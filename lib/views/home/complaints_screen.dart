import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/complaints_controller.dart';
import '../../models/complaint_model.dart';

class ComplaintsScreen extends StatelessWidget {
  ComplaintsScreen({super.key});

  final ComplaintsController controller = Get.put(ComplaintsController());

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
          body: Column(
            children: [
              _buildCustomHeader(),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  return TabBarView(
                    children: [
                      _buildComplaintsList(controller.pendingComplaints, 'pending'),
                      _buildComplaintsList(controller.resolvedComplaints, 'resolved'),
                      _buildComplaintsList(controller.rejectedComplaints, 'rejected'),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 8, left: 16, right: 16),
      decoration: BoxDecoration(
        color: navyColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
          bottomRight: Radius.circular(32.0),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
                  onPressed: () => Get.back(),
                ),
              ),
              const Text(
                'سجل الشكاوي',
                style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
                  onPressed: () => controller.openNewComplaintDialog(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          TabBar(
            indicatorColor: orangeColor,
            indicatorWeight: 3,
            labelColor: orangeColor,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 13, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
            tabs: const [
              Tab(text: 'قيد المراجعة'),
              Tab(text: 'تم الحل'),
              Tab(text: 'مرفوضة'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintsList(List<ComplaintModel> complaintsList, String type) {
    if (complaintsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('لا توجد شكاوي في هذا السجل', style: TextStyle(fontFamily: 'Tajawal', fontSize: 15, color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24.0),
      itemCount: complaintsList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildComplaintCard(complaintsList[index], type);
      },
    );
  }

  Widget _buildComplaintCard(ComplaintModel complaint, String type) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (type == 'pending') {
      statusColor = orangeColor;
      statusText = 'قيد المراجعة';
      statusIcon = Icons.hourglass_empty_rounded;
    } else if (type == 'resolved') {
      statusColor = Colors.green.shade600;
      statusText = 'تم الحل';
      statusIcon = Icons.check_circle_outline_rounded;
    } else {
      statusColor = Colors.redAccent;
      statusText = 'مرفوضة';
      statusIcon = Icons.cancel_outlined;
    }

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'رقم الشكوى: ${complaint.complaintCode}',
                style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    const SizedBox(width: 4),
                    Text(statusText, style: TextStyle(fontFamily: 'Tajawal', color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Icon(Icons.gavel_rounded, size: 18, color: navyColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'المشتكى عليه: ${complaint.defendantName}',
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 15, fontWeight: FontWeight.bold, color: navyColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Icon(Icons.assignment_outlined, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'المشروع: ${complaint.projectName}',
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade100, height: 1),
          const SizedBox(height: 12),

          Text('تفاصيل المشكلة:', style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, fontWeight: FontWeight.bold, color: navyColor)),
          const SizedBox(height: 4),
          Text(
            complaint.description,
            style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, color: Colors.grey.shade600, height: 1.5),
          ),

          if ((type == 'resolved' || type == 'rejected') &&
              complaint.resolution != null &&
              complaint.resolution!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: type == 'resolved' ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'رد الإدارة: ${complaint.resolution}',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 12,
                  color: type == 'resolved' ? Colors.green.shade800 : Colors.red.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          Row(
            children: [
              Icon(Icons.date_range_outlined, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text('تاريخ التقديم: ${complaint.date}', style: TextStyle(fontFamily: 'Tajawal', fontSize: 12, color: Colors.grey.shade500)),
            ],
          ),
        ],
      ),
    );
  }
}
