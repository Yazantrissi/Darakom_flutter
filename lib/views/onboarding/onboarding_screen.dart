import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white, // خلفية بيضاء نقية للرسومات
        body: SafeArea(
          child: Column(
            children: [
              // زر التخطي (Skip)
              Align(
                alignment: Alignment.topLeft, // في اليسار لأن الواجهة RTL
                child: TextButton(
                  onPressed: controller.skip,
                  child: const Text(
                    'تخطي',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // منطقة الرسومات والنصوص (PageView)
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.pages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // مساحة الرسم التوضيحي (Illustration)
                          // ملاحظة: استبدل Icon بـ Image.asset عند توفر الصور
                          Container(
                            height: 280,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F7FA), // لون خلفية ناعم للرسم
                              shape: BoxShape.circle, // شكل دائري لاحتواء الأيقونة
                            ),
                            child: Icon(
                              controller.pages[index]['icon'],
                              size: 120,
                              color: const Color(0xFF1A2A44), // الكحلي الداكن
                            ),
                          ),
                          const SizedBox(height: 48),

                          // العنوان الرئيسي
                          Text(
                            controller.pages[index]['title'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A2A44),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // العنوان الفرعي
                          Text(
                            controller.pages[index]['subtitle'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 16,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // منطقة المؤشر (Dot Indicators) والزر
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    // مؤشر النقاط
                    Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.pages.length,
                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          height: 8,
                          width: controller.currentPage.value == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: controller.currentPage.value == index
                                ? const Color(0xFFF58A1E) // برتقالي للصفحة الحالية
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    )),
                    const SizedBox(height: 32),

                    // زر "ابدأ الآن" أو "التالي"
                    Obx(() {
                      bool isLastPage = controller.currentPage.value == controller.pages.length - 1;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF58A1E), // البرتقالي الحيوي
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onPressed: isLastPage ? controller.startNow : controller.nextPage,
                          child: Text(
                            isLastPage ? 'ابدأ الآن' : 'التالي',
                            style: const TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}