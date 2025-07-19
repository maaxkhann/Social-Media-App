import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:social_media/firebase_options.dart';
import 'package:social_media/routes/app_pages.dart';
import 'package:social_media/routes/app_routes.dart';
import 'package:social_media/services/notification_service.dart';
import 'package:social_media/theme/light_theme.dart';
import 'package:social_media/views/auth/login_view.dart';

final NotificationServices notificationServices = NotificationServices();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print("Handling background message: ${message.messageId}");
  }
  // You can handle background data here or show local notification
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Setup foreground notification presentation for iOS
  await notificationServices.forgroundMessage();

  // Initialize local notifications once
  notificationServices.requestNotificationPermission();
  notificationServices.getDeviceToken();
  notificationServices.firebaseInit();
  notificationServices.isTokenRefresh();
  notificationServices.setupInteractMessage();

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
      initialRoute: AppRoutes.splashView,
      getPages: AppPages.routes,
      // darkTheme: darkTheme,
      home: const LoginView(),
    );
  }
}
