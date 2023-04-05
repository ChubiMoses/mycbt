import 'package:mycbt/main.dart';
import 'package:mycbt/src/screen/welcome/mapping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mycbt/src/services/scroll_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:material_color_generator/material_color_generator.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

     const styleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(""),
        largeIcon: FilePathAndroidBitmap(""));


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
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
                styleInformation: styleInformation,
                icon: '@drawable/ic_logo',
              ),
            ));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'My CBT',
      theme: themeData(),
      home: MappingPage(),
    );
  }

  ThemeData themeData() {
    return ThemeData(
        brightness: Brightness.light,
        primaryColor: generateMaterialColor(color: const Color(0xFF05A95C)),
        primarySwatch:generateMaterialColor(color: const Color(0xFF05A95C)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: "OpenSans",
        textTheme: const TextTheme(
            titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)));
  }
}
