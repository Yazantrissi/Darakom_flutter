import 'package:get/get.dart';

class RatingsController extends GetxController {
  // 1. تقييمات قدمتها (العميل يقيم مزود الخدمة)
  final List<Map<String, dynamic>> givenRatings = [
    {
      'providerName': 'مؤسسة البناء الحديث',
      'projectName': 'بناء ملحق خارجي - حي الملقا',
      'rating': 5.0,
      'comment': 'عمل احترافي جداً والتزام تام بالمواعيد المتفق عليها. أنصح بالتعامل معهم بشدة.',
      'date': '2026-06-15',
    },
    {
      'providerName': 'مكتب الأفق الهندسي',
      'projectName': 'تصميم داخلي - مكتب تجاري',
      'rating': 4.0,
      'comment': 'التصميم كان رائعاً ومطابقاً للتوقعات، لكن كان هناك تأخير بسيط في تسليم التعديلات النهائية.',
      'date': '2026-02-20',
    },
  ];

  // 2. تقييمات حصلت عليها (مزود الخدمة يقيم العميل)
  final List<Map<String, dynamic>> receivedRatings = [
    {
      'reviewerName': 'م. خالد الشمري',
      'projectName': 'تصميم داخلي - مكتب تجاري',
      'rating': 5.0,
      'comment': 'عميل راقي جداً في التعامل، متطلباته واضحة وملتزم بالدفعات في وقتها. سعدت بالعمل معه.',
      'date': '2026-02-22',
    },
    {
      'reviewerName': 'شركة الإنشاءات الحديثة',
      'projectName': 'تأسيس شبكة كهرباء',
      'rating': 4.5,
      'comment': 'تجربة عمل ممتازة وتواصل سلس طوال فترة المشروع.',
      'date': '2025-12-10',
    },
  ];
}