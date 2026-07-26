import 'package:get/get.dart';

class ProviderDashboardController extends GetxController {
  // التحكم في شريط التنقل السفلي لمزود الخدمة
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }

  // إحصائيات سريعة للمزود
  final Map<String, dynamic> stats = {
    'activeProjects': 3,
    'pendingOffers': 5,
    'totalEarnings': '45,000 ر.س',
  };

  // قائمة الفرص الجديدة (المشاريع المطروحة من العملاء وتناسب تخصص المزود)
  final List<Map<String, dynamic>> newOpportunities = [
    {
      'id': 201,
      'projectName': 'بناء ملحق خارجي - حي الملقا',
      'clientName': 'محمد العتيبي',
      'publishDate': 'منذ ساعتين',
      'budget': 'غير محدد',
    },
    {
      'id': 202,
      'projectName': 'تجديد واجهة عمارة سكنية',
      'clientName': 'أحمد خالد',
      'publishDate': 'منذ 5 ساعات',
      'budget': '15,000 - 25,000 ر.س',
    },
  ];

  // قائمة مشاريع المزود قيد التنفيذ
  final List<Map<String, dynamic>> activeProjects = [
    {
      'id': 301,
      'projectName': 'فيلا سكنية - حي الياسمين',
      'progress': 0.65, // 65%
      'nextMilestone': 'الانتهاء من أعمال العظم',
    },
  ];
}