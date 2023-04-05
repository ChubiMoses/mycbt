import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/models/item.dart';
import 'package:mycbt/src/screen/cbt/editor.dart';
import 'package:mycbt/src/screen/cbt/exam_mode.dart';
import 'package:mycbt/src/screen/cbt/study_mode.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/services/exam_questions_service.dart';
import 'package:mycbt/src/services/questions_service.dart';
import 'package:mycbt/src/services/responsive_helper.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/list.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/widgets/custom_title.dart';
import 'package:mycbt/src/widgets/question_update_dialog.dart';
import 'package:mycbt/src/widgets/share_earn_dialog.dart';

class QuizOptionsModal extends StatefulWidget {
  final String code;
  final String course;
  final String school;
  // ignore: use_key_in_widget_constructors
  const QuizOptionsModal(this.code, this.school, this.course);
  @override
  State<StatefulWidget> createState() => _QuizOptionsModalState();
}

class _QuizOptionsModalState extends State<QuizOptionsModal> {
  List<Item> school = [];
  List<Item> year = [];
  String? _selectedYear;
  String? _duration;
  bool loading = true;
  bool isEditor = false;
  bool adShown = true;
  bool adReady = false;
  String? _questions;
  late BannerAd _bannerAd;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (ResponsiveHelper.isMobile(context)) {
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
          }
  
        });

      if (currentUser != null) {
        if (currentUser?.email == "editor@gmail.com" ||
            currentUser?.email == "mycbt@gmail.com") {
          setState(() => isEditor = true);
        }
      }
  
}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
       padding: EdgeInsets.symmetric(
              horizontal:
             ResponsiveHelper.isDesktop(context) ? 300 :
             ResponsiveHelper.isTab(context) ? 200 : 0
             ),
      child: Container(
               width: double.infinity,
         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: const BoxDecoration(
            color: kBgScaffold,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             adReady
                ? SizedBox(
                    height: _bannerAd.size.height.toDouble(),
                    width: _bannerAd.size.width.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  )
                : const SizedBox.shrink(),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 15.0),
                  Center(
                    child: Text(widget.code,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: kBlack400,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                  const SizedBox(height: 15.0),
                  customTitle(
                      context, widget.code, widget.course, kSecondaryColor),
                ],
              ),
            ),
            // widget.school == "Federal University of Technology Minna"
            //     ? const SizedBox.shrink()
            //     : Container(
            //         margin: const EdgeInsets.only(top: 15),
            //         decoration: BoxDecoration(
            //             color: kWhite,
            //             borderRadius: BorderRadius.circular(15),
            //             border: Border.all(
            //               color: kGrey200,
            //             )),
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //           child: DropdownButton(
            //               isExpanded: true,
            //               hint: const Text("Select Year"),
            //               value: _selectedYear,
            //               iconEnabledColor: kGrey600,
            //               underline: const SizedBox.shrink(),
            //               items: years.map((yr) {
            //                 return DropdownMenuItem(
            //                   value: yr,
            //                   child: Text(
            //                     yr,
            //                     style: const TextStyle(
            //                         fontSize: 14,
            //                         fontWeight: FontWeight.w500),
            //                   ),
            //                 );
            //               }).toList(),
            //               onChanged: (val) {
            //                 setState(() {
            //                   _selectedYear = val.toString();
            //                 });
            //               }),
            //         ),
            //       ),
                        const SizedBox(height: 20.0),

            Container(
              height: 50,
              decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: kGrey200,
                  )),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButton(
                    isExpanded: true,
                    hint: const Text("Questions"),
                    value: _questions,
                    iconEnabledColor: kGrey600,
                    underline: const SizedBox.shrink(),
                    items: questionsList.map((q) {
                      return DropdownMenuItem(
                        value: q,
                        child: Text(
                          q,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _questions = val.toString();
                      });
                    }),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              height: 50,
              decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: kGrey200,
                  )),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButton(
                    isExpanded: true,
                    hint: const Text("Select Duration"),
                    value: _duration,
                    iconEnabledColor: kGrey600,
                    underline: const SizedBox.shrink(),
                    items: duration.map((d) {
                      return DropdownMenuItem(
                        value: d,
                        child: Text(
                          d,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _duration = val.toString();
                      });
                    }),
              ),
            ),
              const SizedBox(height: 5.0),
            
            const SizedBox(height: 5.0),
            GestureDetector(
                onTap: () async {
                  if (_duration == null) {
                    displayToast("Please Select duration");
                  } else if(_questions == null){
                     displayToast("Please Select Questions");
                  } else {
                    ResponsiveHelper.isDesktop(context) ?
                        examMode(context, " ",)

                    :  fetchAllQuestions().then((value) async {
                      int count =
                          await questionAvailable(value, widget.course);
                      if (count > 0) {
                        // ignore: use_build_context_synchronously
                        examMode(
                          context,
                          " ",
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        downloadModal(
                            context, widget.course, widget.school);
                      }
                    });
                  }
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: const Center(
                    child: Text(
                      "TEST YOURSELF>>",
                      style: TextStyle(
                          color: kWhite, fontWeight: FontWeight.w600),
                    ),
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
           ResponsiveHelper.isDesktop(context) ? 
             const SizedBox.shrink()  : GestureDetector(
                onTap: () async {
                  shareDialog(context);
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(
                      color: kWhite,
                      border: Border.all(
                        color: kGrey200,
                      ),
                      borderRadius: BorderRadius.circular(15)),
                  child: const Center(
                    child: Text(
                      "REFER & EARN",
                      style: TextStyle(color: kBlack400),
                    ),
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
           
          ],
        ),
      ),
    );
  }

  dynamic shareDialog(BuildContext mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return ReferEarnDialog(
            promoText: "Hey! I'm answering ${widget.code.toUpperCase()} past Q&A on My CBT. Want to join me?",
          );
        });
  }

  dynamic examMode(
    mContext,
    String message,
  ) {
    return showDialog(
        context: mContext,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Column(
              children: const <Widget>[
                Text("SELECT MODE",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                SizedBox(
                  width: 100.0,
                ),
              ],
            ),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Exam "),
                      ),
                      onPressed: () async {
                        final response = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CBTScreen(
                                      duration: _duration!,
                                      school: widget.school,
                                      course: widget.course,
                                      year: "",
                                      code: widget.code,
                                      questions: _questions!,
                                      subject: '',
                                    )));
                        // ignore: unrelated_type_equality_checks
                        if (response == "exit") {
                          displayToast(
                              "$_selectedYear Q&A for ${widget.code} not available at the moment, pls check back later");
                        }
                        Navigator.pop(context);
                      }),
                  SizedBox(
                    width: 10.0,
                  ),
                  isEditor
                      ? OutlinedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(kPrimaryColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Editor",
                              style: TextStyle(color: kBlack400),
                            ),
                          ),
                          onPressed: () async {
                            final response = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Editor(
                                          school: widget.school,
                                          course: widget.course,
                                          year: "",
                                          code: widget.code,
                                        )));
                            if (response == "exit") {
                              displayToast(
                                  "$_selectedYear of ${widget.code} not found, please update questions in menu tab.");
                            }
                          })
                      : TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                kSecondaryColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Study",
                              style: TextStyle(color: kWhite),
                            ),
                          ),
                          onPressed: () async {
                            final response = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StudyMode(
                                          school: widget.school,
                                          course: widget.course,
                                          year: '',
                                          code: widget.code,
                                        )));
                            if (response == "exit") {
                              displayToast(
                                  "$_selectedYear of ${widget.code} not found, please update questions in menu tab.");
                            }
                          }),
                ],
              ),
              const SizedBox(
                width: 100.0,
              ),
            ],
          );
        });
  }
}

startQuizModal(context, String code, String school, String course) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return QuizOptionsModal(code, school, course);
      });
}
