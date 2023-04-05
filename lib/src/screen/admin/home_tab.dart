import 'package:mycbt/src/screen/admin/conversation.dart';
import 'package:mycbt/src/screen/admin/schools_tab.dart';
import 'package:mycbt/src/screen/admin/typing/typing_dashboard.dart';
import 'package:mycbt/src/screen/admin/users_tab.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/widgets/bottom_tabs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AdminHomeTab extends StatefulWidget {
  AdminHomeTab({required this.view});
  final String view;
  @override
  _AdminHomeTabState createState() => _AdminHomeTabState();
}

class _AdminHomeTabState extends State<AdminHomeTab> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? backbuttonpressedTime;
  PageController? pageController;
  int getPageIndex = 0;
  int exitCount = 0;
  bool isScrollingDown = false;
  int noteCount = 0;

  @override
  void initState() {
    super.initState();

    pageController = PageController();
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

  Scaffold buildAdminHomeTab() {
    return Scaffold(
        key: _scaffoldKey,
        body: PageView(
            children: <Widget>[
              SchoolsTab(),
              UsersTab(),
              AdminConversationView(),
              TypistScreen()
            ],
            controller: pageController,
            onPageChanged: whenPageChanges,
            physics: NeverScrollableScrollPhysics()),
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
              bottomTabs(context, CupertinoIcons.search_circle_fill, "Snippet"),
              bottomTabs(context, CupertinoIcons.chat_bubble_2, "Conversation"),
              bottomTabs(context, Icons.mouse, "Typing"),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return buildAdminHomeTab();
  }
}
