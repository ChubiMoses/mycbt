import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/screen/cbt/splash.dart';
import 'package:mycbt/src/screen/conversation/conversation_modal.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mycbt/src/screen/question/photo_preview.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/services/responsive_helper.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:katex_flutter/katex_flutter.dart';

class CBTAnswers extends StatefulWidget {
  final int score;
  final int total;
  final String year;
  final String course;
  final answers;
  final quiz;
  CBTAnswers(
      this.year, this.course, this.score, this.total, this.answers, this.quiz);

  @override
  _CBTAnswersState createState() => _CBTAnswersState(score, total);
}

class _CBTAnswersState extends State<CBTAnswers> {
 
  int score;
  int total;
  _CBTAnswersState(this.score, this.total);
  Map<String, BannerAd> ads = <String, BannerAd>{};
 

  bool adShown = true;
   @override
  
  
  Widget answerButton(String answer, String userAnswer) {
    return answer == userAnswer
        ? answerWidget(answer)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 5),
              answerWidget(answer),
              SizedBox(height: 5),
              Row(
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 200.0),
                    child: Material(
                      color:kSecondaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: KaTeX(
                            laTeXCode: Text(userAnswer,
                                style: TextStyle(color: Colors.white))),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.cancel, size: 12.0, color: Colors.orange),
                ],
              ),
            ],
          );
  }

  Widget answerWidget(String answer) {
    return Row(
      children: <Widget>[
        Container(
          constraints: BoxConstraints(maxWidth: 200.0),
          child: Material(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: KaTeX(
                  laTeXCode:
                      Text(answer, style: TextStyle(color: Colors.white))),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
        SizedBox(width: 4),
        Icon(Icons.done_outline, size: 12.0, color: Colors.lightGreen),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final TextStyle titleStyle = TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );
    final TextStyle trailingStyle = TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => const HomeTab(view: "ExamMode",)),
                        (Route<dynamic> route) => false);
        return true;
      },
      child: Scaffold(
        appBar: header(context, strTitle: "Answers"),
        body: Container(
            padding: EdgeInsets.symmetric(
              horizontal:
             ResponsiveHelper.isDesktop(context) ? 300 :
             ResponsiveHelper.isTab(context) ? 200 : 0
             ),
          child: Column(
            children: <Widget>[
              ListTile(
                dense: true,
                title: Text("Score", style: titleStyle),
                trailing: Text("$score/$total", style: trailingStyle),
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: widget.quiz.length,
                  separatorBuilder: (context, i) {
                    if(ResponsiveHelper.isMobilePhone()){
                      ads['myBanner$i'] = BannerAd(
                        size: AdSize.banner,
                        adUnitId: AdHelper.bannerAdUnitId,
                        listener: BannerAdListener(
                            onAdLoaded: (_) {},
                            onAdFailedToLoad: (ad, LoadAdError error) {
                              ad.dispose();
                            }),
                        request: AdRequest())
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
                    }else{
                      
                    }
                     
                   
                    return SizedBox.shrink();

                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Text("${index + 1}"),
                              foregroundColor: Colors.lightGreen,
                              radius: 13.0,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  KaTeX(
                                      laTeXCode: Text(
                                    widget.quiz[index].question,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  )),
                                  widget.quiz[index].image == null
                                      ? Text("")
                                      : widget.quiz[index].image == ""
                                          ? Text("")
                                          : Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => photoPreview(
                                                      context,
                                                      widget.quiz[index].image),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 200.0,
                                                    color: kGrey200,
                                                    child: Image(
                                                      image:
                                                          CachedNetworkImageProvider(
                                                              widget.quiz[index]
                                                                  .image),
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
                                  answerButton(widget.quiz[index].answer,
                                      widget.answers[index]),
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
                                            questionId:
                                                widget.quiz[index].firebaseId,
                                            question:
                                                widget.quiz[index].question,
                                            answer: widget.quiz[index].answer,
                                            year: widget.year,
                                            course: widget.course,
                                          ),
                                        )),
                                    child: Container(
                                      width: 150,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2.0, color: kGrey200),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40.0),
                                          topRight: Radius.circular(40.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              CupertinoIcons.chat_bubble_2,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            Text("Conversations",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider()
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void photoPreview(BuildContext context, String photo) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhotoPreview(photo)));
  }
}
