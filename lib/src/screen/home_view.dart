import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/models/docs.dart';
import 'package:mycbt/src/models/question.dart';
import 'package:mycbt/src/screen/documents/pdf_upload.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/question/questions_tile.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/services/courses_service.dart';
import 'package:mycbt/src/services/question_service.dart';
import 'package:mycbt/src/services/user_online_checker.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/pdf%20widgets/downloaded_pdf_gridview.dart';
import 'package:mycbt/src/widgets/pdf%20widgets/pdf_gridview_tile.dart';

class HomeView extends StatefulWidget {
  final VoidCallback goto;
  const HomeView(this.goto);

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
    "STUDY MATERIALS",
    "CBT EXAMS",
    "ToDo",
    "CGPA CALCULATOR",
  ];
  List<DocsModel> downloads = [];
  TabController? _tabController;
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
    downloads = await fetchDownloads();
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
      backgroundColor: isLoading ? kWhite : kBgScaffold,
      body: SingleChildScrollView(
        physics:const BouncingScrollPhysics(),
        child: isLoading
            ? loader()
            : Column(
                children: [
                  const SizedBox(height: 5),
                  Column(
                    children: [
                      downloads.isEmpty
                          ? const SizedBox.shrink()
                          : DownloadedGridTile(
                              downloads, "Downloads", getCourses),
                      SizedBox(
                        height: 8,
                      ),
                      PDFGridviewTile(
                          lectureNotes, "Lecture notes", getCourses),
                      SizedBox(
                        height: 8,
                      ),
                      PDFGridviewTile(
                          pastQuestions, "Past Questions", getCourses),
                      SizedBox(
                        height: 8,
                      ),
                      PDFGridviewTile(practical, "Practicals", getCourses),
                      SizedBox(
                        height: 8,
                      ),
                      PDFGridviewTile(projects, "Projects", getCourses),
                    ],
                  ),
                  questions.isEmpty 
                      ? const SizedBox.shrink()
                      : Column(children: [
                          adReady
                              ? SizedBox(
                                  height: _bannerAd.size.height.toDouble(),
                                  width: _bannerAd.size.width.toDouble(),
                                  child: AdWidget(ad: _bannerAd),
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(
                            height: 2,
                          ),
                          Container(
                            constraints: const BoxConstraints(
                                minHeight: 260, maxHeight: 310),
                            child: ListView.separated(
                              itemCount:
                                  questions.length >= 6 ? 6 : questions.length,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(0),
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, i) {
                                if (i == 1) {
                                  return adReady
                                      ? SizedBox(
                                          height: 260,
                                          width: 300,
                                          child: AdWidget(ad: _bannerAd2),
                                        )
                                      : const SizedBox.shrink();
                                }

                                return const SizedBox.shrink();
                              },
                              itemBuilder: (BuildContext context, int i) {
                                return Container(
                                    width: 300,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: kWhite,
                                    ),
                                    child: QuestionTile(
                                      dislikeIds: questions[i].dislikeIds,
                                      likeIds: questions[i].likeIds,
                                      title: questions[i].title,
                                      id: questions[i].id,
                                      question: questions[i].question,
                                      image: questions[i].image,
                                      answers: questions[i].answers,
                                      view: "homescreen",
                                      timestamp: questions[i].timestamp,
                                      profileImage: questions[i].profileImage,
                                      userId: questions[i].userId,
                                      username: questions[i].username,
                                    ));
                              },
                            ),
                          ),
                          // MoreCard(
                          //   title: "RECENT QUESTIONS",
                          //   press: () => widget.goto(),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                        ])
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => PDFUploadScreen())),
          child: const Icon(Icons.cloud_upload)),
    );
  }
}
