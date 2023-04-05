import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/models/questions.dart';
import 'package:mycbt/src/models/quiz.dart';
import 'package:mycbt/src/screen/cbt/splash.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/question/photo_preview.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/services/exam_questions_service.dart';
import 'package:mycbt/src/services/questions_service.dart';
import 'package:mycbt/src/services/responsive_helper.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/screen/modal/Ads_modal2.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/calculator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';
import 'package:katex_flutter/katex_flutter.dart';

class CBTScreen extends StatefulWidget {
  final String school;
  final String course;
  final String subject;
  final String questions;
  final String duration;
  final String code;
  final String year;

  CBTScreen(
      {required this.school,
      required this.course,
      required this.code,
      required this.year,
      required this.subject,
      required this.duration,
      required this.questions});

  @override
  _CBTScreenState createState() => _CBTScreenState();
}

class _CBTScreenState extends State<CBTScreen> {
  int count = 0;
  int incCount = 0;
  int i = 0;
  int selectedCourse = 0;
  int mark = 0;
  int marks = 0;
  String _value = '';
  String answer = '';
  String title = "";
  int duration = 0;
  String showTimer = '00 : 00';
  bool isLoading = true;
  List<QuizModel> questions = [];
  List<QuizModel> dbQuestions = [];
  bool showSubAlert = false;
  List<String> userAnswers = [];
  bool displayGoto = false;
  Timer? timer;
  List<String> options = [];
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchQuestions();
      loadAds();
    });
    getDuration(widget.code);
  }

  void loadAds(){
      setState(() {
         _bannerAd = BannerAd(
          size: AdSize.banner,
          adUnitId: AdHelper.bannerAdUnitId,
          listener: BannerAdListener(onAdLoaded: (_) {
              adReady = true;
            
          }, onAdFailedToLoad: (ad, LoadAdError error) {
            adReady = false;
            ad.dispose();
          }),
          request: const AdRequest())
        ..load();
      });
     }
  

  void getDuration(String code) {
    duration = 60 * int.parse(widget.duration);
  }

  void fetchQuestions() async {
    if (!ResponsiveHelper.isDesktop(context)) {
      dbQuestions = await fetchAllQuestions();
      questions = await fetchQuizQuestion(dbQuestions:dbQuestions, schoolName: widget.school, course: widget.course, studyMode: false, numberOfQuestions:int.parse(widget.questions));
    } else {
      setState(() => displayGoto = true);
      List<Quiz> questionList =
          await getQuestions(widget.school, widget.course, int.parse(widget.questions));
      for (var data in questionList) {
        questions.add(QuizModel(
            question: data.question,
            option1: data.option1,
            option2: data.option2,
            option3: data.option3,
            answer: data.answer,
            firebaseId: data.id,
            year: data.year,
            subject: data.subject,
            school: data.school,
            code: data.code,
            image: data.image,
            category: data.category,
            course: data.course));
      }
    }

    if (questions.length < 1) {
      Navigator.of(context).pop("exit");
    }

    for (var eachValue in questions) {
      userAnswers.add("0");
    }

    setState(() {
      questions = questions;
      count = questions.length;
      options = [
        '${questions[i].option1}',
        '${questions[i].option2}',
        '${questions[i].option3}',
        '${questions[i].answer}'
      ];
      options.shuffle();
      options = options;
      isLoading = false;
      userAnswers = userAnswers;
    });
    statrTimer();
  }

  void statrTimer() async {
    const onesec = Duration(seconds: 1);
    timer = Timer.periodic(onesec, (timer) {
      setState(() {
        if (duration < 1) {
          timer.cancel();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CongratulationSplash(widget.year,
                      widget.course, marks, count, userAnswers, questions)));
        } else {
          duration = duration - 1;
        }
        int days = (duration / 24 / 60 / 60).floor();
        int hoursLeft = ((duration) - (days * 86400)).floor();
        int hours = (hoursLeft / 3600).floor();
        int minutesLeft = ((hoursLeft) - (hours * 3600)).floor();
        int minutes = (minutesLeft / 60).floor();
        int seconds = (duration % 60).floor();
        showTimer = "${formartString("$minutes")}:${formartString("$seconds")}";
      });
    });
  }

  String formartString(String number) {
    if (number.length == 1) {
      return "0$number";
    }
    return number;
  }

  void prevQuestion() {
    if (i > 0) {
      setState(() {
        i--;
        options = [
          '${questions[i].option1}',
          '${questions[i].option2}',
          '${questions[i].option3}',
          '${questions[i].answer}'
        ];
        options.shuffle();
        setState(() => options = options);
      });
    }
  }

  void nextQuestion() {
    loadAds();
    if (_value != '') {
      setState(() {
        if (i + 1 < count) {
          i++;
          _value = '';
          options = [
            '${questions[i].option1}',
            '${questions[i].option2}',
            '${questions[i].option3}',
            '${questions[i].answer}'
          ];
          options.shuffle();
          setState(() => options = options);
          if (questions[i].image != "") {
            displayToast(
                "Can't see question diagram? please turn on your data.");
          }
        } else {
          //Track un answerd questions
          if (userAnswers.contains("0")) {
            _showAlertDialog('Hello!', 'Please answer all  questions.');
          } else {
            timer?.cancel();

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CongratulationSplash(
                          widget.year,
                          widget.course,
                          marks,
                          count,
                          userAnswers,
                          questions,
                        )));
          }
        }
      });
      //if user is not subscribed and its not promo days.... then force user to subscribe
      if (i > 6) {
        //2014 questions is free to unsubscribed users
        if (widget.year != "2014") {
          if (!subscribed) {
            if (!snippet!.free) {
              setState(() {
                showSubAlert = true;
              });
            }
          }
        }
      }
    } else {
      _showAlertDialog('Hello!', 'Please select an option.');
    }
  }

  void answerSelected() {
    setState(() {
      answer = questions[i].answer!;
    });

    if (_value == answer) {
      if (userAnswers[i] == "0") {
        setState(() => marks = marks + 1);
      }
    }

    setState(() => userAnswers[i] = _value);
  }

