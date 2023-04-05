import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/models/question.dart';
import 'package:mycbt/src/models/questions.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/screen/cbt/courses_view.dart';
import 'package:mycbt/src/screen/cgpa/cgpa_tab.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/home_view.dart';
import 'package:mycbt/src/screen/search.dart';
import 'package:mycbt/src/screen/table/time_table.dart';
import 'package:mycbt/src/services/courses_service.dart';
import 'package:mycbt/src/services/message_service.dart';
import 'package:mycbt/src/services/notification_service.dart';
import 'package:mycbt/src/services/system_chrome.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/screen/sidebar/drawer_widget.dart';
import 'package:mycbt/src/widgets/home_screen_appbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class HomeScreen extends StatefulWidget {
  final UserModel? user;
  final VoidCallback? goto;
  const HomeScreen({Key? key, this.goto, this.user}) : super(key: key);
  @override
  _ExamsState createState() => _ExamsState();
}

class _ExamsState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
          final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool adReady = false;
  int noteCount = 0;
  int unseenMessageCount = 0;
  List<QuizModel> quiz = [];
  List<Questions> questions = [];
  List<DocModel> courses = [];
  int questionsCount = 0;
  bool questionsLoading = true;
  List<DocModel> documents = [];
  List<DocModel> favorite = [];
  bool docLoading = true;
  bool visible = true;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  List category = [
    "PDF",
    "CBT",
    "ToDo",
    "CGPA",
  ];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    getCourses();
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
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
      backgroundColor: kBgScaffold,
     
      body: Column(
        children: [
          const SizedBox(height: 20,),
                 Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Material(
                       elevation: 3.0,
                        borderRadius: BorderRadius.circular(5),
                       child: Row(
                        children: [
                           Expanded(
                            child: TextField(
                              onTap:() => Navigator.push(context, MaterialPageRoute(builder: (context)=>const Search())),
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.search,
                                      color: kPrimaryColor),
                                  border: InputBorder.none,
                                  hintText:"Course code", hintStyle: TextStyle(color:kGrey600)),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                              color:kPrimaryColor,
                            ),
                            height: 46,
                            width: 45,
                            child: const Icon(Icons.search,
                                color: kWhite),
                          )
                        ],
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 5,),
             Container(
              height: 40,
               color: Colors.transparent,
               child: TabBar(
                 controller: _tabController,
                 isScrollable: true,
                 indicatorPadding: const EdgeInsets.all(0),
                 unselectedLabelColor: kBlack.withOpacity(0.6),
                 labelColor: kPrimaryColor,
                 indicatorColor: kPrimaryColor,
                 tabs: category.map((tab) => tabs(tab)).toList(),
               ),
             ),
           const SizedBox(height: 5,),
          Expanded(
            child:TabBarView(
            controller: _tabController, 
            children:[
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


  Tab tabs(tab) {
    return Tab(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Text(tab.toUpperCase(),
          style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.w700)),
    ));
  }
}
