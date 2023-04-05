import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/profile/user_info.dart';
import 'package:mycbt/src/screen/question/report.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:mycbt/src/screen/question/answer_question.dart';
import 'package:mycbt/src/screen/question/photo_preview.dart';
import 'package:mycbt/src/services/notify.dart';
import 'package:mycbt/src/services/reward_bill_user.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:mycbt/src/widgets/validate_post_text.dart';

class AnswerTile extends StatefulWidget {
  final String id;
  final String userId;
  final String username;
  final String proflleImage;
  final String likeIds;
  final String dislikeIds;
  final String answer;
  final String image;
  final String itemId;
  final int visible;
  final Timestamp timestamp;

  AnswerTile(
      {required this.id,
      required this.username,
      required this.proflleImage,
      required this.userId,
      required this.likeIds,
      required this.dislikeIds,
      required this.answer,
      required this.image,
      required this.itemId,
      required this.visible,
      required this.timestamp});

  factory AnswerTile.fromDocument(DocumentSnapshot doc) {
    return AnswerTile(
      id: doc.get('id'),
      userId: doc.get('userId') ?? "",
      username: doc.get('username') ?? "",
      dislikeIds: doc.get('dislikeIds') ?? "",
      visible: doc.get('visible') ?? 0,
      proflleImage: doc.get('profileImage') ?? "",
      likeIds: doc.get('likeIds') ?? "",
      timestamp: doc.get('timestamp') ?? "",
      image: doc.get('image') ?? "",
      answer: doc.get('answer') ?? "",
      itemId: doc.get('itemId') ?? "",
    );
  }

  @override
  _AnswerTileState createState() => _AnswerTileState();
}

class _AnswerTileState extends State<AnswerTile> {
  int likeCount = 0;
  bool isLiked = false;
  bool showHeart = false;
  String currentOnlineUserId = currentUser?.id ?? "";
  int pro = 0;
  List<String> likeIds = [];
  bool isDeleted = false;
  int? points;
  String token = "";

  @override
  void initState() {
    getlikeIds();
    getUserInfo();
    super.initState();
  }

  void getlikeIds() {
    setState(() {
      likeIds = widget.likeIds.split(",");
      likeCount = likeIds.length - 1;
    });
  }

