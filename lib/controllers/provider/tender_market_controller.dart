import 'package:get/get.dart';
import '../../views/provider/project_details_screen.dart';

class TenderMarketController extends GetxController {
  // التحكم في التبويبات (عامة = 0 / خاصة = 1)
  var currentTabIndex = 0.obs;

  // قائمة المناقصات العامة (Mock Data)
  final List<Map<String, dynamic>> publicTenders = [
    {
      'id': 1001,
      'projectName': 'بناء فيلا سكنية - دمشق',
      'clientName': 'أحمد المحمد',
      'location': 'المزة، دمشق',
      'budget': '50,000,000 - 70,000,000 ل.س',
      'date': 'منذ ساعتين',
      'isUrgent': true,
    },
    {
      'id': 1002,
      'projectName': 'تجديد ديكور شقة - حلب',
      'clientName': 'سارة خالد',
      'location': 'الشهباء، حلب',
      'budget': '15,000,000 ل.س',
      'date': 'منذ 5 ساعات',
      'isUrgent': false,
    },
  ];

  // قائمة المناقصات الخاصة (الموجهة للمزود مباشرة)
  final List<Map<String, dynamic>> privateTenders = [
    {
      'id': 2001,
      'projectName': 'تأسيس شبكة كهرباء - ريف دمشق',
      'clientName': 'شركة النور العقارية',
      'location': 'صحنايا، ريف دمشق',
      'budget': 'اتفاق مسبق',
      'date': 'أمس',
      'isUrgent': true,
    },
  ];

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  void viewTenderDetails(int tenderId) {
    // العثور على بيانات المناقصة من القائمة (لغرض العرض التجريبي)
    final tender = [...publicTenders, ...privateTenders].firstWhere((element) => element['id'] == tenderId);
    
    // الانتقال لواجهة تفاصيل المشروع مع تمرير البيانات
    Get.to(() => ProjectDetailsScreen(projectData: tender));
  }
}
