import 'package:get/get.dart';
import '../../views/home/add_project_screen.dart';
import '../../views/home/search_providers_screen.dart'; // استيراد شاشة البحث الجديدة

class ClientDashboardController extends GetxController {
  // التحكم في شريط التنقل السفلي[cite: 8]
  var currentIndex = 0.obs;

  // دالة تغيير التبويبات[cite: 8]
  void changePage(int index) {
    currentIndex.value = index;
  }

  // دالة الانتقال لشاشة البحث عن مزودي الخدمة
  void goToSearchProviders() {
    Get.to(() => SearchProvidersScreen());
  }

  // --- المشاريع قيد الانتظار ---[cite: 8]
  final List<Map<String, dynamic>> pendingProjects = [
    {
      'projectName': 'بناء ملحق خارجي - حي الملقا',
      'publishDate': '2026-07-10',
      'offersCount': 4,
      'status': 'بانتظار اختيار مقاول',
    },
    {
      'projectName': 'تجديد واجهة عمارة سكنية',
      'publishDate': '2026-07-12',
      'offersCount': 1,
      'status': 'تلقي العروض',
    },
  ];

  // بيانات افتراضية لقسم "مشاريع قيد الإنشاء"[cite: 8]
  final List<Map<String, dynamic>> activeProjects = [
    {'projectName': 'فيلا سكنية - حي الياسمين', 'progress': 0.65, 'deliveryDate': '2026-11-01'},
    {'projectName': 'مشروع التشطيب - المدينة', 'progress': 0.30, 'deliveryDate': '2026-06-01'},
  ];

  // بيانات افتراضية لقسم "المشاريع المنتهية"[cite: 8]
  final List<Map<String, dynamic>> completedProjects = [
    {'projectName': 'تصميم داخلي - مكتب تجاري', 'completionDate': '2026-02-10'},
    {'projectName': 'تأسيس شبكة كهرباء', 'completionDate': '2025-12-05'},
  ];

  // الانتقال لشاشة إضافة مشروع جديد[cite: 8]
  void addNewProject() {
    Get.to(() => AddProjectScreen());
  }
}