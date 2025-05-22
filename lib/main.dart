import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:social_media/firebase_options.dart';
import 'package:social_media/routes/app_pages.dart';
import 'package:social_media/routes/app_routes.dart';
import 'package:social_media/theme/light_theme.dart';
import 'package:social_media/views/auth/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social Media',
      theme: lightTheme,
      builder: EasyLoading.init(),
      initialRoute: AppRoutes.loginView,
      getPages: AppPages.routes,
      // darkTheme: darkTheme,
      home: const LoginView(),
    );
  }
}
