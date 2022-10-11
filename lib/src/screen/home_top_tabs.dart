import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/models/question.dart';
import 'package:mycbt/src/models/questions.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/screen/cbt/courses_view.dart';
import 'package:mycbt/src/screen/cgpa/cgpa_tab.dart';
import 'package:mycbt/src/screen/home_view.dart';
import 'package:mycbt/src/screen/table/time_table.dart';
import 'package:mycbt/src/services/activation_checker_service.dart';
import 'package:mycbt/src/services/courses_service.dart';
import 'package:mycbt/src/services/message_service.dart';
import 'package:mycbt/src/services/notification_service.dart';
import 'package:mycbt/src/services/system_chrome.dart';
import 'package:mycbt/src/services/users_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/daily_reward.dart';
import 'package:mycbt/src/screen/sidebar/drawer_widget.dart';
import 'package:mycbt/src/widgets/home_screen_appbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

bool subscribed = false;
UserModel? currentUser;
int points = 0;

class HomeScreen extends StatefulWidget {
  final UserModel? user;
  final VoidCallback? goto;
  const HomeScreen({this.goto, this.user});
  @override
  _ExamsState createState() => _ExamsState();
}

class _ExamsState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool adReady = false;
  int noteCount = 0;
  int unseenMessageCount = 0;
  List<QuizModel> quiz = [];
  List<Questions> questions = [];
  List<DocModel> courses = [];
  int questionsCount = 0;
  bool questionsLoading = true;
  final ScrollController _controller = ScrollController();
  List<DocModel> documents = [];
  List<DocModel> favorite = [];
  bool docLoading = true;
  bool visible = true;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  List category = [
    "STUDY MATERIALS",
    "CBT EXAMS",
    "ToDo",
    "CGPA CALCULATOR",
  ];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
      getCourses();
    getUserInfo();
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  Future<void> getUserInfo() async {
    currentUser = await getUser(context);
    if (currentUser != null) {
      checkActiveSub(currentUser);
      dailyReward(currentUser);
      setState(() => currentUser = currentUser);
      unreadNotifications();
      unreadMessages();
      setState(() {
        points = currentUser!.points;
      });
      updateUserToken(currentUser!);
     
    } 
  }

  void updateUserToken(UserModel onlineUser) {
    firebaseMessaging.getToken().then((token) {
      usersReference.doc(onlineUser.id).update({'token': token});
    });
  }

  //check if user has activated
  void checkActiveSub(UserModel? user) async {
    subscribed = await activationChecker(
        userId: user?.id, device: user?.device, subscribed: user?.subscribed);
    setState(() => subscribed = subscribed);
  }

  void unreadNotifications() async {
    noteCount = await unSeenNotificationCount(currentUser);
    setState(() => noteCount = noteCount);
  }

  void unreadMessages() async {
    unseenMessageCount = await unSeenMessageCount(currentUser);
    setState(() => unseenMessageCount = unseenMessageCount);
  }

  void getCourses() async {
    courses = await getCoursesList(context);
    setState(() {
      courses = courses;
    });
  }

  @override
  Widget build(BuildContext context) {
    systemChrome();
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: homeAppBar(context, unreadMessages, unreadNotifications,
          noteCount, unseenMessageCount),
      body: Column(
        children: [
          Material(
            child: Container(
              // height: 20,
              color: kWhite,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorPadding: const EdgeInsets.all(0),
                unselectedLabelColor: kBlack.withOpacity(0.6),
                labelColor: kBlack,
                indicatorColor: kWhite,
                tabs: category.map((tab) => tabs(tab)).toList(),
              ),
            ),
          ),
          Expanded(
              child: TabBarView(controller: _tabController, children: [
            HomeView(widget.goto!),
            CBTCoursesView(
              courses: courses,
            ),
            TimeTableTab(),
            CGPACalculator(),
          ])),
        ],
      ),
    );
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

  Tab tabs(tab) {
    return Tab(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Text(tab.toUpperCase(),
          style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700)),
    ));
  }
}
