import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/screen/documents/pdf_upload.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/subscription/subscription_screen.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/services/dynamic_link_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EarnPointsModal extends StatefulWidget {
  final String message;
  final String code;
  EarnPointsModal({Key? key, required this.code, required this.message})
      : super(key: key);
  @override
  _EarnPointsModalState createState() => _EarnPointsModalState();
}

class _EarnPointsModalState extends State<EarnPointsModal> {
  RewardedAd? _rewardedAd;
  bool adReady = false;
  bool rewardLoaded = false;
  late BannerAd _bannerAd;

  @override
  initState() {
    super.initState();
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
        request:  AdRequest())
      ..load();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request:  AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
        _rewardedAd = ad;
        ad.fullScreenContentCallback =
            FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
          setState(() {
            rewardLoaded = true;
          });
          _loadRewardedAd();
        });
      }, onAdFailedToLoad: (error) {
        setState(() {
          rewardLoaded = false;
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            width: double.infinity,
            decoration:  const BoxDecoration(
                color: kBgScaffold,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Padding(
                padding:  const EdgeInsets.fromLTRB(14, 5, 10, 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.suit_diamond_fill,
                                color: Theme.of(context).primaryColor,
                                size: 50,
                              ),
                              Text(points.toString(),
                                  style:
                                      TextStyle(color: kBlack, fontSize: 30)),
                            ],
                          ),
                          Divider(),
                          SizedBox(height: 5.0),
                          Text(
                            widget.message,
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                                fontSize: 15.0,
                                fontFamily: "Lato",
                                color: kBlack),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("How to  Earn?",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: kBlack,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  PDFUploadScreen())),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                            color: kWhite,
                            boxShadow: [kDefaultShadow],
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Icon(Icons.picture_as_pdf,
                                color: Color(0XFFFFC85B)),
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Upload study materials",
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                Text("Earn 10 points per each upload",
                                    style: Theme.of(context).textTheme.caption)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await _rewardedAd?.show(
                          onUserEarnedReward: (_, reward) {
                            displayToast("Earned 1 point");
                            setState(() {
                              points = points + 1;
                            });
                            _loadRewardedAd();
                          },
                        );
                        !rewardLoaded ? displayToast("Loading ads...") : null;
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                            color: kWhite,
                            boxShadow: [kDefaultShadow],
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Icon(Icons.video_collection,
                                color: Color(0XFF5DD1D3)),
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Watch free video",
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                Text("Earn 1 point per video",
                                    style: Theme.of(context).textTheme.caption)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        displayToast("Please wait...");
                        String _linkMessage = await createDynamicLink(
                            title:
                                "Hey, I'm reading ${widget.code} study material. Want to join me?",
                            id: '');
                        Share.share(_linkMessage);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                            color: kWhite,
                            boxShadow: [kDefaultShadow],
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Icon(Icons.share, color: Colors.blue),
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Tell a friend",
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                Text(
                                    "Earn 10 points per each successful referral.",
                                    style: Theme.of(context).textTheme.caption)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () => displayToast(
                          "Questions you might like to answer are available on question screen."),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                            color: kWhite,
                            boxShadow: [kDefaultShadow],
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_outline,
                                color: Color(0XFF8D7AEE)),
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Answer Questions",
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                Text(
                                    "Earn to 5 points  per answers with 5 hearts",
                                    style: Theme.of(context).textTheme.caption)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Subscription())),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                            color: kWhite,
                            boxShadow: [kDefaultShadow],
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.suit_diamond_fill,color: Color(0XFFF369B7)),
                            const SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Become a Pro User",
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                Text("Unlimited access",
                                    style: Theme.of(context).textTheme.caption)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                     const SizedBox(
                      height: 10,
                    ),
                    adReady
                        ? SizedBox(
                            height: _bannerAd.size.height.toDouble(),
                            width: _bannerAd.size.width.toDouble(),
                            child: AdWidget(ad: _bannerAd),
                          )
                        :  const SizedBox.shrink(),
                  ],
                ))));
  }

  void handleShare() async {
    Navigator.pop(context);
    final result = await checkConnetion();
    if (result == 1) {
      displayToast("Please wait...");
      String _linkMessage = await createDynamicLink(id: '');
      Share.share(_linkMessage);
    } else {
      displayToast("Error in network connection");
    }
  }

  @override
  void dispose() {
    //rewardAd.dispose();
    super.dispose();
  }
}