  void getUserInfo() {
    usersReference.doc(widget.userId).get().then((value) {
      setState(() {
        token = UserModel.fromDocument(value).token;
        pro = UserModel.fromDocument(value).subscribed;
        points = UserModel.fromDocument(value).points;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likeIds.contains(currentOnlineUserId) ? true : false);
    return isDeleted
        ? SizedBox.shrink()
        : Padding(
            padding: EdgeInsets.only(top: 0.0),
            child: Container(
              color: kWhite,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    tileHead(),
                    tileText(),
                    widget.image != "" ? tilePicture() : SizedBox.shrink(),
                    tileFooter(),
                    Divider(),
                  ]),
            ));
  }

  removeNotification() {
    if (currentOnlineUserId != widget.userId) {
      notificationReference
          .doc(widget.userId)
          .collection("Items")
          .doc(widget.id)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }

  handleNotification() {
    if (currentOnlineUserId != widget.userId) {
      notify(
          userId: currentOnlineUserId,
          username: currentUser!.username,
          profileImage: currentUser!.url,
          nid: widget.id,
          type: "Like Answer",
          body: 'Likes your answer',
          ownerId: widget.userId,
          token: token);
    }
  }

  controlUserLikeAnswerTile() {
    if (currentUser == null) {
      displayToast("Please login");
    } else {
      bool _liked = likeIds.contains(currentOnlineUserId) ? true : false;
      if (_liked) {
        setState(() {
          likeCount = likeCount - 1;
          isLiked = false;
          likeIds.remove(currentOnlineUserId);
        });
        removeNotification();
        answersRef
            .doc(widget.id)
            .collection("Items")
            .doc(widget.itemId)
            .update({"likeIds": likeIds.join(",")});
      } else if (!_liked) {
        handleNotification();
        if (likeCount == 5 || likeCount == 10 || likeCount == 15) {
          //reward user with points and badges if their answer has 5, 10, 15, likes
          rewardBadge();
        }
        setState(() {
          likeCount = likeCount + 1;
          isLiked = true;
          likeIds.add(currentOnlineUserId);
          showHeart = true;
        });
        answersRef
            .doc(widget.id)
            .collection("Items")
            .doc(widget.itemId)
            .update({"likeIds": likeIds.join(",")});
         Timer(Duration(milliseconds: 800), () {
          setState(() {
            showHeart = false;
          });
        });
      }
    }
  }

  rewardBadge() async {
    //reward with badge
    usersReference.doc(widget.userId).get().then((value) {
      if (value.exists) {
        UserModel data = UserModel.fromDocument(value);
        int p = (data.points + 1);
        usersReference.doc(widget.userId).update({
          "badge": p,
        });
      }
    });

    //reward with points
    rewardUser(widget.userId, 3);
    notify(
        userId: currentUser!.id,
        username: currentUser!.username,
        profileImage: currentUser!.url,
        nid: widget.itemId,
        type: "Points",
        body:'You\'ve earned 3 points; your answer got ${likeCount.toString()} likes',
        ownerId: widget.userId,
        token: token);
  }

  Widget tileHead() {
    return Padding(
      padding: EdgeInsets.only(top: 6.0, left: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(2.0),
              child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserInfo(widget.userId))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: widget.proflleImage == ""
                          ? CircleAvatar(
                              child: Icon(Icons.person, color: Colors.black54),
                              backgroundColor: Colors.grey[300],
                            )
                          : CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  widget.proflleImage),
                              radius: 25.0,
                              backgroundColor: Colors.grey[300],
                            ),
                    ),
                    SizedBox(
                      width: 6.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.username,
                            style: Theme.of(context).textTheme.subtitle2),
                        Row(
                          children: [
                            Icon(CupertinoIcons.suit_diamond_fill,
                                size: 16.0,
                                color: Theme.of(context).primaryColor),
                            pro == 1
                                ? Text("Pro",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor))
                                // ignore: unnecessary_null_comparison
                                : points != null
                                    ? Text(points.toString(),
                                        style:
                                            Theme.of(context).textTheme.caption)
                                    : SizedBox.shrink(),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )),
          IconButton(
              icon: Icon(Icons.more_horiz, color: Colors.black54),
              onPressed: () {
                (currentUser == null)
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginRegisterPage()))
                    : moreAction(context);
              })
        ],
      ),
    );
  }

  tileText() {
    if (widget.answer == "") {
      return const SizedBox.shrink();
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
              child: SizedBox(
                width:MediaQuery.of(context).size.width - 100,
                child: RichText(
                  text: TextSpan(
                    children: widget.answer
                        .split(' ')
                        .map((String t) => validateText(context, t))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            child: Icon(
              Icons.copy,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
            onTap: () {
              Clipboard.setData(ClipboardData(text: widget.answer));
              displayToast("Answer copied");
            },
          )
        ],
      );
    }
  }

  tilePicture() {
    return GestureDetector(
      onDoubleTap: () => controlUserLikeAnswerTile(),
      onTap: () => photoPreview(context, widget.image),
      child: Stack(alignment: Alignment.center, children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: Container(
              height: 300.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.image),
                      fit: BoxFit.contain))),
        ),
        showHeart
            ? Icon(Icons.favorite,
                size: 80.0, color: Theme.of(context).primaryColor)
            : Text(""),
      ]),
    );
  }

  tileFooter() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, top: 10, right: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              InkWell(
                onTap: () => controlUserLikeAnswerTile(),
                child: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                    size: 25.0,
                    color:
                        isLiked ? Theme.of(context).primaryColor : Colors.grey),
              ),
              Text(
                " $likeCount",
                style: TextStyle(color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }

  moreAction(mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("What will you like to do?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1),
            children: <Widget>[
              widget.userId != currentUser!.id
                  ? SizedBox.shrink()
                  : SimpleDialogOption(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.flag, color: Colors.grey),
                              SizedBox(width: 10.0),
                              Text("Report",
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ),
                          Divider()
                        ],
                      ),
                      onPressed: () => reportPost(context),
                    ),
                     widget.userId == currentOnlineUserId
                  ? SizedBox.shrink()
                  : SimpleDialogOption(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(CupertinoIcons.heart_slash,
                                  color: Colors.grey),
                              SizedBox(width: 10.0),
                              Text("Not intrested",
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ),
                          Divider()
                        ],
                      ),
                      onPressed: () => notIntrested(context, widget.id),
                    ),
               widget.userId == currentOnlineUserId
                  ? SizedBox.shrink()
                  : SimpleDialogOption(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.visibility_off, color: Colors.grey),
                              SizedBox(width: 10.0),
                              Text("Hide all from ${widget.username}",
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ),
                          Divider()
                        ],
                      ),
                      onPressed: () => hideAll(context),
                    ),
              currentUser!.username == "Admin"
                  ? SimpleDialogOption(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.delete, color: Colors.grey),
                              SizedBox(width: 10.0),
                              Text("Delete",
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ),
                          Divider()
                        ],
                      ),
                      onPressed: () => deletePost(context, widget.id),
                    )
                  : SizedBox.shrink(),
              widget.userId == currentUser!.id
                  ? SimpleDialogOption(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.delete, color: Colors.grey),
                              SizedBox(width: 10.0),
                              Text("Delete",
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ),
                          Divider()
                        ],
                      ),
                      onPressed: () => deletePost(context, widget.id),
                    )
                  : SizedBox.shrink(),
            ],
          );
        });
  }

  displayComments(BuildContext context,
      {required String id, required String userId, required String image}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AnswerQuestion(id, userId, token);
    }));
  }

  void photoPreview(BuildContext context, photo) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhotoPreview(photo)));
  }

  void reportPost(mcontext) {
    Navigator.pop(mcontext);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReportScreen(
                  ownerId: widget.userId,
                  postId: widget.id,
                  view: 'Answer',
                )));
  }

  void deletePost(context, String id) {
    Navigator.pop(context);
    setState(() => isDeleted = true);
    answersRef.doc(id).collection("Items").doc(widget.itemId).update({
      "visible": 0,
      "lastUpdated": DateTime.now().millisecondsSinceEpoch / 1000.floor(),
    });
    displayToast("Answer deleted");
  }

  
//Hide not intrested content
  void notIntrested(context, String id) {
    Navigator.pop(context);
    setState(() => isDeleted = true);
    List ids = widget.dislikeIds.split(",");
    String dislikeIds = ids.join(currentOnlineUserId);
    answersRef.doc(id).update({
      "dislikeIds": dislikeIds,
      "lastUpdated": DateTime.now().millisecondsSinceEpoch / 1000.floor(),
    });
    displayToast("Question deleted.");
  }

  //hide content  from a specific user when requested
  void hideAll(context) {
    Navigator.pop(context);
    List hideAll = currentUser!.hideUsers.split(",");
    String hiddenUsers = hideAll.join(widget.userId);
    setState(() => isDeleted = true);
    usersReference
        .doc(widget.userId)
        .update({"hideUsers": hiddenUsers}).then((doc) {
      displayToast("Account suspended!");
    });
  }
}
