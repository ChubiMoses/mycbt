// ignore_for_file: deprecated_member_use

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';

class WithSemester extends StatefulWidget {
  @override
  _WithSemesterState createState() => _WithSemesterState();
}

class _WithSemesterState extends State<WithSemester> {
  final formKey = GlobalKey<FormState>();
  int count = 2;
  TextStyle style = TextStyle(color: kBlack, fontWeight: FontWeight.w600);
  TextStyle style2 =
      TextStyle(color: kBlack, fontSize: 11, fontWeight: FontWeight.w600);
  int tc = 0; //Total credit
  int tp = 0; // total points
  double cgpa = 0;
  List tcList = [];
  bool adShown = true;
  List semester = [];

  List tpList = [];
  RewardedAd? _rewardedAd;
  List tpListVar = [];
  bool adReady = false;
  late BannerAd _bannerAd;
  bool _isRewardedAdReady = false;

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
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
        this._rewardedAd = ad;
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
      cgpa = 0;
      if (tpList.contains("TOTAL POINTS")) {
        displayToast("Please enter  credit units.");
      } else if (tcList.contains("TOTAL CREDIT")) {
        displayToast("Please select grade.");
      } else if (tpList.contains("") && tcList.contains("")) {
        displayToast("Please enter total points and credit units.");
      } else {
        tcList.forEach((t) {
          tc = tc + int.parse(t);
        });

        tpList.forEach((t) {
          tp = tp + int.parse(t);
        });

        cgpa = tp / tc;
        print(cgpa);
        String pa = cgpa.toStringAsFixed(1);

        if (cgpa > 5.0) {
          displayToast("Invalid input...Your CGPA is above 5.0.");
        } else {
          resultDialog(context, tp: tp, tc: tc, gp: pa);
        }
      }
    }
  }

  void courseVariable() {
    for (var i = 0; i < count; i++) {
      int inc = i + 1;
      tcList.add("TOTAL CREDIT");
      semester.add("SEMESTER " + inc.toString());
      tpList.add("TOTAL POINTS");
    }
  }

  void reset() {
    setState(() {
      tcList = [];
      semester = [];
      tpList = [];

      for (var i = 0; i < count; i++) {
        int inc = i + 1;
        tcList.add("TOTAL CREDIT");
        semester.add("SEMESTER " + inc.toString());
        tpList.add("TOTAL POINTS");
      }
    });
  }

  void semesterInc() {
    setState(() {
      count = count + 1;
      tcList.add("TOTAL CREDIT");
      semester.add("SEMESTER " + count.toString());
      tpList.add("TOTAL POINTS");
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
                      semesterInc();
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
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Container(
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "NOTE:",
            //           style: TextStyle(
            //               color: kBlack400,
            //               fontSize: 15,
            //               fontWeight: FontWeight.bold),
            //         ),
            //         SizedBox(
            //           height: 2,
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: [
            //             Text(
            //               "TP: ",
            //               style: TextStyle(
            //                   color: kBlack400,
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.w600),
            //             ),
            //             Text(
            //               "Total points earned per semester.",
            //               style: TextStyle(
            //                 color: kBlack400,
            //               ),
            //             )
            //           ],
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: [
            //             Text(
            //               "TC: ",
            //               style: TextStyle(
            //                   color: kBlack400,
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.w600),
            //             ),
            //             Text(
            //               "Total credit load per semester.",
            //               style: TextStyle(
            //                 color: kBlack400,
            //               ),
            //             )
            //           ],
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 50,
            ),
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
                borderRadius: BorderRadius.circular(5),
                color: kWhite,
                border: Border.all(width: 1.0, color: kGrey200)),
            height: 35,
            width: MediaQuery.of(context).size.width / 3 - 5,
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                style: style2,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: semester[i],
                  hintStyle: TextStyle(
                    color: kBlack400,
                  ),
                  filled: false,
                  border: InputBorder.none,
                ),
                initialValue: semester[i],
                onSaved: (value) {
                  semester[i] = value.toString();
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: kWhite,
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
                    hintText: tpList[i],
                    hintStyle: TextStyle(color: kBlack400),
                    filled: false,
                    border: InputBorder.none),
                onSaved: (value) {
                  tpList[i] = value;
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: kWhite,
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
                    hintText: tcList[i],
                    hintStyle: TextStyle(
                      color: kBlack400,
                    ),
                    filled: false,
                    border: InputBorder.none),
                onSaved: (value) {
                  tcList[i] = value;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  dynamic resultDialog(mContext,
      {required int tp, required int tc, required String gp}) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Center(
                child: Text(
              "CGPA CALCULATOR",
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
                                  fontSize: 12,
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
                              "TOTAL CREDIT  = ",
                              style: TextStyle(
                                  color: kBlack400,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              tc.toString(),
                              style: TextStyle(
                                  color: kBlack400,
                                  fontSize: 12,
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
                              "CGPA = ",
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 30,
                        child: InkWell(
                           onTap: () async {
                              _rewardedAd?.show(
                                onUserEarnedReward: (_, reward) {},
                              );
                              Navigator.pop(context);
                            },
                          child: Container(
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 70.0, vertical: 15),
                              child: Center(
                                child: Text("CLOSE",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kWhite)),
                              ),
                            ),
                            color: Theme.of(context).primaryColor,
                            
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
