import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:katex_flutter/katex_flutter.dart';
import 'package:mycbt/src/models/questions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mycbt/src/screen/conversation/conversation_modal.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/question/photo_preview.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/services/exam_questions_service.dart';
import 'package:mycbt/src/services/questions_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/screen/modal/Ads_modal2.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudyMode extends StatefulWidget {
  final String school;
  final String course;
  final String code;
  final String year;

  StudyMode({
    required this.school,
    required this.course,
    required this.code,
    required this.year,
  });

  @override
  _StudyModeState createState() => _StudyModeState();
}

class _StudyModeState extends State<StudyMode> {
  int codeIndex = 0;
  List<QuizModel> questions = [];
  List<QuizModel> dbQuestions = [];
  bool isLoading = true;
  int count = 0;
  bool adShown = false;
  bool atTop = true;
  Map<String, BannerAd> ads = <String, BannerAd>{};
  bool adReady = false;
  late BannerAd _bannerAd;
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
       InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
        }, onAdFailedToLoad: (LoadAdError error) {
          print("failed to Load Interstitial Ad ${error.message}");
        }));

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

    fetchData();
  }

  void fetchData() async {
    dbQuestions = await fetchAllQuestions();
    questions = await fetchQuizQuestion(
        dbQuestions:dbQuestions,schoolName: widget.school, course: widget.course, studyMode: true,  numberOfQuestions: 60);
        count = questions.length;
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
     
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    });
  
   

    return WillPopScope(
      onWillPop: ()async{
           _isInterstitialAdReady ? await _interstitialAd.show() : null;
         return true;
      },
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: header(
          context,
          strTitle: widget.code,
        ),
        body: isLoading
            ? loader()
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ListView.separated(
                      shrinkWrap: true,
                      // controller: scrollController,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: subscribed ? questions.length : 5,
                      separatorBuilder: (context, i) {
                        ads['myBanner$i'] = BannerAd(
                            size: AdSize.banner,
                            adUnitId: AdHelper.bannerAdUnitId,
                            listener: BannerAdListener(onAdLoaded: (_) {
                              adReady = true;
                            }, onAdFailedToLoad: (ad, LoadAdError error) {
                              ad.dispose();
                            }),
                            request: const AdRequest())
                          ..load();
                        if (i % 6 == 0) {
                          return Column(
                            children: [
                              SizedBox(
                                child: AdWidget(ad: ads['myBanner$i']!),
                                height: 50.0,
                              ),
                            ],
                          );
                        }

                        return SizedBox.shrink();
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("${index + 1}",
                                      style: const TextStyle(color: Colors.lightGreen)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        KaTeX(
                                          laTeXCode: Text(
                                            questions[index].question!,
                                            style: const TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black),
                                          ),
                                        ),
                                        questions[index].image == null
                                            ? const SizedBox.shrink()
                                            : questions[index].image == ""
                                                ? const SizedBox.shrink()
                                                : Column(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () => photoPreview(
                                                            context,
                                                            questions[index]
                                                                .image!),
                                                        child: Container(
                                                          width: double.infinity,
                                                          height: 200.0,
                                                          color: kGrey200,
                                                          child: Image(
                                                            image:
                                                                CachedNetworkImageProvider(
                                                                    questions[
                                                                            index]
                                                                        .image!),
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "Can't see question diagram? please turn on your data.",
                                                        style: TextStyle(
                                                            color: kGrey400,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12),
                                                      ),
                                                      SizedBox(height: 5),
                                                    ],
                                                  ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        optionButtons(
                                            answer: questions[index].answer,
                                            option1: questions[index].option1,
                                            option2: questions[index].option2,
                                            option3: questions[index].option3,
                                            question: questions[index].question!,
                                            id: questions[index].id),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ModalInsideModal(
                                                  view: "",
                                                  questionId: questions[index]
                                                      .firebaseId!,
                                                  question:
                                                      questions[index].question!,
                                                  answer:
                                                      questions[index].answer!,
                                                  year: widget.year,
                                                  course: widget.course,
                                                ),
                                              )),
                                          child: Container(
                                            width: 150,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: kBgScaffold,
                                              border: Border.all(
                                                  width: 2.0, color: kGrey200),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(40.0),
                                                topRight: Radius.circular(40.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    CupertinoIcons.chat_bubble_2,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  Text("Conversation",
                                                      style: TextStyle(
                                                          color: Theme.of(context)
                                                              .primaryColor)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 5,),
                    subscribed ? const SizedBox.shrink() :
                    Container(
                    color: kWhite,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            width: 200,
                            child: Text("Have access to unlimited questions!", textAlign: TextAlign.center,
                             style: TextStyle(
                                                color: kBlack400,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.0)),
                          ),
                          const SizedBox(height: 10,),
                          GestureDetector(
                                  onTap: () =>adsModel2(context),
                                  child: Container(
                                    height: 40,
                                    width:200,
                                    // ignore: sort_child_properties_last
                                    child: const Center(
                                      child: Text("HAVE ACCESS",
                                          style: TextStyle(
                                              color: kWhite,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14.0)),
                                    ),
                                    decoration: BoxDecoration(
                                        color: kBlack400,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                
                          ),
                        ],
                      ),
                    ),
                  ),
                                    adReady
                        ? SizedBox(
                            height: _bannerAd.size.height.toDouble(),
                            width: _bannerAd.size.width.toDouble(),
                            child: AdWidget(ad: _bannerAd),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget optionButtons(
      {required String question,
      required answer,
      required option1,
      required option2,
      required option3,
      required id}) {
    List options = [answer, option1, option2, option3];
    options.shuffle();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          optionTile("A", options[0], answer),
          SizedBox(height: 5.0),
          optionTile("B", options[1], answer),
          SizedBox(height: 5.0),
          optionTile("C", options[2], answer),
          SizedBox(height: 5.0),
          optionTile("D", options[3], answer),
        ],
      ),
    );
  }

  Widget optionTile(String label, String option, String anwer) {
    return Row(
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 80,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: KaTeX(
                laTeXCode: Text(
              label + ": " + option,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            )),
          ),
        ),
        SizedBox(width: 4),
        anwer == option
            ? Icon(Icons.check_circle, size: 15.0, color: Colors.lightGreen)
            : SizedBox.shrink(),
      ],
    );
  }

  void photoPreview(BuildContext context, String photo) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhotoPreview(photo)));
  }
}
