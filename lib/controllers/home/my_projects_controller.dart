import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProjectsController extends GetxController {
  // 1. قائمة المشاريع قيد الانتظار (الجديدة)
  final List<Map<String, dynamic>> pendingProjects = [
    {
      'id': 101,
      'projectName': 'بناء ملحق خارجي - حي الملقا',
      'publishDate': '2026-07-10',
      'offersCount': 4, // عدد العروض المستلمة
      'status': 'بانتظار اختيار مقاول',
    },
    {
      'id': 102,
      'projectName': 'تجديد واجهة عمارة سكنية',
      'publishDate': '2026-07-12',
      'offersCount': 1,
      'status': 'تلقي العروض',
    },
  ];

  // 2. قائمة المشاريع قيد الإنشاء
  final List<Map<String, dynamic>> activeProjects = [
    {
      'projectName': 'فيلا سكنية - حي الياسمين',
      'progress': 0.65, // 65%
      'deliveryDate': '2026-11-01',
      'providerName': 'مؤسسة البناء الحديث',
    },
    {
      'projectName': 'مشروع التشطيب - المدينة',
      'progress': 0.30, // 30%
      'deliveryDate': '2026-06-01',
      'providerName': 'مكتب الأفق الهندسي',
    },
  ];

  // 3. قائمة المشاريع المنتهية
  final List<Map<String, dynamic>> completedProjects = [
    {
      'projectName': 'تصميم داخلي - مكتب تجاري',
      'completionDate': '2026-02-10',
      'providerName': 'م. خالد الشمري',
    },
    {
      'projectName': 'تأسيس شبكة كهرباء',
      'completionDate': '2025-12-05',
      'providerName': 'شركة الإنشاءات الحديثة',
    },
  ];

  // --- دوال التفاعل مع المشاريع المنتهية ---

  // دالة فتح نافذة التقييم
  void showRatingDialog(String projectName) {
    Get.defaultDialog(
      title: 'تقييم المشروع',
      titleStyle: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 18),
      content: Column(
        children: [
          Text('كيف كانت تجربتك في "$projectName"؟', style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          // نجوم التقييم الوهمية
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => const Icon(Icons.star_rounded, color: Colors.amber, size: 36)),
          ),
          const SizedBox(height: 16),
          TextField(
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'أضف تعليقك هنا (اختياري)...',
              hintStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
      textConfirm: 'إرسال التقييم',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFF58A1E),
      onConfirm: () {
        Get.back();
        Get.snackbar('شكراً لك', 'تم إرسال تقييمك بنجاح', backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  // دالة فتح نافذة تقديم شكوى
  void showComplaintDialog(String projectName) {
    final TextEditingController complaintController = TextEditingController();
    Get.defaultDialog(
      title: 'تقديم شكوى',
      titleStyle: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 18, color: Colors.redAccent),
      content: Column(
        children: [
          Text('المشروع: $projectName', style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          TextField(
            controller: complaintController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'اشرح تفاصيل المشكلة التي واجهتها...',
              hintStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
            ),
          ),
        ],
      ),
      textConfirm: 'إرسال الشكوى',
      textCancel: 'تراجع',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () {
        if (complaintController.text.isNotEmpty) {
          Get.back();
          Get.snackbar('تم الاستلام', 'تم رفع الشكوى للإدارة وسيتم التواصل معك قريباً', backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
        } else {
          Get.snackbar('تنبيه', 'يرجى كتابة تفاصيل الشكوى أولاً', backgroundColor: Colors.orange, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
        }
      },
    );
  }
}