import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/modal/pdf_render_modal.dart';
import 'package:mycbt/src/screen/web/widgets/custom_image.dart';
import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:mycbt/src/services/responsive_helper.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:mycbt/src/widgets/displayToast.dart';

// ignore: must_be_immutable
class PDFDocTile extends StatelessWidget {
  const PDFDocTile(
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

  @override
  Widget build(BuildContext context) {
    double progress = readProgress.toDouble() / pages.toDouble();
    return InkWell(
      onTap:() async{
         int result = 1;
        if (ResponsiveHelper.isMobilePhone()) {
            result = await checkConnetion();
        }
        if (currentUser == null) {
          displayToast("Please login");
          // ignore: use_build_context_synchronously
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoginRegisterPage()));
        } else {
          if (view != "OfflinePDF" && result == 0) {
            displayToast("No internet connection");
          } else {
            // ignore: use_build_context_synchronously
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
        }
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              spreadRadius: 1,
              blurRadius: 5,
            )
          ],
          color: kWhite,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              CustomImage(height: 100, image: '', width:ResponsiveHelper.isTab(context) ? 60 : 100,
              ),
              const SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: ResponsiveHelper.isMobile(context) ? 200 : 200,
                      child: Text(title.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: kBlack400,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    Text(code.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 11.0,
                            color: Color(0xff5D5D5D),
                            fontWeight: FontWeight.w600)),
                    Container(
                      width: 60,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: const Center(
                          child: Text(
                        "READ",
                        style: TextStyle(color: kWhite, fontSize: 10),
                      )),
                    ),
                    view == "OfflinePDF"
                        ? Container(
                          width:ResponsiveHelper.isDesktop(context) ? 100 : ResponsiveHelper.isTab(context) ? 100 : 210,
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
                        : const SizedBox.shrink()
                  ],
                ),
              ),
            ],
          ),
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
