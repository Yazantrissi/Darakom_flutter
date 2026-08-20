import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/search_providers_controller.dart';
import '../../models/user_model.dart';

class SearchProvidersScreen extends StatelessWidget {
  const SearchProvidersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchProvidersController controller = Get.put(SearchProvidersController());

    final Color navyColor = const Color(0xFF1A2A44);
    final Color orangeColor = const Color(0xFFF58A1E);
    final Color bgColor = const Color(0xFFF5F7FA);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: navyColor,
          elevation: 0,
          title: const Text('البحث عن مزود خدمة', style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: navyColor,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32.0), bottomRight: Radius.circular(32.0)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: TextField(
                      controller: controller.searchController,
                      onChanged: controller.onSearch,
                      style: const TextStyle(fontFamily: 'Tajawal', color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: 'ابحث بالاسم أو بـ ID المزود...',
                        hintStyle: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade400, fontSize: 14),
                        prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    height: 40,
                    child: Obx(() => ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.categories.length,
                      itemBuilder: (context, index) {
                        final cat = controller.categories[index];
                        final bool isSelected = controller.selectedCategoryId.value == cat['id'];
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(cat['display_name'] ?? cat['name']),
                            selected: isSelected,
                            onSelected: (_) => controller.selectCategory(cat['id']),
                            selectedColor: orangeColor,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 12
                            ),
                            backgroundColor: Colors.white.withOpacity(0.1),
                            checkmarkColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        );
                      },
                    )),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.searchResults.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 60, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text('لا يوجد نتائج مطابقة للبحث', style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, color: Colors.grey.shade500)),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: controller.searchResults.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final provider = controller.searchResults[index];
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

  Widget _buildProviderCard(UserModel provider, SearchProvidersController controller, Color navyColor, Color orangeColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
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
                    child: Image.network(provider.profilePicture!, fit: BoxFit.cover, errorBuilder: (c, e, s) => Icon(Icons.person_outline_rounded, color: navyColor, size: 28)),
                  )
                : Icon(Icons.person_outline_rounded, color: navyColor, size: 28),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        provider.name,
                        style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: navyColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'ID: ${provider.id}',
                      style: TextStyle(fontFamily: 'Tajawal', fontSize: 12, color: orangeColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(provider.roleName ?? provider.type, style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, color: Colors.grey.shade500)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        const Text('0.0', style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A2A44))),
                      ],
                    ),
                    TextButton(
                      onPressed: () => controller.inviteToProject(provider),
                      child: Text('دعوة لمشروع', style: TextStyle(color: orangeColor, fontSize: 12, fontWeight: FontWeight.bold)),
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