//dispose duration
  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    incCount = i + 1;
    return WillPopScope(
      onWillPop:()async{
            _isInterstitialAdReady ? await _interstitialAd.show() : null;
         return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading:ResponsiveHelper.isMobilePhone() ? true : false ,
          centerTitle: ResponsiveHelper.isMobilePhone() ? false : true,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
          title: Text(
            widget.code,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16.0),
          ),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.calculate),
                onPressed: () => myCalculator(context)),
          ],
        ),
        body: isLoading
            ? loader()
            : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
                child: Container(
                   padding:EdgeInsets.symmetric(
                   horizontal:ResponsiveHelper.isDesktop(context) ? 300 :
                   ResponsiveHelper.isTab(context) ? 200 : 0, vertical: ResponsiveHelper.isMobilePhone() ? 0 : 20,
               ),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Question $incCount   of    Question $count'),
                              Text(showTimer,
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 4.0),
                        child: KaTeX(
                          laTeXCode: Text(questions[i].question!,
                              softWrap: true,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20.0)),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            questions[i].image == ""
                                ? const SizedBox.shrink()
                                : GestureDetector(
                                    onTap: () => photoPreview(
                                        context, questions[i].image!),
                                    child: Container(
                                      width: double.infinity,
                                      height: 200.0,
                                      decoration: BoxDecoration(
                                          color: kGrey300,
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  questions[i].image!),
                                              fit: BoxFit.contain)),
                                    ),
                                  ),
                            Container(
                              child: optionsButtons(),
                            ),
                          ],
                        ),
                      ),
                     const SizedBox(height:200,)
                    ],
                  ),
                ),
              ),
            bottomSheet: isLoading
            ? const SizedBox.shrink()
            : Container(
              height: 140,
              color: kWhite,
              padding:EdgeInsets.symmetric(
                    horizontal:ResponsiveHelper.isDesktop(context) ? 300 :
                    ResponsiveHelper.isTab(context) ? 200 : 0,
                  ),
              child: Column(
                children: [
                   displayGoto
                        ? Container(
                            alignment: Alignment.centerLeft,
                            height: 30.0,
                            child: ListView.builder(
                                itemCount: questions.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        if (!showSubAlert) {
                                          setState(() {
                                            i = index;
                                            options = [
                                              '${questions[i].option1}',
                                              '${questions[i].option2}',
                                              '${questions[i].option3}',
                                              '${questions[i].answer}'
                                            ];
                                            options.shuffle();
                                            setState(() => options = options);
                                            if(!ResponsiveHelper.isDesktop(context)){
                                                displayGoto = false;
                                            } 
                                           
                                          });
                                        } else {
                                          displayToast("Please activate");
                                        }
                                      },
                                      child: Container(
                                          height: 30.0,
                                          width: 30.0,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white),
                                              color: userAnswers[index] ==
                                                      0.toString()
                                                  ? Colors.deepOrange
                                                  : Colors.lightGreen),
                                          child: Center(
                                              child: Text("${index + 1}",
                                                  style: const TextStyle(
                                                      color: Colors.white)))));
                                }),
                          )
                        : const Text(""),
                     SizedBox(height: 10,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () => showGoto(),
                          child: Container(
                            color: Colors.grey[300],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const <Widget>[
                                Icon(Icons.select_all),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Go to",
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: i == 0 ? null : () => prevQuestion(),
                          child: Container(
                              color: kSecondaryColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: <Widget>[
                                  const Icon(
                                    Icons.arrow_back,
                                    color: kWhite,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Prev",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                      const SizedBox(width: 2.0),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showSubAlert ? adsModel2(context) : nextQuestion();
                          },
                          child: Container(
                              color: Theme.of(context).primaryColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: const <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Next",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: kWhite,
                                  )
                                ],
                              )),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 3,),
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

  RadioListTile _radioButtons(String options, value) {
    if (userAnswers[i] != "0" && userAnswers[i] == value) {
      _value = value;
    }
    return RadioListTile(
      activeColor: Colors.lightGreen,
      title: KaTeX(laTeXCode: Text("($options)   " + value)),
      groupValue: _value,
      value: value,
      onChanged: (value) {
        setState(() {
          _value = value.toString();
          answerSelected();
        });
      },
    );
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.white,
      title: Text(title),
      content: Text(message),
      actions: <Widget>[],
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  showGoto() {
    setState(() {
      displayGoto = true;
    });
  }

  Widget optionsButtons() {
    return Column(
      children: <Widget>[
        _radioButtons("A", options[0]),
        _radioButtons("B", options[1]),
        _radioButtons("C", options[2]),
        _radioButtons("D", options[3]),
      ],
    );
  }

  void photoPreview(BuildContext context, String photo) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhotoPreview(photo)));
  }
}
