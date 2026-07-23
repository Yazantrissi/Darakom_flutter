import 'package:get/get.dart';

class ComplaintsController extends GetxController {
  // 1. الشكاوي قيد المراجعة
  final List<Map<String, dynamic>> pendingComplaints = [
    {
      'complaintId': '#CMP-1042',
      'defendant': 'مؤسسة البناء الحديث',
      'projectName': 'فيلا سكنية - حي الياسمين',
      'description': 'تأخير غير مبرر في تسليم المرحلة الثانية من العظم (الهيكل) وعدم الرد على الاتصالات خلال الأسبوع الماضي.',
      'date': '2026-07-10',
    },
  ];

  // 2. الشكاوي التي تم حلها
  final List<Map<String, dynamic>> resolvedComplaints = [
    {
      'complaintId': '#CMP-0985',
      'defendant': 'شركة الإنشاءات الحديثة',
      'projectName': 'تأسيس شبكة كهرباء',
      'description': 'استخدام مواد تسليك غير مطابقة للمواصفات المتفق عليها في ملحق العقد.',
      'date': '2025-11-20',
      'resolution': 'تم إلزام المقاول بتغيير المواد على حسابه الخاص، وتم التسليم بنجاح.',
    },
  ];

  // 3. الشكاوي المرفوضة
  final List<Map<String, dynamic>> rejectedComplaints = [
    {
      'complaintId': '#CMP-0810',
      'defendant': 'م. خالد الشمري',
      'projectName': 'تصميم داخلي - مكتب تجاري',
      'description': 'عدم الرضا عن التصميم النهائي بالرغم من اعتمادي المسبق للمخطط ثنائي الأبعاد.',
      'date': '2025-08-05',
      'rejectionReason': 'تم رفض الشكوى نظراً لوجود اعتماد وتوقيع رسمي من قبلكم على كافة المخططات قبل البدء بالتنفيذ.',
    },
  ];
}