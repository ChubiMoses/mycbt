import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/models/item.dart';
import 'package:mycbt/src/screen/subscription/subscription_screen.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:flutter/material.dart';

class SubModal extends StatefulWidget {
  const SubModal({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubModalState();
}

class _SubModalState extends State<SubModal> {
  List<Item> school = [];
  List<Item> year = [];
  bool loading = true;
  bool isEditor = false;
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          this._interstitialAd = ad;
          _isInterstitialAdReady = true;
        }, onAdFailedToLoad: (LoadAdError error) {
          print("failed to Load Interstitial Ad ${error.message}");
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            color: kBgScaffold,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 5, 10, 10),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 35.0, vertical: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Column(
                    children: const <Widget>[
                      SizedBox(height: 15.0),
                      Center(
                        child: Text("Free Mode",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: kBlack,
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                      Divider(
                        color: kWhite,
                      ),
                      SizedBox(height: 5.0),
                      Text(
                          "You are on free mode! \n Have access to more content and features by going Pro.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: kBlack,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Subscription())),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: const Center(
                        child: Text(
                          "BECOME A PRO USER",
                          style: TextStyle(color: kWhite),
                        ),
                      ),
                    )),
                const SizedBox(height: 10.0),
                GestureDetector(
                    onTap: () async {
                      _isInterstitialAdReady ? _interstitialAd.show() : null;
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 50,
                      decoration: BoxDecoration(
                          color: kBlack400,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          "MAY BE LATER".toUpperCase(),
                          style: const TextStyle(color: kWhite),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

adsModel2(
  context,
) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const SubModal();
      });
}
