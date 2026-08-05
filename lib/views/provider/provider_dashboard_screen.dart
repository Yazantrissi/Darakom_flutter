import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/provider/provider_dashboard_controller.dart';
import '../home/notifications_screen.dart';
import 'my_projects_screen.dart';
import 'tender_market_screen.dart';
import 'my_offers_screen.dart';
import 'provider_profile_screen.dart';
import '../home/settings_screen.dart'; // استيراد شاشة الإعدادات المشتركة
import 'provider_drawer.dart'; // استيراد القائمة الجانبية لمزود الخدمة

class ProviderDashboardScreen extends StatelessWidget {
  ProviderDashboardScreen({super.key});

  final ProviderDashboardController controller = Get.put(ProviderDashboardController());

  // الألوان الأساسية للهوية
  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);
  final Color bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    // قائمة الشاشات المربوطة بالشريط السفلي
    final List<Widget> pages = [
      _ProviderHomeTab(controller: controller, navyColor: navyColor, orangeColor: orangeColor),
      TenderMarketScreen(),
      MyOffersScreen(),
      ProviderMyProjectsScreen(),
      SettingsScreen(isProvider: true), // تم إزالة كلمة const من هنا لحل الخطأ
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        drawer: const ProviderDrawer(), // القائمة الجانبية الخاصة بمزود الخدمة
        body: Obx(() => IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        )),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      elevation: 20,
      child: SizedBox(
        height: 70,
        child: Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(icon: Icons.home_outlined, label: 'الرئيسية', index: 0),
            _buildNavItem(icon: Icons.search_rounded, label: 'سوق المناقصات', index: 1),
            _buildNavItem(icon: Icons.layers_outlined, label: 'العروض', index: 2),
            _buildNavItem(icon: Icons.handyman_outlined, label: 'مشاريعي', index: 3),
            _buildNavItem(icon: Icons.settings_outlined, label: 'الإعدادات', index: 4), // زر الإعدادات
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

// ==========================================
// محتوى الصفحة الرئيسية لمزود الخدمة
// ==========================================
class _ProviderHomeTab extends StatelessWidget {
  final ProviderDashboardController controller;
  final Color navyColor;
  final Color orangeColor;

  const _ProviderHomeTab({required this.controller, required this.navyColor, required this.orangeColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCustomHeader(context),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. بطاقات الإحصائيات
                _buildStatsSection(),
                const SizedBox(height: 32),

                // 2. مشاريع جديدة
                _buildSectionTitle('مشاريع جديدة', actionText: 'عرض الكل', onAction: () => controller.changePage(1)),
                const SizedBox(height: 16),
                _buildOpportunitiesSection(),
                const SizedBox(height: 32),

                // 3. مشاريع قيد التنفيذ
                _buildSectionTitle('مشاريع قيد التنفيذ', actionText: 'إدارة', onAction: () => controller.changePage(3)),
                const SizedBox(height: 16),
                _buildActiveProjectsSection(),
                const SizedBox(height: 32),

                // 4. العروض
                _buildSectionTitle('العروض', actionText: 'متابعة', onAction: () => controller.changePage(2)),
                const SizedBox(height: 16),
                _buildOffersSection(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 24),
      decoration: BoxDecoration(
        color: navyColor,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32.0), bottomRight: Radius.circular(32.0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Get.to(() => NotificationsScreen()),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Image.asset('assets/images/logo.png', height: 24, fit: BoxFit.contain),
                    const SizedBox(width: 8),
                    Text('مزود الخدمة', style: TextStyle(fontFamily: 'Tajawal', color: navyColor, fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              ),
              // زر القائمة الجانبية
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
            children: [
              GestureDetector(
                onTap: () => Get.to(() => ProviderProfileScreen()),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.engineering_rounded, color: Colors.white, size: 30),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.to(() => ProviderProfileScreen()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('مرحباً بك،', style: TextStyle(fontFamily: 'Tajawal', color: orangeColor, fontSize: 14)),
                      const Text('مؤسسة البناء الحديث', style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      children: [
        _buildStatCard(title: 'مشاريع نشطة', value: '${controller.stats['activeProjects']}', icon: Icons.handyman_rounded, color: Colors.blue),
        const SizedBox(width: 16),
        _buildStatCard(title: 'عروض قيد الانتظار', value: '${controller.stats['pendingOffers']}', icon: Icons.hourglass_empty_rounded, color: orangeColor),
      ],
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(value, style: TextStyle(fontFamily: 'Tajawal', fontSize: 22, fontWeight: FontWeight.bold, color: navyColor)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontFamily: 'Tajawal', fontSize: 12, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {required String actionText, required VoidCallback onAction}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: navyColor)),
        GestureDetector(
          onTap: onAction,
          child: Text(actionText, style: TextStyle(fontFamily: 'Tajawal', color: orangeColor, fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildOpportunitiesSection() {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.newOpportunities.length,
        itemBuilder: (context, index) {
          final opp = controller.newOpportunities[index];
          return Container(
            width: 280,
            margin: const EdgeInsets.only(left: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: orangeColor.withOpacity(0.3)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: orangeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Icon(Icons.new_releases_rounded, color: orangeColor, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(opp['projectName'], style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 15, color: navyColor), overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(opp['clientName'], style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(opp['publishDate'], style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade400, fontSize: 12)),
                    Text(opp['budget'], style: TextStyle(fontFamily: 'Tajawal', color: Colors.green.shade700, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActiveProjectsSection() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.activeProjects.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final project = controller.activeProjects[index];
        return Container(
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
                  Text(project['projectName'], style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: navyColor)),
                  Text('${(project['progress'] * 100).toInt()}%', style: TextStyle(fontFamily: 'Tajawal', color: orangeColor, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: LinearProgressIndicator(value: project['progress'], backgroundColor: Colors.grey.shade200, valueColor: AlwaysStoppedAnimation<Color>(orangeColor), minHeight: 8),
              ),
              const SizedBox(height: 12),
              Text('المرحلة القادمة: ${project['nextMilestone']}', style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOffersSection() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.myOffers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final offer = controller.myOffers[index];
        bool isAccepted = offer['status'] == 'مقبول';

        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 5, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isAccepted ? Colors.green.withOpacity(0.1) : orangeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isAccepted ? Icons.check_circle_outline_rounded : Icons.hourglass_top_rounded,
                  color: isAccepted ? Colors.green : orangeColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(offer['projectName'], style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 14, color: navyColor)),
                    const SizedBox(height: 4),
                    Text('القيمة: ${offer['amount']}', style: TextStyle(fontFamily: 'Tajawal', fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isAccepted ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      offer['status'],
                      style: TextStyle(fontFamily: 'Tajawal', fontSize: 10, color: isAccepted ? Colors.green : Colors.grey.shade700, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(offer['date'], style: TextStyle(fontFamily: 'Tajawal', fontSize: 10, color: Colors.grey.shade400)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}