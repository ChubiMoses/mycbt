import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:mycbt/src/models/docs.dart';
import 'package:mycbt/src/screen/conversation/doc_conversation.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:mycbt/src/screen/modal/earn_points_modal.dart';
import 'package:mycbt/src/services/dynamic_link_service.dart';
import 'package:mycbt/src/services/reward_bill_user.dart';
import 'package:mycbt/src/services/user_online_checker.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/docs_db.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:mycbt/src/screen/modal/document_download_modal.dart';
import 'package:share/share.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class PdfView extends StatefulWidget {
  final String path;
  final int progress;
  final String firebaseId;
  final dynamic reads;
  final String title;
  final String code;
  final String url;
  final String view;
  final int id;
  final int conversation;
  final bool preview;
  final VoidCallback refresh;
  PdfView(
      {required this.path,
      required this.preview,
      required this.code,
      required this.progress,
      required this.conversation,
      required this.firebaseId,
      required this.reads,
      required this.title,
      required this.refresh,
      required this.url,
      required this.id,
      required this.view});
  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  DocsDbHelper docdatabaseHelper = DocsDbHelper();
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

  void updateReadProgress() async {
    try {
      await docdatabaseHelper.updateProgress(
          DocsModel(
              filePath: widget.url,
              pages: _totalPages,
              firebaseId: widget.firebaseId,
              progress: _currentPage,
              title: widget.title),
          widget.id);
    } catch (e) {
      displayToast(e.toString());
    }

    widget.refresh();
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPostFrameCallback((_) async {
    //   //disable screenshot
    //   await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    // });
    return WillPopScope(
        onWillPop: () async {
          updateLastSeen();
          updateReadProgress();
          return true;
        },
        child: Scaffold(
            backgroundColor: Colors.green.shade800,
            appBar: PreferredSize(
                child: AppBar(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    systemNavigationBarColor: kWhite,
                    systemNavigationBarIconBrightness: Brightness.dark,
                    statusBarBrightness: Brightness.light,
                    statusBarIconBrightness: Brightness.light,
                    statusBarColor: Colors.green.shade800,
                  ),
                  backgroundColor: Colors.transparent,
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
                                icon:
                                    Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () {
                                  updateReadProgress();
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
                            widget.preview
                                ? SizedBox.shrink()
                                : Row(
                                    children: [
                                      widget.id != 0
                                          ? IconButton(
                                              onPressed: () =>
                                                  showAlertDialog(),
                                              icon: Icon(
                                                Icons.delete,
                                                color: kWhite,
                                              ))
                                          : SizedBox.shrink(),
                                      IconButton(
                                          icon: Icon(
                                            Icons.share,
                                            color: kWhite,
                                          ),
                                          onPressed: () async {
                                            final result =
                                                await checkConnetion();
                                            if (result == 0) {
                                              displayToast(
                                                  "No internet connection");
                                            } else {
                                              displayToast("Please wait...");
                                              String _linkMessage =
                                                  await createDynamicLink(
                                                      title:
                                                          "Hey, I'm reading ${widget.code} study material. Want to join me?",
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
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(widget.title.toUpperCase(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0)),
                      ),
                      !subscribed
                          ? Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Center(
                                child: Text(
                                    "Please subscribe to read more pages.",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: kWhite, fontSize: 12.0)),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
                preferredSize: Size.fromHeight(100.0)),
            body: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                  child: ClipRRect(
                    child: PDFView(
                      filePath: widget.path,
                      autoSpacing: false,
                      enableSwipe: true,
                      swipeHorizontal: true,
                      nightMode: false,
                      onError: (e) {
                        print(e);
                      },
                      onRender: (int? _pages) {
                        setState(() {
                          _totalPages = _pages!;
                          pdfReady = true;
                        });
                      },
                      onViewCreated: (PDFViewController vc) {
                        _pdfViewController = vc;
                      },
                      onPageChanged: (int? page, int? total) {
                        if (_currentPage == 3) {
                          if (currentUser == null) {
                            _pdfViewController!.setPage(2);
                            displayToast("Please login");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginRegisterPage()));
                          }
                        }
                        readMore();
                        setState(() {
                          _currentPage = page! + 1;
                        });
                      },
                      onPageError: (page, e) {},
                    ),
                  ),
                ),
                !pdfReady ? loader() : Offstage()
              ],
            ),
            floatingActionButton: widget.preview
                ? SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.chat_bubble_2, color: kWhite),
                              widget.conversation == 0
                                  ? SizedBox.shrink()
                                  : Text(
                                      widget.conversation.toString(),
                                      style: TextStyle(fontSize: 12),
                                    )
                            ],
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                          splashColor: Colors.white,
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DocConversation(
                                        code: widget.code,
                                        docId: widget.firebaseId,
                                        title: widget.title)));
                          }),
                      SizedBox(
                        width: 8,
                      ),
                      widget.view == "OfflinePDF"
                          ? SizedBox.shrink()
                          : FloatingActionButton(
                              child: Icon(Icons.download, color: kWhite),
                              backgroundColor: kBlack400,
                              splashColor: Colors.white,
                              onPressed: () async {
                                if (!subscribed) {
                                  //bill user 10 points for downloading if not subscribed
                                  if (points > 10) {
                                    billUser(currentUser!.id, 10);
                                    setState(() => points = points - 10);
                                    showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return DocumentDownloadModal(
                                            id: widget.firebaseId,
                                            title: widget.title,
                                            url: widget.url,
                                            code: widget.code,
                                            saveToPhone: false,
                                          );
                                        });
                                  } else {
                                    showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return EarnPointsModal(
                                            message:
                                                "You need 10 points to download this study material.",
                                            code: widget.code,
                                          );
                                        });
                                  }
                                } else {
                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) {
                                        return DocumentDownloadModal(
                                          id: widget.firebaseId,
                                          title: widget.title,
                                          url: widget.url,
                                          saveToPhone: false,
                                          code: widget.code,
                                        );
                                      });
                                }
                              }),
                    ],
                  )));
  }

  void popView() {
    Navigator.pop(context);
  }

  void readMore() {
    if (!widget.preview) {
      if (widget.view != "OfflinePDF") {
        if (!subscribed) {
          if (_currentPage == 2) {
            //bill user 5 points for previewing document

            if (points > 5) {
              billUser(currentUser!.id, 5);
              setState(() => points -= 5);
            } else {
              _pdfViewController?.setPage(1);
              //  setState(() => _currentPage = 2);
              showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return EarnPointsModal(
                      message: "You need 5 points to read this study material.",
                      code: widget.code,
                    );
                  });
            }
          }
        }
      }
    }
  }

  void showAlertDialog() {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.white,
      content: Text("Delete document?",
          style: TextStyle(fontWeight: FontWeight.w500)),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(8.0, 10, 15, 15),
            child: Text(
              "CANCEL",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        GestureDetector(
            onTap: () {
              try {
                docdatabaseHelper
                    .deleteNote(widget.id)
                    .then((value) => displayToast("Deleting document...."));
              } catch (e) {}

              Navigator.pop(context);
              popView();
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(8.0, 10, 15, 15),
              child: Text(
                "DELETE",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ))
      ],
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
