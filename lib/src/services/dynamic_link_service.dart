import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:mycbt/src/models/referral.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/services/referral_service.dart';

Future<String> createDynamicLink({required String id, title}) async {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  String? referralCode = "";
  Referral? referrer = await getReferralInfo();
  if (referrer != null) {
    referralCode = referrer.code;
  }
  String description =
      "My CBT | Guarantee your one sitting in CBT Exams. #MyCBT #CBT  .";
  String imgUrl = "https://i.ibb.co/jZNFkGP/logo.png";
  final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://cbtexams.page.link',
      link: Uri.parse(
          'https://cbtexams.page.link/welcome?referalCode=$referralCode&userId=${currentUser!.id}'),
      androidParameters: const AndroidParameters(
        packageName: 'com.cc.MyCBT',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: title,
        imageUrl: Uri.parse(imgUrl),
        description: description,
      ));
  Uri shortUrl;
  final ShortDynamicLink shortLink =
      await dynamicLinks.buildShortLink(parameters);
  shortUrl = shortLink.shortUrl;
  return shortUrl.toString();
}
