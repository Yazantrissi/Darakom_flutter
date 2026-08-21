import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/client_offers_controller.dart';
import '../../controllers/home/client_dashboard_controller.dart';
import '../../models/offer_model.dart';
import 'offer_details_screen.dart';

class ClientOffersScreen extends StatelessWidget {
  final int? projectId;
  ClientOffersScreen({super.key, this.projectId});

  late final ClientOffersController controller = Get.put(
    ClientOffersController(projectId: projectId),
    tag: projectId?.toString(), 
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
        body: Column(
          children: [
            _buildCustomHeader(),
            if (projectId == null || projectId == 0) _buildCustomTabBar(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final currentOffers = controller.currentIndex.value == 0 
                    ? controller.publicOffers 
                    : controller.privateOffers;

                if (currentOffers.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchOffers,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    itemCount: currentOffers.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final offer = currentOffers[index];
                      return _buildOfferCard(offer);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 20, left: 24, right: 24),
      decoration: BoxDecoration(
        color: navyColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
          bottomRight: Radius.circular(32.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
              onPressed: () {
                if (projectId != null) {
                  Get.back();
                } else {
                  Get.find<ClientDashboardController>().changePage(0);
                }
              },
            ),
          ),
          Text(
            projectId != null ? 'عروض المشروع' : 'العروض الواردة',
            style: const TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 22),
              onPressed: controller.fetchOffers,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Obx(() => Row(
        children: [
          _buildTabItem('عروض المشاريع العامة', 0),
          _buildTabItem('عروض المشاريع الخاصة', 1),
        ],
      )),
    );
  }

  Widget _buildTabItem(String label, int index) {
    bool isSelected = controller.currentIndex.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? orangeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: isSelected ? Colors.white : Colors.grey.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOfferCard(OfferModel offer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Name (Header)
          Row(
            children: [
              Icon(Icons.assignment_outlined, size: 14, color: orangeColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  offer.projectName ?? "مشروع غير محدد",
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, fontWeight: FontWeight.bold, color: orangeColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: navyColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: offer.providerAvatar != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              offer.providerAvatar!, 
                              fit: BoxFit.cover, 
                              errorBuilder: (c,e,s) => Icon(Icons.person, color: navyColor)
                            ),
                          )
                        : Icon(Icons.person_outline_rounded, color: navyColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(offer.providerName ?? "مزود خدمة", style: TextStyle(fontFamily: 'Tajawal', fontSize: 15, fontWeight: FontWeight.bold, color: navyColor)),
                      Text(offer.role ?? "", style: TextStyle(fontFamily: 'Tajawal', fontSize: 11, color: Colors.grey.shade500)),
                    ],
                  ),
                ],
              ),
              if (offer.statusLabel != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: navyColor.withOpacity(0.05), borderRadius: BorderRadius.circular(20)),
                  child: Text(offer.statusLabel!, style: TextStyle(fontFamily: 'Tajawal', color: navyColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text('${offer.rating}', style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: navyColor)),
                  const SizedBox(width: 4),
                  Text('(${offer.reviewsCount})', style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade400, fontSize: 11)),
                ],
              ),
              Text(offer.amount ?? "${offer.cost} ل.س", style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: orangeColor)),
            ],
          ),
          const Divider(height: 32),
          Row(
            children: [
              if (offer.status == 'pending') ...[
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => controller.acceptOffer(offer),
                    child: const Text('قبول', style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => controller.rejectOffer(offer),
                    child: const Text('رفض', style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navyColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Get.to(() => OfferDetailsScreen(offer: offer))?.then((val) {
                    if (val == true) controller.fetchOffers();
                  }),
                  child: const Text('التفاصيل', style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_late_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('لا توجد عروض حالياً لهذا الطلب', style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade500, fontSize: 16)),
        ],
      ),
    );
  }
}
