import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/modal/pdf_render_modal.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:mycbt/src/widgets/displayToast.dart';

// ignore: must_be_immutable
class PDFDocTile extends StatelessWidget {
  PDFDocTile(
      {Key? key,
      required this.title,
      required this.pages,
      required this.readProgress,
      required this.code,
      required this.url,
      required this.id,
      required this.conversation,
      required this.view,
      required this.firebaseId,
      required this.refresh})
      : super(key: key);
  final VoidCallback refresh;
  final String title;
  final int readProgress;
  final int pages;
  final String code;
  final String url;
  final int id;
  final int conversation;
  final String view;
  final String firebaseId;

  List<String> thumbnails = [
    '1.png',
    '2.png',
    '3.png',
    '4.png',
    '5.png',
    '6.png',
    '7.png',
    '8.png',
  ];

  @override
  Widget build(BuildContext context) {
    thumbnails.shuffle();
    String thumbnail = thumbnails[1];
    double progress = readProgress.toDouble() / pages.toDouble();
    return Material(
      elevation: 0.0,
      color: kWhite,
      borderRadius: BorderRadius.circular(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 70,
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/thumbnail/$thumbnail"),
                    fit: BoxFit.cover),
              ),
              child: Container(color: Colors.white70, child: SizedBox.shrink()),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
              child: Text(code.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.0,
                    color: kBlack400,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            SizedBox(
              height: 27,
              child: Padding(
                 padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
                child: Text(title.toUpperCase(),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 11.0,
                        color: kBlack400,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () async {
                final result = await checkConnetion();
                if (view != "OfflinePDF" && result == 0) {
                  displayToast("No internet connection");
                } else {
                  handleDocsRender(context,
                      title: title,
                      firebaseId: firebaseId,
                      conversation: conversation,
                      id: id,
                      progress: 0,
                      preview: false,
                      code: code,
                      view: view,
                      refresh: refresh,
                      filePath: url);
                }
              },
              child: Container(
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                    child: Text(
                  "READ",
                  style: TextStyle(color: kWhite, fontSize: 10),
                )),
              ),
            ),
            SizedBox(
              height: 7,
            ),
            view == "OfflinePDF"
                ? Container(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 5,
                      child: LinearProgressIndicator(
                        backgroundColor: kGrey200,
                        value: readProgress == 0 ? 0.0 : progress,
                        valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).primaryColor),
                      ),
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}

handleDocsRender(BuildContext context,
    {required int progress,
    required String firebaseId,
    required int conversation,
    required String title,
    required String code,
    required String filePath,
    required String view,
    required int id,
    required VoidCallback refresh,
    required preview}) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PDFRenderModal(
            title: title,
            firebaseId: firebaseId,
            progress: 0,
            id: id,
            view: view,
            conversation: conversation,
            code: code,
            refresh: refresh,
            preview: false,
            filePath: filePath);
      });
}
