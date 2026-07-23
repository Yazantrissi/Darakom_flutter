import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/client_offers_controller.dart';
import '../../controllers/home/client_dashboard_controller.dart'; // استيراد متحكم لوحة التحكم
import 'offer_details_screen.dart';

class ClientOffersScreen extends StatelessWidget {
  ClientOffersScreen({super.key});

  final ClientOffersController controller = Get.put(ClientOffersController());

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
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                itemCount: controller.offers.length,
                separatorBuilder: (context, index) => const SizedBox(height: 24),
                itemBuilder: (context, index) {
                  final offer = controller.offers[index];
                  return _buildOfferCard(offer);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- دوال بناء الواجهة --- //

  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 24, left: 24, right: 24),
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
          // زر العودة المعدل (ينتقل للتبويب 0 في الشريط السفلي)
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
            'العروض المتاحة',
            style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.search_rounded, color: Colors.white, size: 22),
              onPressed: controller.onSearchTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
            child: Container(
              height: 140,
              color: Colors.grey.shade300,
              child: const Icon(Icons.apartment_rounded, size: 50, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (offer['badge'] != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: orangeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          offer['badge'],
                          style: TextStyle(fontFamily: 'Tajawal', color: orangeColor, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      )
                    else
                      const SizedBox(),

                    Row(
                      children: [
                        Text('(${offer['reviewsCount']})', style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade500, fontSize: 12)),
                        const SizedBox(width: 4),
                        Text('${offer['rating']}', style: TextStyle(fontFamily: 'Tajawal', color: navyColor, fontSize: 13, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4),
                        const Icon(Icons.star_rounded, color: Colors.orange, size: 18),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(offer['providerName'], style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: navyColor)),
                const SizedBox(height: 4),
                Text(offer['role'], style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, color: Colors.grey.shade500)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(offer['price'], style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: orangeColor)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orangeColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      ),
                      onPressed: () {
                        // الانتقال إلى شاشة تفاصيل العرض
                        Get.to(() => OfferDetailsScreen());
                      },
                      child: const Text('عرض التفاصيل', style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}