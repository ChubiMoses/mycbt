import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

List<BannerAd> adWidgets() {
  List<BannerAd> adList = [];
  for (var i = 0; i < 5; i++) {
    bool adLoaded = false;
    Future.delayed(Duration(seconds: 2),(){
      BannerAd ad = BannerAd(
        size: AdSize.banner,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(onAdLoaded: (_) {
          adLoaded = true;
        }, onAdFailedToLoad: (ad, LoadAdError error) {
          ad.dispose();
        }),
        request: AdRequest())
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
      return "ca-app-pub-4039091031657074/9809384753";
    } else if (Platform.isIOS){
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4039091031657074/5768415002';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4039091031657074/6032224255';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/7552160883';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}
