// ignore_for_file: deprecated_member_use

import 'package:mycbt/src/screen/admin/admin_login.dart';
import 'package:mycbt/src/screen/notification.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/question/questions_view.dart';
import 'package:mycbt/src/screen/search.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/models/snippet.dart';
import 'package:mycbt/src/models/version.dart';
import 'package:mycbt/src/services/system_chrome.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:mycbt/src/widgets/rate_app.dart';
import 'package:mycbt/src/widgets/upgrade_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/widgets/bottom_tabs.dart';
import 'package:flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Snippet? snippet;

class HomeTab extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const HomeTab({required this.view});
  final String view;
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? backbuttonpressedTime;
  PageController? pageController;
  int getPageIndex = 0;
  int exitCount = 0;
  bool isScrollingDown = false;
  int noteCount = 0;

  Future<void> getSnippet() async {
    await snippetRef.doc("25tqIfGs5H4aXWPBLbd1").get().then((value) {
      setState(() => snippet = Snippet.fromDocument(value));
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        if (message.data['navigation'] == "/notification") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NotificationScreen(refreshNotification: () {})));
        } else if (message.data['navigation'] == "/activation") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AdminLogin()));
        }
      }
    });
    pageController = PageController();
    handleData();
  }

  void updateUserToken(UserModel onlineUser) {
    firebaseMessaging.getToken().then((token) {
      usersReference.doc(onlineUser.id).update({'token': token});
    });
  }

  void handleData() {
    if (widget.view != "ExamMode") {
      getSnippet();
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        await checkVersion();
      });
    }
  }

  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  void whenPageChanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  void gotoGist() {
    onTapChangePage(1);
  }

  void onTapChangePage(int pageIndex) {
    pageController?.animateToPage(pageIndex,
        duration: Duration(milliseconds: 400), curve: Curves.bounceInOut);
  }

  Scaffold buildHomeTab() {
    return Scaffold(
        key: _scaffoldKey,
        body: PageView(
            children: <Widget>[
              HomeScreen(goto: gotoGist, user: currentUser),
              QuestionsView("",
              ),
              Search(),
            ],
            controller: pageController,
            onPageChanged: whenPageChanges,
            physics: const NeverScrollableScrollPhysics()),
        bottomNavigationBar: Material(
          elevation: 4.0,
          child: CupertinoTabBar(
            currentIndex: getPageIndex,
            onTap: onTapChangePage,
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Colors.black54,
            backgroundColor: kWhite,
            border: Border(top: BorderSide.none),
            items: [
              bottomTabs(context, Icons.home, "Home"),
              bottomTabs(context, CupertinoIcons.question_circle, "Questions"),
              bottomTabs(context, Icons.search, "Search"),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    systemChrome();
    return WillPopScope(onWillPop: () => onWillPop(), child: buildHomeTab());
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime!) >
            const Duration(seconds: 3);
    if (backButton) {
      backbuttonpressedTime = currentTime;
      await rateApp();
      displayToast("Double tab to exit app");
      return false;
    }
    return true;
  }

  rateApp() async {
    final result = await checkConnetion();
    if (result == 1) {
      if (currentUser?.rate == 0) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return RateApp();
            });
      }
    }
  }

  Future<void> checkVersion() async {
    String message = "";
    bool expired = false;
    double oldV = 3.0;
    versionRef.doc("25tqIfGs5H4aXWPBLbd1").get().then((value) {
      double? newV = Version.fromDocument(value).version;
      if (newV! > oldV) {
        double diff = (newV - oldV);
        if (diff <= 0.5) {
          Flushbar(
            title: "MY CBT Update.",
            messageText: const Text(
              "New version available, please update.",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            duration: const Duration(minutes: 1),
            backgroundColor: Colors.blueGrey,
            flushbarPosition: FlushbarPosition.TOP,
            icon: const Icon(
              CupertinoIcons.rocket_fill,
              color: Colors.white,
            ),
            mainButton: TextButton(
              child: const Text(
                "Update",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () => launchURL(
                  "https://play.google.com/store/apps/details?id=com.cc.MyCBT"),
            ),
          ).show(context);
        } else {
          message = "A new version of My CBT is available, Please update.";
          expired = true;
          upgradeApp(context, message, expired);
        }
      }
    });
  }

  dynamic upgradeApp(mContext, String message, bool expired) {
    return showDialog(
        context: mContext,
        barrierDismissible: expired,
        builder: (BuildContext context) {
          return WillPopScope(
              child: UpgradeApp(message: message, expired: expired),
              onWillPop: () => handleDialog(expired));
        });
  }

  handleDialog(bool expired) {
    if (expired) {
      return false;
    }
    return true;
  }
}
