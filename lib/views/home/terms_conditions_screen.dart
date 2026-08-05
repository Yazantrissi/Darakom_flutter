import 'package:flutter/material.dart';
import 'info_screen.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const InfoScreen(
      title: 'الشروط والأحكام',
      content: 'يرجى قراءة هذه الشروط بعناية قبل استخدام التطبيق:\n\n1. الالتزام: استخدامك للتطبيق يعني موافقتك على الالتزام بجميع القوانين المحلية.\n2. العروض والمشاريع: المنصة غير مسؤولة عن جودة العمل النهائي، ولكنها توفر نظام تقييم لضمان الشفافية.\n3. الحسابات: يمنع إنشاء حسابات وهمية أو انتحال شخصيات أخرى.',
    );
  }
}