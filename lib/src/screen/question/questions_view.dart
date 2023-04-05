// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/models/question.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/services/Authentication.dart';
import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:mycbt/src/screen/question/ask_question.dart';
import 'package:mycbt/src/screen/question/questions_tile.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/services/network%20_checker.dart';
import 'package:mycbt/src/services/question_service.dart';
import 'package:mycbt/src/services/responsive_helper.dart';
import 'package:mycbt/src/services/user_online_checker.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/empty_state_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class QuestionsView extends StatefulWidget {
  final String view;
  const QuestionsView(this.view);
  @override
  _QuestionsViewState createState() => _QuestionsViewState();
}

class _QuestionsViewState extends State<QuestionsView> {
  List<Questions> questions = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  bool isLoading = true;
  int count = 0;
  AuthImplementation auth = Auth();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Map<String, BannerAd> ads = <String, BannerAd>{};
  List<bool> adLoaded = List.generate(100, (index) => false);

  void fetchQuestions() async {
    List<Questions> temp = [];
    List<Questions> questionsList = [];

    networkChecker(context, "No internet connection");
    setState(() {
      questions = [];
      isLoading = true;
    });

    questionsList = await loadQuestions();
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

    for (var item in currentUser != null ? temp : questionsList) {
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
      count = questions.length;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    updateLastSeen();
    fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: isLoading ? kWhite : kBgScaffold,
        key: _scaffoldKey,
       
        body: Padding(
          padding:EdgeInsets.symmetric(
              horizontal:
             ResponsiveHelper.isDesktop(context) ? 300 :
             ResponsiveHelper.isTab(context) ? 200 : 0, vertical: ResponsiveHelper.isMobilePhone() ? 0 : 10
             ),
          child: SmartRefresher(
              enablePullDown: true,
              header:
                  WaterDropHeader(waterDropColor: Theme.of(context).primaryColor),
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: isLoading
                  ? loader()
                  : count == 0
                      ? EmptyStateWidget("Can't load questions at the moment.",
                          CupertinoIcons.question_circle)
                      : GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: ListView.separated(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(),
                            itemCount: count,
                            shrinkWrap: true,
                            separatorBuilder: (context, i) {
                              if(ResponsiveHelper.isMobilePhone()){
                                  ads['myBanner$i'] = BannerAd(
                                  size: AdSize.banner,
                                  adUnitId: AdHelper.bannerAdUnitId,
                                  listener: BannerAdListener(onAdLoaded: (_) {
                                    adLoaded[i] = true;
                                  }, onAdFailedToLoad: (ad, LoadAdError error) {
                                    ad.dispose();
                                  }),
                                  request: const AdRequest())
                                ..load();
                              if (i % 6 == 0) {
                                return adLoaded[i] == false ? SizedBox.shrink() : 
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 50.0,
                                      child: AdWidget(ad: ads['myBanner$i']!),
                                    ),
                                  ],
                                );
                              }

                              return const SizedBox.shrink();
                              }else{
                                 return const SizedBox.shrink();
                              }
                             
                            },
                            itemBuilder: (BuildContext context, int i) {
                              return QuestionTile(
                                timestamp: questions[i].timestamp,
                                dislikeIds: questions[i].dislikeIds,
                                likeIds: questions[i].likeIds,
                                title: questions[i].title,
                                id: questions[i].id,
                                question: questions[i].question,
                                image: questions[i].image,
                                answers: questions[i].answers,
                                view: "Question",
                                profileImage: questions[i].profileImage,
                                userId: questions[i].userId,
                                username: questions[i].username,
                              );
                            },
                          ),
                        )),
        ),
        floatingActionButton: Material(
          elevation: 2.0,
          color: kWhite,
          borderRadius: BorderRadius.circular(50.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Theme.of(context).primaryColor,
            ),
            child: InkWell(
              onTap: () async {
                (currentUser == null)
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginRegisterPage()))
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AskQuestion(fetchQuestions)));
              },
              child: Container(
                width: 60.0,
                height: 60.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: const Center(
                    child: Text("Ask",
                        style: TextStyle(
                            color: kWhite, fontWeight: FontWeight.bold))),
              ),
            ),
          ),
        ));
  }

  void _onRefresh() async {
    loadQuestions();
    await Future.delayed(Duration(seconds: 3), () {
      fetchQuestions();
    });
    _refreshController.refreshCompleted();
  }

  Widget empty() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.info_outline,
              size: 50.0, color: Theme.of(context).primaryColor),
          SizedBox(
              width: 150.0,
              child: Text("Can't retrieve questions at the moment",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1)),
          OutlinedButton(
            onPressed: () => fetchQuestions(),
            child: const Text("Retry"),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
