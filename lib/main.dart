import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/project_service.dart';
import 'services/offer_service.dart';
import 'services/interaction_service.dart';
import 'services/profile_service.dart';
import 'views/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Services
  Get.put(ApiService());
  Get.put(AuthService());
  Get.put(ProjectService());
  Get.put(OfferService());
  Get.put(InteractionService());
  Get.put(ProfileService());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Darakom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Tajawal',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A2A44)),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
