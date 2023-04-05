

import 'package:mycbt/src/screen/admin/admin_login.dart';
import 'package:mycbt/src/screen/cbt/favorite_courses.dart';
import 'package:mycbt/src/screen/documents/pdf_upload.dart';
import 'package:mycbt/src/screen/downloads.dart';
import 'package:mycbt/src/screen/notification.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/question/questions_view.dart';
import 'package:mycbt/src/screen/sidebar/drawer_widget.dart';
import 'package:mycbt/src/screen/web/home_page.dart';
import 'package:mycbt/src/services/activation_checker_service.dart';
import 'package:mycbt/src/services/message_service.dart';
import 'package:mycbt/src/services/notification_service.dart';
import 'package:mycbt/src/services/users_service.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/models/snippet.dart';
import 'package:mycbt/src/models/version.dart';
import 'package:mycbt/src/services/system_chrome.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:mycbt/src/widgets/daily_reward.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:mycbt/src/widgets/floating_action_button.dart';
import 'package:mycbt/src/widgets/home_screen_appbar.dart';
import 'package:mycbt/src/widgets/rate_app.dart';
import 'package:mycbt/src/widgets/upgrade_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Snippet? snippet;
UserModel? currentUser;
int points = 0;
bool subscribed = false;
int getPageIndex = 0;


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
  int exitCount = 0;
  bool isScrollingDown = false;
  int noteCount = 0;
  bool adReady = false;
  int titleIndex = 0;
  int unseenMessageCount = 0;
  int questionsCount = 0;
  bool questionsLoading = true;
  bool docLoading = true;
  bool visible = true;
  List titles = [
    "MY CBT",
    "Questions",
    "Share",
    "Favorite",
    "Downloads",
  ];
 


  void unreadNotifications() async {
    noteCount = await unSeenNotificationCount(currentUser);
    setState(() => noteCount = noteCount);
  }

  void unreadMessages() async {
    unseenMessageCount = await unSeenMessageCount(currentUser);
    setState(() => unseenMessageCount = unseenMessageCount);
  }



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
    unreadNotifications();
    unreadMessages();
    getUserInfo();
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
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await checkVersion();
        dailyReward(currentUser);

      });
    }
  }

  Future<void> getUserInfo() async {
    currentUser = await getUser(context);
    if (currentUser != null) {
       updateUserToken(currentUser!);
      subscribed = await activationChecker(
        userId: currentUser?.id, device: currentUser?.device, subscribed: currentUser?.subscribed);
      setState(() {
        points = currentUser!.points;
        currentUser = currentUser;
        subscribed = subscribed;
      });
    }
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  void whenPageChanges(int pageIndex) {
    setState(() {
      getPageIndex = pageIndex;
    });
  }

  void gotoGist() {
    onTapChangePage(1);
  }

  void onTapChangePage(int pageIndex) {
    setState(() {
      titleIndex = pageIndex;
    });
    pageController?.animateToPage(pageIndex,
        duration: const Duration(milliseconds: 400), curve: Curves.bounceInOut);
  }

  Scaffold buildHomeTab() {
    return Scaffold(
      drawer:  DrawerWidget(),
      appBar: homeAppBar(context,  unreadMessages, unreadNotifications, noteCount, unseenMessageCount, titles[titleIndex]),
        key: _scaffoldKey,
        body: PageView(
            controller: pageController,
            onPageChanged: whenPageChanges,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              HomeScreen(goto: gotoGist, user: currentUser),
              const QuestionsView("",),
              const PDFUploadScreen(),
               FavoriteCourses(),
              const DownloadScreen(),

            ]),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: ()=>onTapChangePage(0), color: getPageIndex == 0? kPrimaryColor : kGrey600, icon: const Icon(Icons.home)),
                IconButton(onPressed: ()=>onTapChangePage(1), color: getPageIndex == 1? kPrimaryColor : kGrey600, icon: const Icon(CupertinoIcons.question_circle)),
                IconButton(onPressed: ()=>onTapChangePage(2), color: kWhite, icon: const Icon(CupertinoIcons.question_circle)),
                IconButton(onPressed: ()=>onTapChangePage(3), color: getPageIndex == 3? kPrimaryColor : kGrey600, icon: const Icon(Icons.favorite_border)),
                IconButton(onPressed: ()=>onTapChangePage(4), color: getPageIndex == 4? kPrimaryColor : kGrey600,icon: const Icon(CupertinoIcons.book_circle)),
                // IconButton(
                // icon:  const IconBadge(
                //   icon: Icons.notifications,
                //   size: 25.0,
                //   count:10,
                // ), onPressed: ()=>onTapChangePage(4), color: getPageIndex == 4? kPrimaryColor : kGrey600,)
              ],
            ),
          )
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: InkWell(
          onTap: ()=>onTapChangePage(2),
          child: const FloatingActionButtonWidget()))
        ;
  }

  @override
  Widget build(BuildContext context) {
    systemChrome();
    return kIsWeb
        ? const HomePage()
        : WillPopScope(onWillPop: () => onWillPop(), child: buildHomeTab());
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
    double oldV = 3.7;
    versionRef.doc("25tqIfGs5H4aXWPBLbd1").get().then((value) {
    double? newV = Version.fromDocument(value).version;
      if (newV! > oldV) {
        double diff = (newV - oldV);
        if (diff <= 0.5) {
          Flushbar(
            title: "MY CBT",
            messageText: const Text(
              "A better version is now available! Get it now",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            duration: const Duration(minutes: 1),
            backgroundColor: Colors.black,
            flushbarPosition: FlushbarPosition.TOP,
            icon: const Icon(
              CupertinoIcons.rocket_fill,
              color: Colors.white,
            ),
            mainButton: ElevatedButton(
              style:  TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: Colors.green
              ),
              child: const Text(
                "Update",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
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

  Future<void> dailyReward(UserModel? currentUser) async {
    DateTime? date = currentUser!.lastSeen.toDate();
    int difference = DateTime.now().difference(date).inHours;
    if (difference > 23) {
      claimReward(context);
    }
    usersReference.doc(currentUser.id).update({"visited": DateTime.now()});
  }

  dynamic claimReward(mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return RewardDialog();
        });
  }
}
