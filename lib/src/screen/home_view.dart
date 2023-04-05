import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/models/docs.dart';
import 'package:mycbt/src/models/question.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/web/components/question_slide.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/services/courses_service.dart';
import 'package:mycbt/src/services/question_service.dart';
import 'package:mycbt/src/services/user_online_checker.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/pdf%20widgets/pdf_gridview_tile.dart';

class HomeView extends StatefulWidget {
  final VoidCallback goto;
  const HomeView(this.goto, {Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool adReady = false;
  int noteCount = 0;
  List<Questions> questions = [];
  List<DocModel> courses = [];
  bool isLoading = true;
  bool questionsLoading = true;
  final ScrollController _controller = ScrollController();
  List<DocModel> documents = [];
  List<DocModel> favorite = [];
  bool docLoading = true;
  bool visible = true;
  List category = [
    "MATERIALS",
    "CBT EXAMS",
    "ToDo",
    "CGPA CALCULATOR",
  ];
  List<DocsModel> downloads = [];
  ScrollController scrollController = ScrollController();
  List<DocModel> pdf = [];
  List<DocModel> pastQuestions = [];
  List<DocModel> lectureNotes = [];
  List<DocModel> projects = [];
  List<DocModel> practical = [];
  late BannerAd _bannerAd;
  late BannerAd _bannerAd2;

  @override
  void initState() {
    super.initState();
    loadAds();
    updateLastSeen();
    getCourses();
    fetchQuestions();
    super.initState();
  }

  void fetchQuestions() async {
    setState(() => questionsLoading = true); 
    List<Questions> questionsList = await loadQuestions();
    List<Questions> temp = [];
    if (currentUser != null) {
      List hiddenUsers = currentUser!.hideUsers.split(",");
      if (hiddenUsers.isNotEmpty) {
        for (var item in questionsList) {
          if (!hiddenUsers.contains(item.userId)) {
            temp.add(item);
          }
        }
      }
    }

    for (var item in  currentUser != null ? temp : questionsList) {
      if (currentUser == null) {
        if (item.visible == 1) {
          questions.add(item);
        }
      } else {
        //hide contents required hidden by user
        List dislikeIds = item.dislikeIds.split(",");
        if (!dislikeIds.contains(currentUser!.id)) {
          if (item.visible == 1) {
            questions.add(item);
          }
        }
      }
    }
    setState(() {
      questions = questions;
      questionsLoading = false;
    });
  }

  void getCourses() async {
    setState(() {
      pastQuestions = [];
      lectureNotes = [];
      practical = [];
      projects = [];
      courses = [];
      downloads = [];
    });
    courses = await getCoursesList(context);
    setState(() {
      downloads = downloads;
      for (var element in courses) {
        if (element.category == "PAST QUESTIONS") {
          pastQuestions.add(element);
        }
        if (element.category == "LECTURE NOTE") {
          lectureNotes.add(element);
        }
        if (element.category == "PRACTICAL") {
          practical.add(element);
        }
        if (element.category == "PROJECT") {
          projects.add(element);
        }
      }
     
      isLoading = false;
    });
  }

  void loadAds() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            adReady = true;
          });
        }, onAdFailedToLoad: (ad, LoadAdError error) {
          adReady = false;
          ad.dispose();
        }),
        request: const AdRequest())
      ..load();

    _bannerAd2 = BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            adReady = true;
          });
        }, onAdFailedToLoad: (ad, LoadAdError error) {
          adReady = false;
          ad.dispose();
        }),
        request: const AdRequest())
      ..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    _bannerAd.dispose();
    _bannerAd2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgScaffold,
      body: SingleChildScrollView(
        physics:const BouncingScrollPhysics(),
        child: isLoading
            ? Padding(
              padding: const EdgeInsets.only(top: 100),
              child: loader(),
            )
            : Column(
                children: [
                  const SizedBox(height: 5),
                  Column(
                    children: [
                      PDFGridviewTile(
                          lectureNotes, "Lecture notes", getCourses),
                      const SizedBox(
                        height: 8,
                      ),
                      PDFGridviewTile(
                          pastQuestions, "Past Questions", getCourses),
                      const SizedBox(
                        height: 8,
                      ),
                      PDFGridviewTile(practical, "Practicals", getCourses),
                      const SizedBox(
                        height: 8,
                      ),
                      PDFGridviewTile(projects, "Projects", getCourses),
                    ],
                  ),

                  const QuestileTile()
                 
                ],
              ),
      ),
    
    );
  }
}
