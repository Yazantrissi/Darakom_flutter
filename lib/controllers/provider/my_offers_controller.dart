import 'package:get/get.dart';

class MyOffersController extends GetxController {
  // التبويبات (عروض عامة = 0 / عروض خاصة = 1)
  var currentTabIndex = 0.obs;

  // قائمة العروض العامة (Mock Data)
  final List<Map<String, dynamic>> publicOffers = [
    {
      'id': 5001,
      'projectName': 'بناء فيلا سكنية - دمشق',
      'status': 'قيد المراجعة',
      'price': '65,000,000 ل.س',
      'duration': '120 يوم',
      'date': '2023-10-25',
    },
    {
      'id': 5002,
      'projectName': 'تجديد ديكور شقة - حلب',
      'status': 'مرفوض',
      'price': '14,000,000 ل.س',
      'duration': '45 يوم',
      'date': '2023-10-20',
    },
  ].obs;

  // قائمة العروض الخاصة
  final List<Map<String, dynamic>> privateOffers = [
    {
      'id': 6001,
      'projectName': 'تأسيس شبكة كهرباء - ريف دمشق',
      'status': 'مقبول',
      'price': '8,500,000 ل.س',
      'duration': '15 يوم',
      'date': '2023-10-22',
    },
  ].obs;

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  void deleteOffer(int id, bool isPublic) {
    if (isPublic) {
      publicOffers.removeWhere((element) => element['id'] == id);
    } else {
      privateOffers.removeWhere((element) => element['id'] == id);
    }
    Get.snackbar('تم الحذف', 'تم حذف العرض بنجاح', snackPosition: SnackPosition.BOTTOM);
  }
}