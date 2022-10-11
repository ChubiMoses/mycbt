// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'dart:io';
//    //Create dynamic links to be shared 
// Future<String> createDynamicLink({String  description, title, imgUrl, type}) async {    
//      if(type == "Invite"){
//        title = "Want to know how you will perform in your 100 level CBT Examination? then, download MyCBT Exams App for free";
//        description ="MyCBT is  mobile-based CBT examination preparatory and testing platform, with a vision to aid students excel  in all Nigeria University CBT Examinations and tests.";
//        imgUrl = "https://i.ibb.co/pZyhQt6/logo.png";
//      }
//       final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: 'https://cbtexams.page.link',
//       link: Uri.parse('https://cbtexams.page.link/welcome'),
//       androidParameters: AndroidParameters(
//         packageName: 'com.ccr.mycbt',
//         minimumVersion: 0,
//       ),
//       dynamicLinkParametersOptions: DynamicLinkParametersOptions(
//         shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
//       ),
//       iosParameters: IosParameters(
//         bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
//         minimumVersion: '0',
//       ),
//       socialMetaTagParameters: SocialMetaTagParameters(
//         title: title,
//         imageUrl: Uri.parse(imgUrl),
//         description: description,
//       )
//     );
//     final ShortDynamicLink shortLink = await parameters.buildShortLink();
//      Uri shortUrl = shortLink.shortUrl;     
//      return shortUrl.toString();
//   }
