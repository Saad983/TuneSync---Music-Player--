import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions(); // ✅ Permission pehle le lo
  runApp(const MyApp());
}

// ✅ Startup par permission mangne wala method
Future<void> requestPermissions() async {
  if (await Permission.audio.isDenied) {
    await Permission.audio.request();
  }
  if (await Permission.storage.isDenied) {
    await Permission.storage.request();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder:
          (context, child) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          ),
    );
  }
}
