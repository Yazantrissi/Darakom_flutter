import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectTrackingController extends GetxController {
  // نسبة إنجاز المشروع الإجمالية (مثال 65%)
  var progress = 0.65.obs;

  // مراحل سير العمل (Timeline)
  final List<Map<String, dynamic>> milestones = [
    {
      'title': 'توقيع العقد واستلام الدفعة الأولى',
      'isCompleted': true,
      'date': '2026-05-01',
    },
    {
      'title': 'الانتهاء من أعمال العظم (الهيكل)',
      'isCompleted': true,
      'date': '2026-06-15',
    },
    {
      'title': 'أعمال السباكة والكهرباء والتكييف',
      'isCompleted': false,
      'date': '2026-08-01',
    },
    {
      'title': 'التشطيب النهائي والتسليم',
      'isCompleted': false,
      'date': '2026-11-01',
    },
  ];

  // --- الدالة الجديدة لتقديم شكوى أثناء سير العمل ---
  void showComplaintDialog() {
    final TextEditingController complaintController = TextEditingController();
    Get.defaultDialog(
      title: 'تقديم شكوى',
      titleStyle: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 18, color: Colors.redAccent),
      content: Column(
        children: [
          const Text(
            'هل تواجه مشكلة مع المقاول أو تأخير في سير العمل؟',
            style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: complaintController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'اشرح تفاصيل المشكلة هنا ليتم التدخل من الإدارة...',
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
          Get.back(); // إغلاق النافذة
          Get.snackbar(
            'تم الاستلام',
            'تم رفع الشكوى للإدارة وسيتم التدخل بأسرع وقت لحل المشكلة.',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
          );
        } else {
          Get.snackbar(
            'تنبيه',
            'يرجى كتابة تفاصيل الشكوى أولاً',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
    );
  }
}