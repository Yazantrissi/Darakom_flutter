import 'package:flutter/material.dart';
import 'info_screen.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const InfoScreen(
      title: 'من نحن',
      content: 'تطبيق داركم هو المنصة الرائدة لربط العملاء بأفضل مقدمي الخدمات في قطاع المقاولات والبناء. نسعى لتوفير بيئة موثوقة وآمنة لتسهيل إنجاز مشاريعكم بأعلى جودة وفي الوقت المحدد.\n\nتأسست منصتنا عام 2026 برؤية واضحة تهدف إلى رقمنة قطاع الخدمات...',
    );
  }
}