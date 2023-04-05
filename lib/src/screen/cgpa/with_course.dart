import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';

class WithCourse extends StatefulWidget {
  @override
  _WithCourseState createState() => _WithCourseState();
}

class _WithCourseState extends State<WithCourse> {
  List grades = ["A", "B", "C", "D", "E", "F"];
  final formKey = GlobalKey<FormState>();
  int count = 2;
  String selectedGrade = "";
  TextStyle style = TextStyle(color: kBlack, fontWeight: FontWeight.w600);
  TextStyle style2 =
      TextStyle(color: kBlack, fontSize: 12, fontWeight: FontWeight.w600);
  List gen = List.generate(10, (index) {});
  int tc = 0; //Total credit load
  int tp = 0; // total point earned
  double gpa = 0;
  int cfc = 0; //CREDIT load of failed courses
  List courseGrade = [];
  List courseCourse = [];
  List courseCredit = [];
  List courseCreditVar = [];
  bool adReady = false;
  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;
  late BannerAd _bannerAd;

  @override
  void initState() {
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
    _loadRewardedAd();
    courseVariable();
    super.initState();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
        _rewardedAd = ad;
        ad.fullScreenContentCallback =
            FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
          setState(() {
            _isRewardedAdReady = false;
          });
          _loadRewardedAd();
        });
        setState(() {
          _isRewardedAdReady = true;
        });
      }, onAdFailedToLoad: (error) {
        print('Failed to load a rewarded ad: ${error.message}');
        setState(() {
          _isRewardedAdReady = false;
        });
      }),
    );
  }

  void calculate() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      tc = 0;
      tp = 0;
      gpa = 0;
      if (courseCredit.contains("COURSE")) {
        displayToast("Please enter  course codes.");
      } else if (courseCredit.contains("CREDIT")) {
        displayToast("Please enter  credit units.");
      } else if (courseGrade.contains(null)) {
        displayToast("Please select grade.");
      } else {
        courseCredit.forEach((credit) {
          tc = tc + int.parse(credit);
        });
        for (var i = 0; i < courseGrade.length; i++) {
          int point = gradeVal(courseGrade[i]);
          int credit = int.parse(courseCredit[i]);
          tp = tp + (point * credit);
        }
        gpa = tp / tc;
        String gp = gpa.toStringAsFixed(1);
        if (gpa > 5.0) {
          SnackBar snackBar =
              SnackBar(content: Text("Invalid input...your GPA is above 5.0."));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          resultDialog(context, tp: tp, tc: tc, gp: gp);
        }
      }
    }
  }

  void courseVariable() {
    for (var i = 0; i < count; i++) {
      courseGrade.add(null);
      courseCourse.add("COURSE");
      courseCredit.add("CREDIT");
    }
  }

  void incField() {
    setState(() {
      courseGrade.add(null);
      courseCourse.add('COURSE');
      courseCredit.add("CREDIT");
      count = count + 1;
    });
  }

  void reset() {
    setState(() {
      courseGrade = [];
      courseCourse = [];
      courseCredit = [];
      courseVariable();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Form(
              key: formKey,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: count,
                  itemBuilder: (context, i) {
                    return courseTile(i);
                  }),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      incField();
                    },
                    child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Icon(
                          Icons.add,
                          color: kWhite,
                        )),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => calculate(),
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width - 20,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Text("CALCULATE",
                        style: TextStyle(
                            color: kWhite, fontWeight: FontWeight.bold))),
              ),
            ),
            SizedBox(
              height: 50,
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
    );
  }

  Widget courseTile(i) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1.0, color: kGrey100)),
            height: 35,
            width: MediaQuery.of(context).size.width / 3 - 5,
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: TextFormField(
                textAlign: TextAlign.center,
                style: style2,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: courseCourse[i],
                  hintStyle: TextStyle(color: kBlack400),
                  filled: false,
                  border: InputBorder.none,
                ),
                initialValue: courseCourse[i],
                onSaved: (value) {
                  courseCourse[i] = value;
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1.0, color: kGrey200)),
            height: 35,
            width: MediaQuery.of(context).size.width / 3 - 5,
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: TextFormField(
                textAlign: TextAlign.center,
                style: style2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    isDense: true,
                    hintText: courseCredit[i],
                    hintStyle: TextStyle(
                      color: kBlack400,
                    ),
                    filled: false,
                    border: InputBorder.none),
                onSaved: (value) {
                  courseCredit[i] = value;
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1.0, color: kGrey200)),
            height: 35,
            width: MediaQuery.of(context).size.width / 3 - 5,
            child: DropdownButton(
                isExpanded: true,
                hint: const Center(
                    child: Text("GRADE",
                        style: TextStyle(
                            color: kBlack400,
                            fontSize: 12,
                            fontWeight: FontWeight.w600))),
                value: courseGrade[i],
                iconEnabledColor: kGrey600,
                underline: SizedBox.shrink(),
                items: grades.map((gr) {
                  return DropdownMenuItem(
                    child: Center(child: Text(gr, style: style2)),
                    value: gr,
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    courseGrade[i] = val;
                  });
                }),
          ),
        ],
      ),
    );
  }

  int gradeVal(String grade) {
    switch (grade) {
      case "A":
        return 5;

      case "B":
        return 4;

      case "C":
        return 3;

      case "D":
        return 2;

      case "E":
        return 1;

      case "F":
        return 0;
    }
    return 0;
  }

  dynamic resultDialog(mContext,
      {required int tp, required int tc, required String gp}) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Center(
                child: Text(
              "GPA CALCULATOR",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14, color: kBlack400),
            )),
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "TOTAL POINTS = ",
                              style: TextStyle(
                                  color: kBlack400,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              tp.toString(),
                              style: TextStyle(
                                  color: kBlack400,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "TOTAL CREDIT = ",
                              style: TextStyle(
                                  color: kBlack400,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              tc.toString(),
                              style: TextStyle(
                                  color: kBlack400,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "GRADE POINT AVERAGE = ",
                              style: TextStyle(
                                  color: kBlack400,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              gp.toString(),
                              style: TextStyle(
                                  color: kBlack400,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                         onTap: () async {
                            _rewardedAd?.show(
                              onUserEarnedReward: (_, reward) {},
                            );
                            Navigator.pop(context);
                          },
                        child: Container(
                          decoration: BoxDecoration(
                             color: Theme.of(context).primaryColor,
                          ),
                          width: MediaQuery.of(context).size.width - 30,
                          child:  const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 70.0, vertical: 15),
                              child: Center(
                                child: Text("CLOSE",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kWhite)),
                              ),
                          
                            
                           
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
