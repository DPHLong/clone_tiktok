import 'package:clone_tiktok/controller/auth_controller.dart';
import 'package:clone_tiktok/screens/login_screen.dart';
import 'package:clone_tiktok/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  try {
    await Firebase.initializeApp().then((value) {
      authController;
    });
  } catch (e) {
    debugPrint('--- Error by initializing: $e ---');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // using GetX for state management instead of StreamBuilder
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clone Tiktok',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: LoginScreen(),
    );
  }
}
