import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services/api_service.dart';
import 'views/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Services
  Get.put(ApiService());
  
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
