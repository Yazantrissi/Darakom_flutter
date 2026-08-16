import 'package:get/get.dart';
import '../../models/offer_model.dart';

class ClientOffersController extends GetxController {
  // بيانات العروض المطابقة لتصميم العميل
  final List<OfferModel> offers = [
    OfferModel(
      id: 1,
      projectId: 101,
      providerName: 'مكتب الهندسي المتميز',
      role: 'مقاول بناء',
      rating: 4.8,
      reviewsCount: 142,
      badge: 'الأعلى تقييماً',
      amount: '٢٥٠,٠٠٠ ريال',
      status: 'pending',
      cost: 250000,
      duration: 6,
      durationUnit: 'أشهر',
    ),
    OfferModel(
      id: 2,
      projectId: 101,
      providerName: 'م. خالد الشمري',
      role: 'معماري',
      rating: 4.9,
      reviewsCount: 203,
      badge: 'الأسرع استجابة',
      amount: '١٨٥,٠٠٠ ريال',
      status: 'pending',
      cost: 185000,
      duration: 4,
      durationUnit: 'أشهر',
    ),
    OfferModel(
      id: 3,
      projectId: 101,
      providerName: 'شركة الإنشاءات الحديثة',
      role: 'مهندس مدني',
      rating: 4.6,
      reviewsCount: 98,
      badge: null,
      amount: '٣١٠,٠٠٠ ريال',
      status: 'pending',
      cost: 310000,
      duration: 8,
      durationUnit: 'أشهر',
    ),
  ];

  void onSearchTap() {
    print("فتح نافذة البحث للعميل...");
  }

  void viewDetails(int id) {
    print("عرض تفاصيل العرض رقم: $id للعميل");
    // هنا سيتم الانتقال لشاشة التفاصيل الخاصة بالعميل
    // Get.to(() => ClientOfferDetailsScreen(offerId: id));
  }
}