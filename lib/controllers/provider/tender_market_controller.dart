import 'package:get/get.dart';
import '../../views/provider/project_details_screen.dart';
import '../../models/project_model.dart';

class TenderMarketController extends GetxController {
  // التحكم في التبويبات (عامة = 0 / خاصة = 1)
  var currentTabIndex = 0.obs;

  // قائمة المناقصات العامة (Mock Data)
  final List<ProjectModel> publicTenders = [
    ProjectModel(
      id: 1001,
      title: 'بناء فيلا سكنية - دمشق',
      clientName: 'أحمد المحمد',
      location: 'المزة، دمشق',
      budget: '50,000,000 - 70,000,000 ل.س',
      publishDate: 'منذ ساعتين',
      description: '',
      status: 'new',
    ),
    ProjectModel(
      id: 1002,
      title: 'تجديد ديكور شقة - حلب',
      clientName: 'سارة خالد',
      location: 'الشهباء، حلب',
      budget: '15,000,000 ل.س',
      publishDate: 'منذ 5 ساعات',
      description: '',
      status: 'new',
    ),
  ];

  // قائمة المناقصات الخاصة (الموجهة للمزود مباشرة)
  final List<ProjectModel> privateTenders = [
    ProjectModel(
      id: 2001,
      title: 'تأسيس شبكة كهرباء - ريف دمشق',
      clientName: 'شركة النور العقارية',
      location: 'صحنايا، ريف دمشق',
      budget: 'اتفاق مسبق',
      publishDate: 'أمس',
      description: '',
      status: 'private',
    ),
  ];

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  void viewTenderDetails(int tenderId) {
    // العثور على بيانات المناقصة من القائمة (لغرض العرض التجريبي)
    final tender = [...publicTenders, ...privateTenders].firstWhere((element) => element.id == tenderId);
    
    // الانتقال لواجهة تفاصيل المشروع مع تمرير البيانات
    Get.to(() => ProjectDetailsScreen(projectData: tender));
  }
}
