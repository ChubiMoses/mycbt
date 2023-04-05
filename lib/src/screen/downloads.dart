import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/models/docs.dart';
import 'package:mycbt/src/models/question.dart';
import 'package:mycbt/src/screen/documents/pdf_upload.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/services/courses_service.dart';
import 'package:mycbt/src/services/responsive_helper.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/empty_state_widget.dart';
import 'package:mycbt/src/widgets/pdf%20widgets/pdf_docs_tile.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);


  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  bool adReady = false;
  int noteCount = 0;
  List<Questions> questions = [];
  List<DocModel> courses = [];
  bool isLoading = true;
  bool questionsLoading = true;
  final ScrollController _controller = ScrollController();
  List<DocModel> documents = [];
  List<DocModel> favorite = [];
  bool docLoading = true;
  bool visible = true;
  List category = [
    "STUDY MATERIALS",
    "CBT EXAMS",
    "ToDo",
    "CGPA CALCULATOR",
  ];
  List<DocsModel> downloads = [];

  late BannerAd _bannerAd;
  late BannerAd _bannerAd2;

  @override
  void initState() {
    super.initState();
    loadAds();
    getCourses();
    super.initState();
  }

  void getCourses() async {
    downloads = await fetchDownloads();
    setState(() {
//downloads = downloads;
      isLoading = false;
    });
  }

  void loadAds() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
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

    _bannerAd2 = BannerAd(
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

  @override
  void dispose() {
    _controller.dispose();
    _bannerAd.dispose();
    _bannerAd2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLoading ? kWhite : kBgScaffold,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: isLoading
            ? loader()
            : downloads.isEmpty
            ? Padding(
               padding: const EdgeInsets.only(top:150),
              child: EmptyStateWidget("Your downloads will appear here", CupertinoIcons.book_circle_fill)
            )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GridView.count(
                  padding: const EdgeInsets.only(top:10),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / (ResponsiveHelper.isDesktop(context) ? 1.8 : ResponsiveHelper.isTab(context) ? 3 : 7)),
                  children:List.generate(downloads.length > 4 ? 4 : downloads.length, (i) {
                    return PDFDocTile(
                        code: downloads[i].code!,
                        readProgress: downloads[i].progress!,
                        pages: downloads[i].pages!,
                        title: downloads[i].title!,
                        url: downloads[i].filePath!,
                        conversation:0,
                        firebaseId: downloads[i].firebaseId!,
                        refresh: getCourses,
                        id: downloads[i].id!,
                        view: 'OfflinePDF');
                  }),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => PDFUploadScreen())),
          child: const Icon(Icons.cloud_upload)),
    );
  }
}
