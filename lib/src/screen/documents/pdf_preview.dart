import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/services/dynamic_link_service.dart';
import 'package:mycbt/src/services/file_service.dart';
import 'package:mycbt/src/services/network%20_checker.dart';
import 'package:mycbt/src/services/system_chrome.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:mycbt/src/screen/modal/document_download_modal.dart';
import 'package:share/share.dart';

class PdfPreview extends StatefulWidget {
  final String path;
  final String title;
  const PdfPreview({
    required this.path,
    required this.title,
  });
  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfPreview> {
  bool pdfReady = false;
  int _totalPages = 0;
  int _currentPage = 0;
  PDFViewController? _pdfViewController;
  int count = 0;
  bool darkMode = false;
  bool hSwipe = false;
  bool displayAppbar = true;
  int mypage = 0;
  bool downloaded = false;
  String path = '';
  bool isLoading = true;

  
  @override
  void initState() {
    super.initState();
    networkChecker(context, "No internet connection");
    loadPdf();
  }

  void loadPdf() async {
    path = await getFileFromUrl(widget.path);
    setState(() {
      path = path;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: Colors.green.shade800,
              systemOverlayStyle: SystemUiOverlayStyle(
                systemNavigationBarColor: kWhite,
                systemNavigationBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.light,
                statusBarColor: Colors.green.shade800,
              ),
              elevation: 0.0,
              automaticallyImplyLeading: false,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              flexibleSpace: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              systemChrome();
                              Navigator.pop(context);
                            }),
                        Text(
                            _totalPages != 0
                                ? _totalPages == 1
                                    ? _currentPage.toString() +
                                        "/" +
                                        _totalPages.toString() +
                                        " page"
                                    : _currentPage.toString() +
                                        "/" +
                                        _totalPages.toString() +
                                        " pages"
                                : "",
                            style: TextStyle(color: Colors.white)),
                        Row(
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.share,
                                  color: kWhite,
                                ),
                                onPressed: () async {
                                  final result = await checkConnetion();
                                  if (result == 0) {
                                    displayToast("No internet connection");
                                  } else {
                                    displayToast("Please wait...");
                                    String _linkMessage = await createDynamicLink(
                                        title:
                                            "Hey, I'm reading ${widget.title} past question. Want to join me?",
                                        id: '');
                                    Share.share(_linkMessage);
                                  }
                                }),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                        "${widget.title.split(".").first}".toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0)),
                  ),
                  
                ],
              ),
            ),
            preferredSize: Size.fromHeight(100.0)),
        body: isLoading
            ? loader()
            : Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                    child: ClipRRect(
                      child: PDFView(
                        filePath: path,
                        autoSpacing: false,
                        enableSwipe: true,
                        swipeHorizontal: true,
                        nightMode: false,
                        onError: (e) {
                          print(e);
                        },
                        onRender: (_pages) {
                          setState(() {
                            _totalPages = _pages!;
                            pdfReady = true;
                          });
                        },
                        onViewCreated: (PDFViewController vc) {
                          _pdfViewController = vc;
                        },
                        onPageError: (page, e) {},
                      ),
                    ),
                  ),
                  !pdfReady ? loader() : Offstage()
                ],
              ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.download, color: kWhite),
            backgroundColor: Colors.orange,
            splashColor: Colors.white,
            onPressed: () async {
              if (!subscribed) {
                // if (await interstitialAd.isLoaded) {
                //   interstitialAd.show();
                //   loadAds();
                // }
              }
              showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return DocumentDownloadModal(
                      title: widget.title,
                      code: '',
                      id: '',
                      url: widget.path,
                      saveToPhone: true,
                    );
                  });
            }));
  }

  void readMore() {
    if (!subscribed) {
      if (_currentPage > 2) {
        _pdfViewController?.setPage(2);
      }
    }
  }
}
