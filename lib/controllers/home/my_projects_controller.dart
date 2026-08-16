import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/project_model.dart';

class MyProjectsController extends GetxController {
  // 1. قائمة المشاريع قيد الانتظار (الجديدة)
  var pendingProjects = <ProjectModel>[
    ProjectModel(
      id: 101,
      title: 'بناء ملحق خارجي - حي الملقا',
      description: 'أرغب في بناء ملحق خارجي بمساحة 20 متر مربع مع دورة مياه وتشطيب كامل.',
      area: '20',
      governorate: 'دمشق',
      address: 'حي الملقا - شارع الثلاثين',
      type: 'إنشاء',
      specialization: 'مقاول',
      publishDate: '2026-07-10',
      offersCount: 4,
      status: 'بانتظار اختيار مقاول',
      duration: 15,
    ),
    ProjectModel(
      id: 102,
      title: 'تجديد واجهة عمارة سكنية',
      description: 'تجديد واجهة عمارة سكنية مكونة من 4 طوابق، تشمل الدهان وبعض الأعمال الحجرية.',
      area: '450',
      governorate: 'حلب',
      address: 'حي الحمدانية - رابع حي',
      type: 'تشطيب',
      specialization: 'دهان',
      publishDate: '2026-07-12',
      offersCount: 1,
      status: 'تلقي العروض',
      duration: 10,
    ),
  ].obs;

  void deletePendingProject(int id) {
    pendingProjects.removeWhere((p) => p.id == id);
  }

  void updatePendingProject(ProjectModel updatedProject) {
    int index = pendingProjects.indexWhere((p) => p.id == updatedProject.id);
    if (index != -1) {
      pendingProjects[index] = updatedProject;
      pendingProjects.refresh();
    }
  }

  // 2. قائمة المشاريع قيد الإنشاء
  final List<ProjectModel> activeProjects = [
    ProjectModel(
      id: 201,
      title: 'فيلا سكنية - حي الياسمين',
      progressPercentage: 65,
      endDate: '2026-11-01',
      providerName: 'مؤسسة البناء الحديث',
      description: '',
      status: 'active',
    ),
    ProjectModel(
      id: 202,
      title: 'مشروع التشطيب - المدينة',
      progressPercentage: 30,
      endDate: '2026-06-01',
      providerName: 'مكتب الأفق الهندسي',
      description: '',
      status: 'active',
    ),
  ];

  // 3. قائمة المشاريع المنتهية
  final List<ProjectModel> completedProjects = [
    ProjectModel(
      id: 301,
      title: 'تصميم داخلي - مكتب تجاري',
      endDate: '2026-02-10',
      providerName: 'م. خالد الشمري',
      description: '',
      status: 'completed',
    ),
    ProjectModel(
      id: 302,
      title: 'تأسيس شبكة كهرباء',
      endDate: '2025-12-05',
      providerName: 'شركة الإنشاءات الحديثة',
      description: '',
      status: 'completed',
    ),
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