import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../services/interaction_service.dart';

class PublicProviderProfileScreen extends StatelessWidget {
  final int providerId;

  PublicProviderProfileScreen({super.key, required this.providerId});

  final InteractionService _interactionService = Get.find<InteractionService>();
  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: navyColor,
          title: const Text('الملف الشخصي', style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>?>(
          future: _interactionService.fetchProviderPublicProfile(providerId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = snapshot.data;
            if (data == null) {
              return const Center(child: Text('تعذر جلب الملف الشخصي', style: TextStyle(fontFamily: 'Tajawal')));
            }
            final user = UserModel.fromJson(data);
            final works = (data['previous_works'] as List?) ?? [];
            final ratings = (data['ratings'] as List?) ?? [];

            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(user.name, style: TextStyle(fontFamily: 'Tajawal', fontSize: 22, fontWeight: FontWeight.bold, color: navyColor)),
                const SizedBox(height: 8),
                Text(user.providerType ?? user.specialty ?? 'مزود خدمة', style: TextStyle(fontFamily: 'Tajawal', color: orangeColor)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text('${user.averageRating ?? 0}', style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
                    const SizedBox(width: 16),
                    const Icon(Icons.location_on_outlined, size: 18, color: Colors.redAccent),
                    const SizedBox(width: 4),
                    Text(user.provinceName ?? user.city ?? 'غير محدد', style: const TextStyle(fontFamily: 'Tajawal')),
                  ],
                ),
                if (user.syndicateNumber != null && user.syndicateNumber!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text('الرقم النقابي: ${user.syndicateNumber}', style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
                ],
                if (user.bio != null && user.bio!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(user.bio!, style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade700, height: 1.6)),
                ],
                const SizedBox(height: 24),
                Text('الأعمال السابقة', style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: navyColor)),
                const SizedBox(height: 12),
                if (works.isEmpty)
                  Text('لا توجد أعمال سابقة', style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade500))
                else
                  ...works.map((w) {
                    final map = Map<String, dynamic>.from(w as Map);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(map['title']?.toString() ?? 'عمل سابق', style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
                          if (map['description'] != null)
                            Text(map['description'].toString(), style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade600)),
                        ],
                      ),
                    );
                  }),
                const SizedBox(height: 16),
                Text('التقييمات', style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: navyColor)),
                const SizedBox(height: 12),
                if (ratings.isEmpty)
                  Text('لا توجد تقييمات', style: TextStyle(fontFamily: 'Tajawal', color: Colors.grey.shade500))
                else
                  ...ratings.map((r) {
                    final map = Map<String, dynamic>.from(r as Map);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Expanded(child: Text(map['reviewer_name']?.toString() ?? 'عميل', style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold))),
                          Text('${map['score'] ?? ''}', style: const TextStyle(fontFamily: 'Tajawal')),
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                        ],
                      ),
                    );
                  }),
              ],
            );
          },
        ),
      ),
    );
  }
}
