import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/my_projects_controller.dart';
import '../../controllers/home/client_dashboard_controller.dart';
import '../../models/project_model.dart';
import '../tracking/project_tracking_screen.dart';
import 'client_offers_screen.dart';
import 'client_project_details_screen.dart';

class MyProjectsScreen extends StatelessWidget {
  MyProjectsScreen({super.key});

  final MyProjectsController controller = Get.put(MyProjectsController());

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
                      _buildPendingProjectsList(),
                      _buildActiveProjectsList(),
                      _buildCompletedProjectsList(),
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
                  onPressed: () => Get.find<ClientDashboardController>().changePage(0),
                ),
              ),
              const Text(
                'مشاريعي',
                style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 24),

          TabBar(
            indicatorColor: orangeColor,
            indicatorWeight: 3,
            labelColor: orangeColor,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 14, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 14),
            tabs: const [
              Tab(text: 'قيد الانتظار'),
              Tab(text: 'قيد الإنشاء'),
              Tab(text: 'المنتهية'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPendingProjectsList() {
    if (controller.pendingProjects.isEmpty) {
      return _buildEmptyState('لا توجد مشاريع قيد الانتظار');
    }
    return ListView.separated(
      padding: const EdgeInsets.all(24.0),
      itemCount: controller.pendingProjects.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final project = controller.pendingProjects[index];
        return InkWell(
          onTap: () => Get.to(() => ClientProjectDetailsScreen(project: project)),
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: orangeColor.withOpacity(0.3), width: 1.5),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        project.title,
                        style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: navyColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: orangeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        '${project.offersCount ?? 0} عروض',
                        style: TextStyle(fontFamily: 'Tajawal', color: orangeColor, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'الحالة: ${project.status}',
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.grey.shade100, height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 16, color: Colors.grey.shade500),
                        const SizedBox(width: 6),
                        Text(
                          'تاريخ الطرح: ${project.publishDate ?? "غير محدد"}',
                          style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'استعراض العروض',
                          style: TextStyle(fontFamily: 'Tajawal', color: orangeColor, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: orangeColor),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActiveProjectsList() {
    if (controller.activeProjects.isEmpty) {
      return _buildEmptyState('لا توجد مشاريع قيد الإنشاء');
    }
    return ListView.separated(
      padding: const EdgeInsets.all(24.0),
      itemCount: controller.activeProjects.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final project = controller.activeProjects[index];
        return InkWell(
          onTap: () => Get.to(() => ProjectTrackingScreen(), arguments: {
            'projectId': project.id,
            'projectTitle': project.title,
            'isProvider': false,
          }),
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(project.title, style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: navyColor)),
                    Text('${project.progressPercentage.toInt()}%', style: TextStyle(fontFamily: 'Tajawal', color: orangeColor, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(project.providerName ?? "قيد البحث", style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, color: Colors.grey.shade500)),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: LinearProgressIndicator(value: project.progressPercentage / 100, backgroundColor: Colors.grey.shade200, valueColor: AlwaysStoppedAnimation<Color>(orangeColor), minHeight: 8),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.calendar_month_outlined, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text('تاريخ التسليم المتوقع: ${project.endDate ?? "غير محدد"}', style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade500, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompletedProjectsList() {
    if (controller.completedProjects.isEmpty) {
      return _buildEmptyState('لا توجد مشاريع منتهية');
    }
    return ListView.separated(
      padding: const EdgeInsets.all(24.0),
      itemCount: controller.completedProjects.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final project = controller.completedProjects[index];
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      project.title,
                      style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: navyColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Text('مكتمل', style: TextStyle(fontFamily: 'Tajawal', color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(project.providerName ?? "", style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, color: Colors.grey.shade500)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: 16, color: Colors.green.shade600),
                  const SizedBox(width: 6),
                  Text('تم الانتهاء في: ${project.endDate ?? "غير محدد"}', style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey.shade100, height: 1),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => controller.showRatingDialog(project),
                      icon: const Icon(Icons.star_outline_rounded, size: 18, color: Colors.white),
                      label: const Text('تقييم', style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orangeColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => controller.showComplaintDialog(project),
                      icon: const Icon(Icons.report_problem_outlined, size: 18, color: Colors.redAccent),
                      label: const Text('شكوى', style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        side: const BorderSide(color: Colors.redAccent, width: 1.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_late_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade500, fontSize: 16)),
        ],
      ),
    );
  }
}
