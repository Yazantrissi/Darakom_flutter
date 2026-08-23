import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/provider/my_offers_controller.dart';
import '../../models/offer_model.dart';
import 'submit_offer_screen.dart';

class MyOffersScreen extends StatelessWidget {
  MyOffersScreen({super.key});

  final MyOffersController controller = Get.put(MyOffersController());

  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);
  final Color bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            _buildHeader(),
            _buildCustomTabBar(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final offers = controller.currentTabIndex.value == 0
                    ? controller.publicOffers
                    : controller.privateOffers;

                if (offers.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: offers.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _buildOfferCard(offers[index], controller.currentTabIndex.value == 0);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 20, left: 24, right: 24),
      decoration: BoxDecoration(
        color: navyColor,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('عروضي', style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      height: 50,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
      child: Obx(() => Row(
        children: [
          _buildTabItem('عروض عامة', 0),
          _buildTabItem('عروض خاصة', 1),
        ],
      )),
    );
  }

  Widget _buildTabItem(String label, int index) {
    bool isSelected = controller.currentTabIndex.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: isSelected ? orangeColor : Colors.transparent, borderRadius: BorderRadius.circular(12)),
          child: Text(label, style: TextStyle(fontFamily: 'Tajawal', color: isSelected ? Colors.white : Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      ),
    );
  }

  Widget _buildOfferCard(OfferModel offer, bool isPublic) {
    Color statusColor;
    String statusText;
    switch (offer.status) {
      case 'accepted':
        statusColor = Colors.green;
        statusText = 'مقبول';
        break;
      case 'rejected':
        statusColor = Colors.redAccent;
        statusText = 'مرفوض';
        break;
      default:
        statusColor = orangeColor;
        statusText = 'قيد المراجعة';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(offer.projectName ?? 'عرض لمشروع #${offer.projectId}', style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 16, color: navyColor))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(statusText, style: TextStyle(fontFamily: 'Tajawal', color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          if (offer.clientName != null && offer.clientName!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildInfoRow(Icons.person_outline, 'العميل: ${offer.clientName}'),
          ],
          const SizedBox(height: 8),
          _buildInfoRow(Icons.payments_outlined, 'السعر: ${offer.cost} ل.س'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.timer_outlined, 'المدة: ${offer.duration} يوم'),
          if (offer.date != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(Icons.calendar_today_outlined, 'تاريخ التقديم: ${offer.date}'),
          ],
          const Divider(height: 32),
          Row(
            children: [
              if (offer.status == 'pending')
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final updated = await Get.to(() => SubmitOfferScreen(
                            projectId: offer.projectId,
                            projectName: offer.projectName ?? "مشروع #${offer.projectId}",
                            isEditMode: true,
                            existingOffer: offer,
                          ));
                      if (updated == true) controller.fetchOffers();
                    },
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('تعديل', style: TextStyle(fontFamily: 'Tajawal', fontSize: 12)),
                    style: ElevatedButton.styleFrom(backgroundColor: navyColor, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              if (offer.status == 'pending') const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: offer.status == 'pending'
                      ? () => controller.deleteOffer(offer.id, isPublic)
                      : null,
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('حذف', style: TextStyle(fontFamily: 'Tajawal', fontSize: 12)),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent, side: const BorderSide(color: Colors.redAccent), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_late_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('لا توجد عروض مقدمة حالياً', style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade500, fontSize: 16)),
        ],
      ),
    );
  }
}
