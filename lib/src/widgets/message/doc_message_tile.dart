import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/screen/documents/pdf_preview.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/profile/user_info.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/message/message_tags.dart';
import 'package:mycbt/src/widgets/validate_post_text.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/displayToast.dart';

class DocConversationTile extends StatefulWidget {
  final String id;
  final String docId;
  final String sender;
  final String receiver;
  final String message;
  final String file;
  final String username;
  final String fileType;
  final int visible;
  final String profileImage;
  final Timestamp timestamp;
  final dynamic seen;

  DocConversationTile(
      {required this.id,
      required this.docId,
      required this.seen,
      required this.sender,
      required this.receiver,
      required this.file,
      required this.visible,
      required this.message,
      required this.fileType,
      required this.profileImage,
      required this.username,
      required this.timestamp});

  factory DocConversationTile.fromDocument(DocumentSnapshot doc) {
    return DocConversationTile(
      id: doc.id,
      sender: doc.get('sender') ?? "",
      docId: doc.get('docId') ?? "",
      seen: doc.get('seen') ?? "",
      visible: doc.get('visible') ?? "",
      receiver: doc.get('receiver') ?? "",
      profileImage: doc.get('profileImage') ?? "",
      username: doc.get('username') ?? "",
      message: doc.get('message') ?? "",
      file: doc.get('file') ?? "",
      fileType: doc.get('fileType') ?? "",
      timestamp: doc.get('timestamp') ?? "",
    );
  }

  @override
  _DocConversationTileState createState() => _DocConversationTileState();
}

class _DocConversationTileState extends State<DocConversationTile> {
  bool unsentwidget = false;
  bool highlight = false;
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;
  bool isMe = false;
  bool isSeen = false;
  bool isPdf = false;

  @override
  void initState() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              this._interstitialAd = ad;
              _isInterstitialAdReady = true;
            },
            onAdFailedToLoad: (LoadAdError error) {}));

    isMe = widget.sender == currentUser?.id ? true : false;
    isSeen = widget.seen == true ? true : false;
    isPdf = widget.fileType == "pdf";
    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     isMe = widget.sender == currentUser?.id ? true : false;
    return Container(
        //  padding: EdgeInsets.all(1),
        constraints: BoxConstraints(minWidth: 200, maxWidth: 300),
        decoration: BoxDecoration(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
            color: kWhite),
        margin: isMe
            ? EdgeInsets.only(top: 6.0, bottom: 6.0, left: 15.0, right: 15)
            : EdgeInsets.only(top: 6.0, bottom: 6.0, left: 15.0, right: 20),
        child: GestureDetector(
          onTap: () {
            setState(() {
              highlight = false;
            });
          },
          onLongPress: !isMe
              ? null
              : () {
                  _showAlertDialog();
                  setState(() {
                    highlight = true;
                  });
                },
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            widget.message == ""
                ? SizedBox.shrink()
                : Container(
                    decoration: BoxDecoration(
                        borderRadius: isMe
                            ? BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                              )
                            : BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                              ),
                        color:
                            isMe ? Theme.of(context).primaryColor : kGrey200),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        UserInfo(widget.sender)));
                          },
                          child: CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(widget.profileImage),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.username,
                              style: TextStyle(
                                  color: isMe ? kWhite : kBlack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 200,
                                  child:RichText(
                                    text: TextSpan(
                                      children: widget.message
                                          .split(' ')
                                          .map((String t) => messageTags(context, t, isMe))
                                          .toList(),
                                    ),
                                  ),
                                ),
                                isMe
                                    ? isSeen
                                        ? const Icon(Icons.check_circle_outline,
                                            size: 12, color: kWhite)
                                        : SizedBox.shrink()
                                    : SizedBox.shrink(),
                              ],
                            ),
                            Text(
                              tAgo.format(widget.timestamp.toDate()),
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
                                fontSize: 10.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            widget.file == ""
                ? SizedBox.shrink()
                : widget.fileType == "pdf"
                    ? Container(
                        margin: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          color: highlight
                              ? Theme.of(context).primaryColor.withOpacity(.5)
                              : isMe
                                  ? Theme.of(context).primaryColor
                                  : kGrey200,
                          borderRadius: isMe
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                )
                              : BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                        ),
                        child: ListTile(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => PdfPreview(
                                        path: widget.file,
                                        title: widget.message.split(".").first,
                                      ))),
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: kWhite,
                            child: Icon(Icons.picture_as_pdf),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: isMe ? kWhite : kBlack400,
                          ),
                          title: Text(
                            widget.message,
                            style: TextStyle(
                              fontSize: 14,
                              color: isMe ? kWhite : kBlack400,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _isInterstitialAdReady
                              ? _interstitialAd.show()
                              : null;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => PdfPreview(
                                        path: widget.file,
                                        title: widget.message.split(".").first,
                                      )));
                        },
                        child: Row(
                          mainAxisAlignment: isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                                height: 100,
                                width: 100,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image(
                                      image: CachedNetworkImageProvider(
                                          widget.file),
                                      fit: BoxFit.cover,
                                    ))),
                          ],
                        ),
                      ),
          ]),
        ));
  }

  void _showAlertDialog() {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.white,
      content:
          Text("Delete widget?", style: TextStyle(fontWeight: FontWeight.w500)),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            setState(() {
              highlight = false;
            });
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 10, 15, 15),
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
              docConversationRef
                  .doc(widget.id)
                  .collection("Items")
                  .doc(widget.id)
                  .update({'visible': 0});
              displayToast("widget deleted.");
              setState(() {
                highlight = false;
              });
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 10, 15, 15),
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
