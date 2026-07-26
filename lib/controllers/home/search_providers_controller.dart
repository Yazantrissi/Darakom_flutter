import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchProvidersController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  // قائمة وهمية لجميع مزودي الخدمة في المنصة
  final List<Map<String, dynamic>> allProviders = [
    {'id': '1001', 'name': 'مؤسسة البناء الحديث', 'specialty': 'مقاولات عامة', 'rating': 4.9},
    {'id': '1002', 'name': 'مكتب الأفق الهندسي', 'specialty': 'تصميم وإشراف هندسي', 'rating': 4.8},
    {'id': '1003', 'name': 'م. خالد الشمري', 'specialty': 'تصميم داخلي', 'rating': 4.7},
    {'id': '1004', 'name': 'شركة الإنشاءات الحديثة', 'specialty': 'مقاولات عامة', 'rating': 4.5},
    {'id': '1005', 'name': 'مؤسسة السباك المحترف', 'specialty': 'سباكة', 'rating': 4.2},
  ];

  // القائمة التفاعلية التي ستعرض النتائج المفلترة
  var searchResults = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // عرض جميع المزودين كحالة افتراضية عند فتح الشاشة
    searchResults.assignAll(allProviders);
  }

  // دالة البحث (تعمل عند كتابة أي حرف)
  void onSearch(String query) {
    if (query.isEmpty) {
      searchResults.assignAll(allProviders);
      return;
    }

    // فلترة القائمة بناءً على الاسم أو الـ ID
    var filteredList = allProviders.where((provider) {
      final nameLower = provider['name'].toString().toLowerCase();
      final idLower = provider['id'].toString().toLowerCase();
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower) || idLower.contains(searchLower);
    }).toList();

    searchResults.assignAll(filteredList);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}