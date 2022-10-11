import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/screen/conversation/doc_conversation.dart';
import 'package:mycbt/src/screen/documents/pdf_view.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/services/file_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:flutter/material.dart';

class PDFRenderModal extends StatefulWidget {
  final int progress;
  final String firebaseId;
  final String title;
  final String code;
  final String filePath;
  final String view;
  final int id;
  final int conversation;
  final bool preview;
  final VoidCallback refresh;

   PDFRenderModal(
      {required this.progress,
      required this.firebaseId,
      required this.title,
      required this.code,
      required this.id,
      required this.conversation,
      required this.filePath,
      required this.refresh,
      required this.view,
      required this.preview});
  @override
  State<StatefulWidget> createState() => _SelectYearOneYearState();
}

class _SelectYearOneYearState extends State<PDFRenderModal> {
  bool isLoading = true;
  bool isEditor = false;
  String path = "";
  bool adShown = true;
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

    renderPDF();
  }

  void renderPDF() async {
    if (widget.view == "OfflinePDF") {
      path = await getFileFromAsset(widget.title);
    } else {
      path = await getFileFromUrl(widget.filePath);
    }
    setState(() {
      isLoading = false;
    });
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
                 EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
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
                            value: isLoading ? null : 1,
                            valueColor:  AlwaysStoppedAnimation(
                                Theme.of(context).primaryColor),
                          ),
                        ),
                        Container(
                          margin:  EdgeInsets.only(top: 6),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(isLoading ? "50%" : "100%",
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
                  height: 15,
                ),
                GestureDetector(
                    onTap: isLoading
                        ? null
                        : () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => PdfView(
                                          path: path,
                                          conversation: widget.conversation,
                                          title: widget.title,
                                          firebaseId: widget.firebaseId,
                                          progress: widget.progress,
                                          preview: false,
                                          code: widget.code,
                                          id: widget.id,
                                          view: widget.view,
                                          reads: null,
                                          refresh: widget.refresh,
                                          url: widget.filePath,
                                        )));
                          },
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width - 50,
                      decoration: BoxDecoration(
                          color: isLoading ? kGrey200 : kBlack400,
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                        child: Text(
                          "READ DOCUMENT",
                          style: TextStyle(
                              color: isLoading ? kGrey500 : kWhite,
                              fontSize: 12),
                        ),
                      ),
                    )),
                 SizedBox(
                  height: 8,
                ),
                  GestureDetector(
                    onTap:  ()  {
                     Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DocConversation(
                                        code: widget.code,
                                        docId: widget.firebaseId,
                                        title: widget.title)));
                          
                          },
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width - 50,
                      decoration: BoxDecoration(
                          color:kWhite,
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               Icon(CupertinoIcons.chat_bubble_2,
                                  color: kBlack400),
                               Text(widget.conversation == 0
                                  ? "  CONVERSATIONS" :"  CONVERSATIONS (${widget.conversation.toString()})", style: TextStyle(fontSize:14, fontWeight: FontWeight.w600),)
                            ],
                          ),
                      ),
                    )),
                 SizedBox(
                  height: 8,
                ),
                adReady
                    ? SizedBox(
                        height: _bannerAd.size.height.toDouble(),
                        width: _bannerAd.size.width.toDouble(),
                        child: AdWidget(ad: _bannerAd),
                      )
                    :  SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
