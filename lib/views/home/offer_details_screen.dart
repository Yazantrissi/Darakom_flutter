import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/offer_details_controller.dart';
import '../../models/offer_model.dart';
import 'public_provider_profile_screen.dart';

class OfferDetailsScreen extends StatelessWidget {
  final OfferModel offer;
  OfferDetailsScreen({super.key, required this.offer});

  late final OfferDetailsController controller = Get.put(OfferDetailsController()..setOffer(offer));

  // الألوان الأساسية
  final Color navyColor = const Color(0xFF1A2A44);
  final Color orangeColor = const Color(0xFFF58A1E);
  final Color bgColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // دعم الواجهة العربية
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: navyColor,
          elevation: 0,
          title: const Text('تفاصيل العرض', style: TextStyle(fontFamily: 'Tajawal', color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value && controller.offer.value.id == 0) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. بطاقة بيانات المقاول
                      _buildProviderInfo(),
                      const SizedBox(height: 24),

                      // 2. بطاقة السعر والمدة
                      _buildPriceAndDuration(),
                      const SizedBox(height: 24),

                      // 3. نبذة عن العمل
                      Text('نبذة عن العمل والتفاصيل:', style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: navyColor)),
                      const SizedBox(height: 12),
                      _buildWorkSummary(),
                      const SizedBox(height: 24),

                      // 4. الملفات والصور المرفقة
                      Text('الملفات والصور المرفقة:', style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: navyColor)),
                      const SizedBox(height: 12),
                      _buildAttachmentsSection(),
                    ],
                  ),
                ),
              ),

              // 5. الأزرار السفلية (القبول والرفض)
              if (controller.offer.value.status == 'pending')
                _buildActionButtons(),
            ],
          );
        }),
      ),
    );
  }

  // --- دوال بناء عناصر الواجهة --- //

  // بطاقة المقاول
  Widget _buildProviderInfo() {
    final o = controller.offer.value;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: orangeColor.withOpacity(0.5)),
            ),
            child: Icon(Icons.apartment_rounded, color: navyColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  o.providerName ?? "",
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: navyColor),
                ),
                const SizedBox(height: 4),
                Text(
                  o.specialty ?? "",
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, color: Colors.grey.shade500),
                ),
                if (o.providerId != null) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Get.to(() => PublicProviderProfileScreen(providerId: o.providerId!)),
                    child: Text('عرض الملف الشخصي', style: TextStyle(fontFamily: 'Tajawal', color: orangeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Text('${o.rating}', style: TextStyle(fontFamily: 'Tajawal', color: navyColor, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(width: 4),
                const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // بطاقة السعر والمدة (مقسمة نصفين)
  Widget _buildPriceAndDuration() {
    final o = controller.offer.value;
    return Row(
      children: [
        // السعر
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: orangeColor.withOpacity(0.3)),
              boxShadow: [BoxShadow(color: orangeColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.monetization_on_outlined, size: 18, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text('السعر الإجمالي', style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, color: Colors.grey.shade600)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  o.amount ?? "${o.cost} ل.س",
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: orangeColor),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // المدة
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: navyColor.withOpacity(0.1)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 18, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text('المدة الزمنية', style: TextStyle(fontFamily: 'Tajawal', fontSize: 13, color: Colors.grey.shade600)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "${o.duration} ${o.durationUnit}",
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold, color: navyColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // حاوية النبذة والتفاصيل
  Widget _buildWorkSummary() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Text(
        controller.offer.value.workSummary ?? "لا توجد تفاصيل إضافية.",
        style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, color: Colors.grey.shade700, height: 1.6),
      ),
    );
  }

  // قسم المرفقات (قائمة أفقية للصور والملفات)
  Widget _buildAttachmentsSection() {
    final List attachments = controller.offer.value.attachments ?? [];
    if (attachments.isEmpty) return const Text('لا توجد مرفقات', style: TextStyle(fontFamily: 'Tajawal', fontSize: 12));
    return SizedBox(
      height: 100, // ارتفاع بطاقة المرفق
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final file = attachments[index];
          // Determine if it's an image based on path or explicit type from model mapping
          bool isImage = file['file_type'] == 'image' || file['type'] == 'image';

          return Container(
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isImage ? Icons.image_outlined : Icons.picture_as_pdf_outlined,
                  color: isImage ? orangeColor : Colors.redAccent,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    file['description'] ?? 'ملحق',
                    style: TextStyle(fontFamily: 'Tajawal', fontSize: 10, color: Colors.grey.shade700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // الأزرار السفلية (قبول / رفض)
  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          // زر القبول (الأساسي)
          Expanded(
            flex: 2,
            child: Obx(() => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: orangeColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
              onPressed: controller.isLoading.value ? null : controller.acceptOffer,
              child: controller.isLoading.value
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('قبول العرض', style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            )),
          ),
          const SizedBox(width: 16),
          // زر الرفض (مفرغ باللون الأحمر)
          Expanded(
            flex: 1,
            child: OutlinedButton(
              onPressed: controller.rejectOffer,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.redAccent, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
              child: const Text('رفض', style: TextStyle(fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent)),
            ),
          ),
        ],
      ),
    );
  }
}
