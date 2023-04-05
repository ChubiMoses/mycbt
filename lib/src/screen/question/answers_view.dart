import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/models/answers.dart';
import 'package:mycbt/src/models/question.dart';
import 'package:mycbt/src/screen/question/answer_tile.dart';
import 'package:mycbt/src/screen/question/questions_tile.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/services/responsive_helper.dart';
import 'package:mycbt/src/services/user_online_checker.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';

class QuestionView extends StatefulWidget {
  final String questionId;
  QuestionView(this.questionId);
  @override
  _QuestionViewState createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  Questions? question;
  List<Answers> answer = [];
  int answers = 0;
  bool isLoading = true;
  bool adReady = false;
  late BannerAd _bannerAd;

  @override
  initState() {
    super.initState();
    updateLastSeen();
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _bannerAd = BannerAd(
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

    });
   
    getQuestion();
    super.initState();
  }

  void getQuestion() {
    questionsRef.doc(widget.questionId).get().then((value) {
      question = Questions.fromDocument(value);
      setState(() {
        question = question;
        isLoading = false;
      });
    });
  }

  Widget getAnswers() {
    return FutureBuilder<QuerySnapshot>(
      future: answersRef.doc(widget.questionId).collection("Items").get(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return loader();
        }
        List<AnswerTile> answers = [];
        for (var doc in dataSnapshot.data!.docs) {
          answers.add(AnswerTile.fromDocument(doc));
        }
        return Column(
          children: answers,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, strTitle: "Answers", disapearBackButton: false),
        body: isLoading
            ? loader()
            : SingleChildScrollView(
              padding:EdgeInsets.symmetric(
              horizontal:ResponsiveHelper.isDesktop(context) ? 300 :
              ResponsiveHelper.isTab(context) ? 200 : 0, vertical: ResponsiveHelper.isMobilePhone() ? 0 : 20,
             ),
              physics: BouncingScrollPhysics(),
                child: Column(children: [
                  QuestionTile(
                    dislikeIds:question!.dislikeIds,
                    userId: question!.userId,
                    likeIds: question!.likeIds,
                    id: question!.id,
                    timestamp: question!.timestamp,
                    question: question!.question,
                    image: question!.image,
                    answers: question!.answers,
                    title: question!.title,
                    view: "Answers",
                    profileImage: question!.profileImage,
                    username: question!.username,
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: Text("Answers",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                  ),
                  adReady
                      ? SizedBox(
                          height: _bannerAd.size.height.toDouble(),
                          width: _bannerAd.size.width.toDouble(),
                          child: AdWidget(ad: _bannerAd),
                        )
                      : const SizedBox.shrink(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                    child: getAnswers(),
                  ),
                ]),
              ));
  }
}
