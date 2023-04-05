import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/screen/documents/pdf_preview.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/question/photo_preview.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/message/message_tags.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/displayToast.dart';

class MessageTile extends StatefulWidget {
  final String id;
  final String chatId;
  final String sender;
  final String receiver;
  final String message;
  final String username;
  final String profilePicture;
  final String file;
  final Timestamp timestamp;
  final int seen;
  final int visible;
  final String fileType;
  final int lastAdded;
  const MessageTile(
      {required this.id,
      required this.chatId,
      required this.lastAdded,
      required this.seen,
      required this.username,
      required this.profilePicture,
      required this.sender,
      required this.visible,
      required this.receiver,
      required this.file,
      required this.fileType,
      required this.message,
      required this.timestamp});

  factory MessageTile.fromDocument(DocumentSnapshot doc) {
    return MessageTile(
      id: doc.id,
      sender: doc.get('sender') ?? "",
      chatId: doc.get('chatId') ?? "",
      seen: doc.get('seen') ?? 0,
      lastAdded: doc.get('lastAdded') ?? "",
      receiver: doc.get('receiver') ?? "",
      message: doc.get('message') ?? "",
      username: doc.get('username') ?? "",
      profilePicture: doc.get('profilePicture') ?? "",
      timestamp: doc.get('timestamp') ?? "",
      visible: doc.get('visible') ?? "",
      file: doc.get('file') ?? "",
      fileType: doc.get('fileType') ?? "",
    );
  }

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  bool highlight = false;
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;
  bool isMe = false;
  bool isSeen = false;

  @override
  void initState() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              _interstitialAd = ad;
              _isInterstitialAdReady = true;
            },
            onAdFailedToLoad: (LoadAdError error) {}));

    
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
    isSeen = widget.seen == 1 ? true : false;
    return widget.visible == 0
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
                color: kWhite),
            // width: MediaQuery.of(context).size.width * 0.75,
            margin: isMe
                ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0, right: 8)
                : EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 80),
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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    widget.fileType == 'image'
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, top: 5),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PhotoPreview(widget.file))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: isMe
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 100,
                                        width: 100,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image(
                                              image: CachedNetworkImageProvider(
                                                  widget.file),
                                              fit: BoxFit.cover,
                                            ))),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    widget.message == ""
                        ? SizedBox.shrink()
                        : widget.fileType == "pdf"
                            ? SizedBox.shrink()
                            : Container(
                                decoration: BoxDecoration(
                                    borderRadius: isMe
                                        ? BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            bottomRight:
                                                const Radius.circular(15),
                                            bottomLeft:
                                                const Radius.circular(15),
                                          )
                                        : BorderRadius.only(
                                            topRight: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                          ),
                                    color: highlight
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.5)
                                        : isMe
                                            ? Theme.of(context).primaryColor
                                            : kGrey200),
                                width: MediaQuery.of(context).size.width * 0.75,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                margin: EdgeInsets.all(2.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              140,
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
                                                ? Icon(
                                                    Icons.check_circle_outline,
                                                    size: 12,
                                                    color: kWhite)
                                                : SizedBox.shrink()
                                            : SizedBox.shrink(),
                                      ],
                                    ),
                                    isMe
                                        ? SizedBox.shrink()
                                        : Text(
                                            tAgo.format(widget.timestamp.toDate()),
                                            style: Theme.of(context).textTheme.caption
                                          ),
                                  ],
                                ),
                              ),
                    widget.file == ""
                        ? SizedBox.shrink()
                        : widget.fileType == "pdf"
                            ? Container(
                                decoration: BoxDecoration(
                                  color: highlight
                                      ? Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.5)
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
                                width: MediaQuery.of(context).size.width * 0.75,
                                margin: EdgeInsets.all(2),
                                child: ListTile(
                                  onTap: () {
                                    _isInterstitialAdReady
                                        ? _interstitialAd.show()
                                        : null;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                PdfPreview(
                                                  path: widget.file,
                                                  title: widget.message
                                                      .split(".")
                                                      .first,
                                                )));
                                  },
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
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
                            : SizedBox.shrink(),
                  ]),
            ));
  }

  void _showAlertDialog() {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.white,
      content: Text("Delete message?",
          style: TextStyle(fontWeight: FontWeight.w500)),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            setState(() {
              highlight = false;
            });
          },
          child:  Padding(
            padding: EdgeInsets.fromLTRB(8.0, 10, 15, 15),
            child: Text(
              "CANCEL",
              style: TextStyle(
                  color:Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        GestureDetector(
            onTap: () {
              messageRef.doc(widget.id).update({'visible': 0});
              displayToast("Message deleted.");
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
