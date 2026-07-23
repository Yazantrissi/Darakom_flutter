import 'package:get/get.dart';

class ClientOffersController extends GetxController {
  // بيانات العروض المطابقة لتصميم العميل
  final List<Map<String, dynamic>> offers = [
    {
      'id': 1,
      'providerName': 'مكتب الهندسي المتميز',
      'role': 'مقاول بناء',
      'rating': 4.8,
      'reviewsCount': 142,
      'badge': 'الأعلى تقييماً',
      'price': '٢٥٠,٠٠٠ ريال',
      'image': 'assets/images/offer1.jpg',
    },
    {
      'id': 2,
      'providerName': 'م. خالد الشمري',
      'role': 'معماري',
      'rating': 4.9,
      'reviewsCount': 203,
      'badge': 'الأسرع استجابة',
      'price': '١٨٥,٠٠٠ ريال',
      'image': 'assets/images/offer2.jpg',
    },
    {
      'id': 3,
      'providerName': 'شركة الإنشاءات الحديثة',
      'role': 'مهندس مدني',
      'rating': 4.6,
      'reviewsCount': 98,
      'badge': null,
      'price': '٣١٠,٠٠٠ ريال',
      'image': 'assets/images/offer3.jpg',
    },
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