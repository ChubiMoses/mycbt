import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/profile/user_info.dart';
import 'package:mycbt/src/screen/question/report.dart';
import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:mycbt/src/screen/question/answer_question.dart';
import 'package:mycbt/src/screen/question/answers_view.dart';
import 'package:mycbt/src/screen/question/edit_question.dart';
import 'package:mycbt/src/screen/question/photo_preview.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mycbt/src/services/notify.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:mycbt/src/widgets/validate_post_text.dart';
import 'package:timeago/timeago.dart' as tAgo;

class QuestionTile extends StatefulWidget {
  final String id;
  final String userId;
  final String title;
  final String username;
  final Timestamp timestamp;
  final String profileImage;
  final String likeIds;
  final String dislikeIds;
  final String question;
  final String image;
  final int answers;
  final String view;

  QuestionTile({
    required this.id,
    required this.username,
    required this.profileImage,
    required this.dislikeIds,
    required this.userId,
    required this.likeIds,
    required this.timestamp,
    required this.title,
    required this.question,
    required this.image,
    required this.answers,
    required this.view,
  });

  @override
  _QuestionTileState createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile> {
  List<String> likeIds = [];
  bool isLiked = false;
  bool showHeart = false;
  int likeCount = 0;
  int pro = 0;
  bool isDeleted = false;
  int? points;
  String token = "";
  String currentOnlineUserId = currentUser?.id ?? "";

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
        pro = UserModel.fromDocument(value).subscribed;
        points = UserModel.fromDocument(value).points;
        token = UserModel.fromDocument(value).token;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likeIds.contains(currentOnlineUserId) ? true : false);
    return isDeleted
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Container(
              color: kWhite,
              child: GestureDetector(
                onTap: widget.view == "Answers"
                    ? null
                    : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuestionView(widget.id))),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      tileHeader(),
                      tileText(),
                      widget.image != "" ? tilePicture() : SizedBox.shrink(),
                      tileFooter(),
                    ]),
              ),
            ));
  }

  void removeNotification() {
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

  void handleNotification() {
    if (currentOnlineUserId != widget.userId) {
      notify(
          userId: currentOnlineUserId,
          username: currentUser!.username,
          profileImage: currentUser!.url,
          nid: widget.id,
          type: "Like Question",
          body: 'Likes your question',
          ownerId: widget.userId,
          token: token);
    }
  }

  controlUserLikeQuestionTile() {
    if (currentUser == null) {
      displayToast("Please login");
    } else {
      bool _liked = likeIds.contains(currentOnlineUserId) == true;
      if (_liked) {
        setState(() {
          likeCount = likeCount - 1;
          isLiked = false;
          likeIds.remove(currentOnlineUserId);
        });
        String ids = likeIds.join(",");
        questionsRef.doc(widget.id).update({"likeIds": ids});
        removeNotification();
      } else if (!_liked) {
        setState(() {
          likeCount = likeCount + 1;
          isLiked = true;
          likeIds.add(currentOnlineUserId);
          showHeart = true;
        });
        String ids = likeIds.join(",");
        questionsRef.doc(widget.id).update({"likeIds": ids});
        handleNotification();
        Timer(const Duration(milliseconds: 800), () {
          setState(() {
            showHeart = false;
          });
        });
      }
    }
  }

  Widget tileHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, left: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserInfo(widget.userId))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: widget.profileImage == ""
                        ? CircleAvatar(
                            child: const Icon(Icons.person, color: Colors.black54),
                            backgroundColor: Colors.grey[300],
                          )
                        : CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(widget.profileImage),
                            radius: 25.0,
                            backgroundColor: Colors.grey[300],
                          ),
                  ),
                  const SizedBox(
                    width: 6.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 100,
                        child: Text(widget.username,overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.subtitle2),
                      ),
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
            ),
          ),
          IconButton(
              icon: const Icon(Icons.more_horiz, color: Colors.black54),
              onPressed: () {
                (currentUser == null)
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginRegisterPage()))
                    : moreAction(context,
                        userId: widget.userId,
                        id: widget.id,
                        question: widget.question,
                        title: widget.title,
                        username: widget.username);
              })
        ],
      ),
    );
  }

 Widget tileText() {
    String question = widget.question;
    if (widget.view == "homescreen") {
      if (question.length > 100) {
        question = question.substring(0, kIsWeb ? 40 : 70);
        question = "$question...";
      }
    }
    if (question == "") {
      return const SizedBox.shrink();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.title.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700),
                )),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            // color: bgColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: question
                      .split(' ')
                      .map((String t) => validateText(context, t))
                      .toList(),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(tAgo.format(widget.timestamp.toDate()),
                style: Theme.of(context).textTheme.caption),
          )
        ],
      );
    }
  }

  tilePicture() {
    return GestureDetector(
      onDoubleTap: () => controlUserLikeQuestionTile(),
      onTap: () => photoPreview(context, widget.image),
      child: widget.view != "Answers"
          ? Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Icon(Icons.attachment_outlined,
                      color: Colors.black, size: 16.0),
                  SizedBox(width: 3.0),
                  Text("1")
                ],
              ),
            )
          : Stack(alignment: Alignment.center, children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Container(
                    height: 300.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(widget.image),
                            fit: BoxFit.contain))),
              ),
              showHeart
                  ? Icon(Icons.thumb_up_alt_rounded,
                      size: 80.0, color: Theme.of(context).primaryColor)
                  : Text(""),
            ]),
    );
  }

  tileFooter() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 5.0),
          child: SizedBox(
            height: 30,
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    controlUserLikeQuestionTile();
                  },
                  child: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                      size: showHeart ? 30 : 25.0,
                      color: isLiked
                          ? Theme.of(context).primaryColor
                          : Colors.grey),
                ),
                Text(
                  " $likeCount",
                  style: TextStyle(color: Colors.black87),
                ),
                Icon(Icons.lightbulb_outline, size: 25.0, color: Colors.grey),
                Text(
                  widget.answers.toString(),
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
        widget.view == "homescreen" ? SizedBox.shrink() : 
        widget.view == "Answer"
            ? SizedBox(height: 5.0)
            : Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 4.0),
                child: Row(
                  children: [
                    currentUser == null
                        ? const CircleAvatar(
                            child: Icon(Icons.person, color: Colors.black54),
                            backgroundColor: kGrey300,
                            radius: 20.0,
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                CachedNetworkImageProvider(currentUser!.url),
                            radius: 20.0,
                          ),
                    const SizedBox(
                      width: 5,
                    ),
                   Container(
                      height: 35.0,
                      width:kIsWeb ? 200 : widget.view == "homescreen" ? 
                           MediaQuery.of(context).size.width - 170
                          : MediaQuery.of(context).size.width - 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(color: kGrey100)),
                      child: GestureDetector(
                        onTap: () {
                          if (currentUser == null) {
                            displayToast("Please login");
                          } else {
                            displayComments(context,
                                id: widget.id,
                                userId: widget.userId,
                                image: widget.image);
                          }
                        },
                        child: TextField(
                          decoration: InputDecoration(
                              isDense: true,
                              fillColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              hintText: 'Answer',
                              hintStyle: TextStyle(fontSize: 14),
                              filled: true,
                              enabled: false,
                              contentPadding: EdgeInsets.only(top: 6.0),
                              prefixIcon: Icon(
                                Icons.lightbulb_outline,
                                color: Colors.black45,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  moreAction(
    mContext, {
    required String userId,
    required String id,
    required String title,
    required String question,
    required String username,
  }) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("What will you like to do?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1),
            children: <Widget>[
              currentOnlineUserId == userId
                  ? SimpleDialogOption(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Icon(Icons.edit, color: Colors.grey),
                              const SizedBox(width: 10.0),
                              Text("Edit",
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ),
                          const Divider()
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditQuestion(id, question, title)));
                      })
                  : SizedBox.shrink(),
              userId == currentOnlineUserId
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
              userId == currentOnlineUserId
                  ? SizedBox.shrink()
                  : SimpleDialogOption(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(CupertinoIcons.heart_slash,
                                  color: Colors.grey),
                              SizedBox(width: 10.0),
                              Text("Not interested",
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ),
                          Divider()
                        ],
                      ),
                      onPressed: () => notIntrested(context, id),
                    ),
              userId == currentOnlineUserId
                  ? SizedBox.shrink()
                  : SimpleDialogOption(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.visibility_off, color: Colors.grey),
                              SizedBox(width: 10.0),
                              Text("Hide all from $username",
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ),
                          Divider()
                        ],
                      ),
                      onPressed: () => hideAll(context),
                    ),
              currentUser!.username == "My CBT"
                  ? SimpleDialogOption(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Icon(Icons.delete, color: Colors.grey),
                              const SizedBox(width: 10.0),
                              Text("Delete",
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ),
                          const Divider()
                        ],
                      ),
                      onPressed: () => deletePost(context, widget.id),
                    )
                  : const SizedBox.shrink(),
              userId == currentOnlineUserId
                  ? SimpleDialogOption(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Icon(Icons.delete, color: Colors.grey),
                              const SizedBox(width: 10.0),
                              Text("Delete",
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ),
                          const Divider()
                        ],
                      ),
                      onPressed: () => deletePost(context, widget.id),
                    )
                  : const SizedBox.shrink(),
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

  photoPreview(BuildContext context, photo) {
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
                  view: 'Question',
                )));
  }

  void deletePost(context, String id) {
    Navigator.pop(context);
    setState(() => isDeleted = true);
    questionsRef.doc(id).delete();
    // questionsRef.doc(id).update({
    //   "visible": 0,
    //   "lastUpdated": DateTime.now().millisecondsSinceEpoch / 1000.floor(),
    // });
    displayToast("Question deleted.");
  }

//Hide not intrested content
  dynamic notIntrested(context, String id) {
    List<String> ids = [];
    Navigator.pop(context);
    setState(() => isDeleted = true);
    ids = widget.dislikeIds.split(",");
    ids.add(currentOnlineUserId);
    String dislikeIds = ids.join(",");
    questionsRef.doc(id).update({
      "dislikeIds": dislikeIds,
      "lastUpdated": DateTime.now().millisecondsSinceEpoch / 1000.floor(),
    });
    displayToast("Question removed.");
  }

  //hide content  from a specific user when requested
  void hideAll(context) {
    List<String> hideAll = [];
    Navigator.pop(context);
    hideAll = currentUser!.hideUsers.split(",");
    hideAll.add(widget.userId);
    String hiddenUsers = hideAll.join(",");
    setState(() => isDeleted = true);
    usersReference
        .doc(currentUser!.id)
        .update({"hideUsers": hiddenUsers}).then((doc) {
      displayToast("Hiding all from ${widget.username}...");
    });
  }
}
