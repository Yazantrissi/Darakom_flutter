import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/ratings_controller.dart';

class RatingsScreen extends StatelessWidget {
  RatingsScreen({super.key});

  final RatingsController controller = Get.put(RatingsController());

  // الألوان الأساسية
  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);
  final Color bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2, // عدد التبويبات
        child: Scaffold(
          backgroundColor: bgColor,
          body: Column(
            children: [
              // 1. الهيدر الكحلي المنحني مع التبويبات
              _buildCustomHeader(),

              // 2. محتوى التبويبات
              Expanded(
                child: TabBarView(
                  children: [
                    _buildGivenRatingsList(),   // التقييمات التي قدمتها
                    _buildReceivedRatingsList(),// التقييمات التي حصلت عليها
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- دوال بناء الواجهة --- //

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
                'التقييمات',
                style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 48), // للتوسيط
            ],
          ),
          const SizedBox(height: 24),

          TabBar(
            indicatorColor: orangeColor,
            indicatorWeight: 3,
            labelColor: orangeColor,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 15, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 15),
            tabs: const [
              Tab(text: 'تقييمات قدمتها'),
              Tab(text: 'تقييمات حصلت عليها'),
            ],
          ),
        ],
      ),
    );
  }

  // 1. قائمة التقييمات التي قدمها العميل
  Widget _buildGivenRatingsList() {
    if (controller.givenRatings.isEmpty) return _buildEmptyState('لم تقم بتقديم أي تقييمات بعد');

    return ListView.separated(
      padding: const EdgeInsets.all(24.0),
      itemCount: controller.givenRatings.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final rating = controller.givenRatings[index];
        return _buildRatingCard(
          personName: rating['providerName'],
          personTitle: 'مزود الخدمة',
          projectName: rating['projectName'],
          ratingValue: rating['rating'],
          comment: rating['comment'],
          date: rating['date'],
        );
      },
    );
  }

  // 2. قائمة التقييمات التي حصل عليها العميل
  Widget _buildReceivedRatingsList() {
    if (controller.receivedRatings.isEmpty) return _buildEmptyState('لم تحصل على أي تقييمات بعد');

    return ListView.separated(
      padding: const EdgeInsets.all(24.0),
      itemCount: controller.receivedRatings.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final rating = controller.receivedRatings[index];
        return _buildRatingCard(
          personName: rating['reviewerName'],
          personTitle: 'المُقيِّم',
          projectName: rating['projectName'],
          ratingValue: rating['rating'],
          comment: rating['comment'],
          date: rating['date'],
        );
      },
    );
  }

  // تصميم كرت التقييم الموحد
  Widget _buildRatingCard({
    required String personName,
    required String personTitle,
    required String projectName,
    required double ratingValue,
    required String comment,
    required String date,
  }) {
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
          // رأس الكرت: الاسم والتقييم
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(personTitle, style: TextStyle(fontFamily: 'Tajawal', fontSize: 12, color: Colors.grey.shade500)),
                    const SizedBox(height: 4),
                    Text(
                      personName,
                      style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: navyColor),
                    ),
                  ],
                ),
              ),
              _buildStars(ratingValue),
            ],
          ),
          const SizedBox(height: 16),

          // اسم المشروع (داخل حاوية رمادية فاتحة لتمييزه)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.assignment_outlined, size: 16, color: orangeColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    projectName,
                    style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, fontWeight: FontWeight.bold, color: navyColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // التعليق
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.format_quote_rounded, color: Colors.grey.shade300, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  comment,
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, color: Colors.grey.shade700, height: 1.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade100, height: 1),
          const SizedBox(height: 12),

          // التاريخ
          Row(
            children: [
              Icon(Icons.date_range_outlined, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text(
                'تاريخ التقييم: $date',
                style: TextStyle(fontFamily: 'Tajawal', fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لرسم النجوم
  Widget _buildStars(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star_rounded, color: Colors.amber, size: 18);
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(Icons.star_half_rounded, color: Colors.amber, size: 18);
        } else {
          return const Icon(Icons.star_outline_rounded, color: Colors.amber, size: 18);
        }
      }),
    );
  }

  // دالة في حال كانت القائمة فارغة
  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_border_rounded, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(fontFamily: 'Tajawal', fontSize: 15, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}