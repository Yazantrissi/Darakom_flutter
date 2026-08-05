import 'package:flutter/material.dart';
import 'info_screen.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const InfoScreen(
      title: 'سياسة الخصوصية',
      content: 'نحن في داركم نولي اهتماماً كبيراً لخصوصية بياناتك.\n\n1. جمع البيانات: نقوم بجمع المعلومات الأساسية مثل الاسم ورقم الهاتف بهدف تحسين تجربتك.\n2. مشاركة البيانات: لا نقوم بمشاركة بياناتك مع أي طرف ثالث دون موافقتك الصريحة.\n3. أمان البيانات: نستخدم أحدث تقنيات التشفير لضمان سرية معلوماتك.',
    );
  }
}