import 'package:mycbt/src/screen/welcome/splashscreen.dart';
import 'package:mycbt/src/screen/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/services/file_service.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MappingPage extends StatefulWidget {
  @override
  _MappingPageState createState() => _MappingPageState();
}

enum AuthStatus { welcome, homeView, isLoading }

class _MappingPageState extends State<MappingPage> {
  DocumentsDirectory documentsDirectory = DocumentsDirectory();
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  AuthStatus authStatus = AuthStatus.isLoading;
  int isDynamicLink = 0;
  String referalCode = "";
  String userId = "";

  @override
  void initState() {
    super.initState();
  
      handleView();
  
    
  }

  void handleView() async {
    //check if this is the first time of lauching app
    if(kIsWeb){
       setState(() => authStatus = AuthStatus.homeView);
      }else{
        bool exist = await firstLaunch();
        if (!exist) {
          await initDynamicLinks();
          createwelcomeFile("welcome");
          setState(() => authStatus = AuthStatus.welcome);
        } else {
        setState(() => authStatus = AuthStatus.homeView);
    }
  }

   
    //remove splash
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.welcome:
        return const WelcomeScreen();
      case AuthStatus.isLoading:
        return SplashScreen();
      case AuthStatus.homeView:
        return const HomeTab(
          view: "",
        );
    }
  }

//get parameters from invitation link
  Future initDynamicLinks() async {
    dynamicLinks.onLink.listen((data) {
      final Uri? deepLink = data.link;
      if (deepLink != null) {
        var isWelcome = deepLink.pathSegments.contains("welcome");
        if (isWelcome) {
          referalCode = deepLink.queryParameters['referalCode'].toString();

          //reward the inviter with 20 points
          userId = deepLink.queryParameters['userId'].toString();

          setState(() {
            referalCode = referalCode;
            userId = userId;
          });
          //store referal code for future reward of 10% when currentUser subscribed
          if(!kIsWeb){
             storeReffererId(userId);
          }
         
        }
      }
    }).onError((error) {
      print(error);
    });
  }
}
