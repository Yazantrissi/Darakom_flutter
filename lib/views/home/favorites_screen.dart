import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/favorites_controller.dart';
import '../../models/user_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesController controller = Get.put(FavoritesController());

    final Color navyColor = const Color(0xFF1A2A44);
    final Color orangeColor = const Color(0xFFF58A1E);
    final Color bgColor = const Color(0xFFF5F7FA);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            _buildCustomHeader(navyColor, orangeColor),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.favoriteProviders.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.favoriteProviders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border_rounded, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text('لا يوجد مزودين في المفضلة حالياً', 
                          style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade500, fontSize: 16)),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: controller.favoriteProviders.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final provider = controller.favoriteProviders[index];
                    return _buildProviderCard(provider, controller, navyColor, orangeColor, bgColor);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader(Color navyColor, Color orangeColor) {
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
            'المفضلة',
            style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildProviderCard(UserModel provider, FavoritesController controller, Color navyColor, Color orangeColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: orangeColor.withOpacity(0.5)),
                ),
                child: provider.profilePicture != null 
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Image.network(provider.profilePicture!, fit: BoxFit.cover, errorBuilder: (c, e, s) => Icon(Icons.engineering_rounded, color: navyColor, size: 28)),
                      )
                    : Icon(Icons.engineering_rounded, color: navyColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.name,
                      style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: navyColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider.roleName ?? provider.type,
                      style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.favorite_rounded, color: Colors.redAccent),
                onPressed: () => controller.removeFavorite(provider.id),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade100, height: 1),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  onPressed: () => controller.inviteToProject(provider),
                  icon: const Icon(Icons.send_rounded, size: 16, color: Colors.white),
                  label: const Text('تقديم دعوة للمشروع', style: TextStyle(fontFamily: 'Tajawal', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: () => controller.viewProfile(provider),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: navyColor, width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('عرض الملف', style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, fontWeight: FontWeight.bold, color: navyColor)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
