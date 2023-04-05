

import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/app.dart';
import 'package:mycbt/src/services/system_chrome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
     'High Importance Notifications', // title
    importance: Importance.high,
    playSound: true,
    );

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
      options: kIsWeb ?  const FirebaseOptions(
        apiKey: "AIzaSyCrsr0tcw17UITQZXjxTmB35M6CahsSfd4",
        authDomain: "cbt-exams-bc05c.firebaseapp.com",
        projectId: "cbt-exams-bc05c",
        messagingSenderId: "996516312046",
        appId: "1:996516312046:web:4c416f3e6d4054511114ff",
        measurementId: "G-RC0VZ5QSYT"
      ) : null
   );
   !kIsWeb ? MobileAds.instance.initialize() :null;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  
  systemChrome();

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
   RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: kPrimaryColor,
                playSound: true,
               // styleInformation: styleInformation,
                icon: '@drawable/ic_logo',
              ),
            ));
      }
  await Firebase.initializeApp();
}
