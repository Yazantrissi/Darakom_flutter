import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/client_dashboard_controller.dart';
import 'custom_drawer.dart';
import 'profile_screen.dart';
import '../tracking/project_tracking_screen.dart';
import 'notifications_screen.dart';
import 'client_offers_screen.dart';
import 'my_projects_screen.dart';
import 'settings_screen.dart';

class ClientDashboardScreen extends StatelessWidget {
  ClientDashboardScreen({super.key});

  final ClientDashboardController controller = Get.put(ClientDashboardController());

  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);
  final Color bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _HomeTab(controller: controller, navyColor: navyColor, orangeColor: orangeColor), // 0: الرئيسية
      ClientOffersScreen(), // 1: العروض
      MyProjectsScreen(),   // 2: مشاريعي
      SettingsScreen(),     // 3: الإعدادات
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        drawer: const CustomDrawer(),

        body: Obx(() => IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        )),

        floatingActionButton: FloatingActionButton(
          backgroundColor: orangeColor,
          elevation: 4,
          shape: const CircleBorder(),
          onPressed: controller.addNewProject,
          child: const Icon(Icons.add_rounded, size: 32, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      elevation: 20,
      child: SizedBox(
        height: 70,
        child: Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(icon: Icons.home_outlined, label: 'الرئيسية', index: 0),
            _buildNavItem(icon: Icons.layers_outlined, label: 'العروض', index: 1),
            const SizedBox(width: 48), // مساحة للزر العائم
            _buildNavItem(icon: Icons.assignment_outlined, label: 'مشاريعي', index: 2),
            _buildNavItem(icon: Icons.settings_outlined, label: 'الإعدادات', index: 3),
          ],
        )),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    bool isSelected = controller.currentIndex.value == index;
    return InkWell(
      onTap: () => controller.changePage(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? orangeColor : Colors.grey.shade400, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? orangeColor : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final ClientDashboardController controller;
  final Color navyColor;
  final Color orangeColor;

  const _HomeTab({required this.controller, required this.navyColor, required this.orangeColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCustomHeader(context),
        Expanded(
          child: RefreshIndicator(
            onRefresh: controller.fetchDashboardData,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildAddProjectButton(),
                  const SizedBox(height: 24),
                  
                  // الإحصائيات السريعة
                  _buildStatsGrid(),
                  const SizedBox(height: 32),

                  _buildSectionTitle(
                      'مشاريع قيد الانتظار',
                      actionText: 'عرض الكل',
                      onAction: () => controller.changePage(2) 
                  ),
                  const SizedBox(height: 16),
                  _buildPendingProjectsSection(),
                  const SizedBox(height: 32),

                  _buildSectionTitle(
                      'مشاريع قيد الإنشاء',
                      actionText: 'عرض الكل',
                      onAction: () => controller.changePage(2)
                  ),
                  const SizedBox(height: 16),
                  _buildActiveProjectsSection(),
                  const SizedBox(height: 32),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Obx(() => Row(
      children: [
        _buildStatCard('إجمالي المشاريع', controller.totalProjects.value.toString(), Icons.assignment_outlined, Colors.blue),
        const SizedBox(width: 12),
        _buildStatCard('عروض معلقة', controller.pendingOffersCount.value.toString(), Icons.layers_outlined, Colors.orange),
      ],
    ));
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(count, style: const TextStyle(fontFamily: 'Tajawal', fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(fontFamily: 'Tajawal', fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 24),
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
              Row(
                children: [
                  GestureDetector(
                    onTap: controller.goToSearchProviders,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.search_rounded, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => Get.to(() => NotificationsScreen()),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                    ),
                  ),
                ],
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Image.asset('assets/images/logo.png', height: 24, fit: BoxFit.contain),
                    const SizedBox(width: 8),
                    Text('داركم', style: TextStyle(fontFamily: 'Tajawal', color: navyColor, fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
              ),

              Builder(
                builder: (context) => GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.menu_rounded, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('مرحباً بك.', style: TextStyle(fontFamily: 'Tajawal', color: orangeColor, fontSize: 14)),
                  Obx(() => Text(
                    controller.fullUserName.value,
                    style: const TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                ],
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => Get.to(() => ProfileScreen()),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 30),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddProjectButton() {
    return InkWell(
      onTap: controller.addNewProject,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: orangeColor,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [BoxShadow(color: orangeColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
            const Text('+ إضافة مشروع جديد', style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {String? actionText, Color? actionColor, VoidCallback? onAction}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: navyColor)),
        if (actionText != null)
          GestureDetector(
            onTap: onAction,
            child: Text(actionText, style: TextStyle(fontFamily: 'Tajawal', color: actionColor ?? orangeColor, fontSize: 14)),
          ),
      ],
    );
  }

  Widget _buildPendingProjectsSection() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.pendingProjects.isEmpty) {
        return Center(child: Text('لا توجد مشاريع قيد الانتظار', style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade500)));
      }
      return SizedBox(
        height: 140, 
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.pendingProjects.length,
          itemBuilder: (context, index) {
            final project = controller.pendingProjects[index];
            return GestureDetector(
              onTap: () => controller.changePage(1), 
              child: Container(
                width: 280, 
                margin: const EdgeInsets.only(left: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: orangeColor.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            project.title,
                            style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 15, color: navyColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: orangeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            '${project.offersCount ?? 0} عروض',
                            style: TextStyle(fontFamily: 'Tajawal', color: orangeColor, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      'الحالة: ${project.status}',
                      style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade400),
                        const SizedBox(width: 4),
                        Text(
                          'طُرح في: ${project.startDate ?? "غير محدد"}',
                          style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildActiveProjectsSection() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox.shrink();
      }
      if (controller.activeProjects.isEmpty) {
        return Center(child: Text('لا توجد مشاريع قيد التنفيذ', style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade500)));
      }
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.activeProjects.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
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
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
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
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: LinearProgressIndicator(
                        value: project.progressPercentage / 100,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(orangeColor),
                        minHeight: 8),
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
    });
  }
}
