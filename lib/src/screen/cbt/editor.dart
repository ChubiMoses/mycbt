import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/models/quiz.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mycbt/src/screen/admin/edit_questions.dart';
import 'package:mycbt/src/screen/conversation/conversation_modal.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/editor_options_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:katex_flutter/katex_flutter.dart';

class Editor extends StatefulWidget {
  final String school;
  final String course;
  final String code;
  final String year;
  Editor({
    required this.school,
    required this.course,
    required this.code,
    required this.year,
  });

  @override
  _StudyModeState createState() => _StudyModeState();
}

class _StudyModeState extends State<Editor> {
  int codei = 0;
  List<Quiz> questions = [];
  bool isLoading = true;
  int count = 0;
  bool adShown = true;
  Map<String, BannerAd> ads = <String, BannerAd>{};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    QuerySnapshot querySnapshot;

    setState(() => isLoading = true);
    if (widget.year == "Year") {
      querySnapshot = await yearOneQuestionsRef
          .where("school", isEqualTo: widget.school)
          .where("course", isEqualTo: widget.course)
          .get();
    } else {
     querySnapshot = await yearOneQuestionsRef
          .where("school", isEqualTo: widget.school)
          .where("course", isEqualTo: widget.course)
          .where("year", isEqualTo: widget.year)
          .get();
    }

    setState(() {
      questions = querySnapshot.docs
          .map((documentSnapshot) => Quiz.fromDocument(documentSnapshot))
          .toList();
      count = questions.length;
      if (count <= 1) {
        Navigator.of(context).pop("exit");
      } else {
        isLoading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = "";
    if (widget.year == "Year") {
      title = widget.code;
    } else {
      title = widget.code + widget.year;
    }

    return Scaffold(
        backgroundColor: kBgScaffold,
        appBar: header(context, strTitle: title),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                  child: isLoading
                      ? loader()
                      : ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: questions.length,
                          separatorBuilder: (context, i) {
                            ads['myBanner$i'] = BannerAd(
                                size: AdSize.banner,
                                adUnitId: AdHelper.bannerAdUnitId,
                                listener: BannerAdListener(
                                    onAdLoaded: (_) {},
                                    onAdFailedToLoad: (ad, LoadAdError error) {
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
                            return const SizedBox.shrink();
                          },
                          itemBuilder: (BuildContext context, int i) {
                            return GestureDetector(
                              onDoubleTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditQuestions(
                                              question: questions[i].question,
                                              answers: questions[i].answer,
                                              view: "Exam",
                                              option1: questions[i].option1,
                                              option2: questions[i].option2,
                                              option3: questions[i].option3,
                                              id: questions[i].id,
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("${i + 1}",
                                            style: TextStyle(
                                                color: Colors.lightGreen)),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              KaTeX(
                                                laTeXCode: Text(
                                                  questions[i].question,
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              questions[i].image == null
                                                  ? SizedBox.shrink()
                                                  : questions[i].image == ""
                                                      ? SizedBox.shrink()
                                                      : Container(
                                                          width:
                                                              double.infinity,
                                                          height: 200.0,
                                                          child: Image(
                                                            image:
                                                                CachedNetworkImageProvider(
                                                                    questions[i]
                                                                        .image),
                                                            fit: BoxFit
                                                                .fitHeight,
                                                          ),
                                                        ),
                                              SizedBox(height: 5),
                                              EditorOptions(
                                                  answer: questions[i].answer,
                                                  option1: questions[i].option1,
                                                  option2: questions[i].option2,
                                                  option3: questions[i].option3,
                                                  question:
                                                      questions[i].question,
                                                  id: questions[i].id),
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
                                                              year: widget.year,
                                                              course:
                                                                  widget.course,
                                                              questionId:
                                                                  questions[i]
                                                                      .id,
                                                              question:
                                                                  questions[i]
                                                                      .question,
                                                              answer:
                                                                  questions[i]
                                                                      .answer),
                                                    )),
                                                child: Container(
                                                  width: 150,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 2.0,
                                                        color: kGrey200),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(40.0),
                                                      topRight:
                                                          Radius.circular(40.0),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Icon(
                                                          CupertinoIcons
                                                              .chat_bubble_2,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                        Text("Conversation",
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
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
                              ),
                            );
                          },
                        )),
            ),
          ],
        ),
        floatingActionButton: MaterialButton(
            child: Icon(
              Icons.refresh,
              color: Colors.lightGreen,
            ),
            color: Colors.white,
            splashColor: Colors.lightGreen,
            minWidth: 45.0,
            height: 50.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0)),
            onPressed: () => fetchData()));
  }
}
