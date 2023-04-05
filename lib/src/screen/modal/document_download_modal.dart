import 'package:ext_storage/ext_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/models/docs.dart';
import 'package:mycbt/src/services/network%20_checker.dart';
import 'package:mycbt/src/utils/docs_db.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../services/ads_service.dart';

class DocumentDownloadModal extends StatefulWidget {
  final String title;
  final String url;
  final String id;
  final String code;
  final bool saveToPhone;
   DocumentDownloadModal(
      {required this.id,
      required this.code,
      required this.saveToPhone,
      required this.title,
      required this.url});
  @override
  State<StatefulWidget> createState() => _SelectYearOneYearState();
}

class _SelectYearOneYearState extends State<DocumentDownloadModal> {
  bool isLoading = true;
  bool isEditor = false;
  bool adShown = true;
  DocsDbHelper databaseHelper = DocsDbHelper();
  bool downloadDone = false;
  var downloadProgress = 0.0;
  var path = "No Data";
  int reads = 0;
  int shares = 0;
  int downloads = 0;
  Dio dio = Dio();
  String progress = "";
  bool adReady = false;
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

    downloadFile();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        decoration:  BoxDecoration(
            color: kBgScaffold,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Padding(
          padding:  EdgeInsets.fromLTRB(14, 5, 10, 10),
          child: Padding(
            padding:
                 EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 SizedBox(
                  height: 20,
                ),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 30,
                          child: LinearProgressIndicator(
                            backgroundColor: kGrey300,
                            value: downloadProgress,
                            valueColor:  AlwaysStoppedAnimation(
                                Theme.of(context).primaryColor),
                          ),
                        ),
                        Container(
                          margin:  EdgeInsets.only(top: 6),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(downloadDone ? "100%" : progress + "%",
                                style:  TextStyle(
                                  color: kWhite,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                 SizedBox(
                  height: 5,
                ),
                GestureDetector(
                    onTap: !downloadDone ? null : () => Navigator.pop(context),
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width - 50,
                      decoration: BoxDecoration(
                          color: !downloadDone ? kGrey200 : kBlack400,
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                        child: Text(
                          "CONTINUE",
                          style: TextStyle(
                              color: !downloadDone ? kGrey500 : kWhite,
                              fontSize: 12),
                        ),
                      ),
                    )),
                 SizedBox(
                  height: 10,
                ),
                adReady
                    ? SizedBox(
                        height: _bannerAd.size.height.toDouble(),
                        width: _bannerAd.size.width.toDouble(),
                        child: AdWidget(ad: _bannerAd),
                      )
                    :  SizedBox.shrink(),
                 SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> downloadFile() async {
    networkChecker(context, "No internet connection");
    if (await Permission.storage.request().isGranted) {
      try {
        String dirloc = "";
        if (widget.saveToPhone) {
          dirloc = await ExtStorage.getExternalStoragePublicDirectory(
              ExtStorage.DIRECTORY_DOWNLOADS);

          dirloc += "/scholar_" + widget.title + ".pdf";
        } else {
          dirloc = (await getApplicationDocumentsDirectory()).path;
          FileUtils.mkdir([dirloc]);
          dirloc += "/" + widget.title + ".pdf";
        }

        await dio.download(widget.url, dirloc,
            onReceiveProgress: (receivedBytes, totalBytes) {
          setState(() {
            downloadProgress = (receivedBytes / totalBytes).toDouble();
            progress = (downloadProgress * 100).toStringAsFixed(1);
          });
        });

        setState(() {
          downloadDone = true;
          path = dirloc + "/" + widget.title + ".pdf";
        });

        if (!widget.saveToPhone) {
          DocsModel note = DocsModel(
              firebaseId: widget.id,
              title: widget.title,
              code: widget.code,
              filePath: path,
              pages: 0,
              progress: 0);
          databaseHelper.insertNote(note);
          displayToast("Saved to downloads.");
        } else {
          displayToast("Saved to phone storage");
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
