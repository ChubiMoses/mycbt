import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

List<BannerAd> adWidgets() {
  List<BannerAd> adList = [];
  for (var i = 0; i < 5; i++) {
    bool adLoaded = false;
    Future.delayed(const Duration(seconds: 2),(){
      BannerAd ad = BannerAd(
        size: AdSize.banner,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(onAdLoaded: (_) {
          adLoaded = true;
        }, onAdFailedToLoad: (ad, LoadAdError error) {
          ad.dispose();
        }),
        request: const AdRequest())
      ..load();
      if (adLoaded) {
      adList.add(ad);
    }
    });
    
  }
  return adList;
}

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7536967088300634/3106005839"; //ca-app-pub-3940256099942544/6300978111
    } else if (Platform.isIOS){
      return 'ca-app-pub-3940256099942544/2934735716'; //ca-app-pub-3940256099942544/1033173712
    } else {
      throw UnsupportedError("unsupported Platform"); //ca-app-pub-3940256099942544/5224354917
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7536967088300634/3957118735';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7536967088300634/3844372436';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/7552160883';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
