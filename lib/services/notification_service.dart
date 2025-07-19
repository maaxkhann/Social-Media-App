import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:social_media/constants/app_colors.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(RemoteMessage message) async {
    var androidInitializationSettings = const AndroidInitializationSettings(
      'ic_launcher',
    );
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload) {
        // handle interaction when app is active for android
        handleMessage(message);
      },
    );
  }

  void firebaseInit() {
    print('initttttttttttttttfffff');
    FirebaseMessaging.onMessage.listen((message) {
      print('onmesssageeeeeeeeeeeeee');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        print('data:${message.data.toString()}');
      }

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotifications(message);
        showNotification(message);
      }
    });
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    // AndroidNotificationChannel channel = AndroidNotificationChannel(
    //     message.notification!.android!.channelId.toString(),
    //     message.notification!.android!.channelId.toString(),
    //     importance: Importance.max,
    //     showBadge: true,
    //     playSound: true,
    //   text  sound: const RawResourceAndroidNotificationSound('jetsons_doorbell'));

    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
          'Channel ID',
          'Channel title',
          priority: Priority.high,
          importance: Importance.max,
          icon: 'ic_launcher',
          ticker: 'test',
          colorized: true,
          color: AppColors.yellow,
          // ledColor: AppColor.green,
          // ledOffMs: 1,
          // ledOnMs: 1,
          // ledColor: AppColor.green,
          // styleInformation: BigPictureStyleInformation(
          //     DrawableResourceAndroidBitmap("notification_bg")),
          // color: AppColor.green
        );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        Random().nextInt(1000000),
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  //function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage() async {
    // when app is terminated
    // RemoteMessage? initialMessage =
    //     await FirebaseMessaging.instance.getInitialMessage();

    // if (initialMessage != null) {
    //   handleMessage(initialMessage);
    // }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('notificationnnnnnnnnn');
      handleMessage(event);
    });
  }

  void handleMessage(RemoteMessage message) {
    print("this is message handler");
    print('data:${message.data.toString()}');
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  NotificationDetails get notificationDetails => const NotificationDetails(
    android: AndroidNotificationDetails(
      'scheduleSocialMedia',
      'Schedule SocialMedia',
      importance: Importance.max,
      priority: Priority.high,
      colorized: true,
      // ledColor: AppColor.green,
      color: AppColors.yellow,
    ),
    iOS: DarwinNotificationDetails(),
  );

  Future<void> sendFCMNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    const String serverKey =
        'YOUR_SERVER_KEY_HERE'; // Get it from Firebase Console > Project Settings > Cloud Messaging

    final data = {
      "to": token,
      "notification": {"title": title, "body": body, "sound": "default"},
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
      },
    };

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "key=$serverKey",
    };

    final response = await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print("Notification sent successfully");
    } else {
      print("Failed to send notification: ${response.body}");
    }
  }

  // Future scheduleNotification({
  //   int id = 0,
  //   String? title,
  //   String? body,
  //   String? payLoad,
  //   required int scheduledNotificationDateTime,
  // }) async {
  //   // print(scheduledNotificationDateTime);
  //   // print("scheduledNotificationDateTime");
  //   await _flutterLocalNotificationsPlugin.zonedSchedule(
  //     id,
  //     title,
  //     body,
  //     // tz.TZDateTime.now(tz.local)
  //     //     .add(Duration(seconds: scheduledNotificationDateTime)),
  //     tz.TZDateTime.now(
  //       tz.local,
  //     ).add(Duration(hours: scheduledNotificationDateTime)),
  //     notificationDetails,
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //   );
  // }
}
