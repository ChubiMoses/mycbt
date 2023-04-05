import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:mycbt/src/models/conv_model.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/profile/user_info.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:mycbt/src/services/notify.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:mycbt/src/widgets/validate_post_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:uuid/uuid.dart';

class ConvCommentsScreen extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postImageUrl;
  final String itemId;
  final String token;
  ConvCommentsScreen(
      {required this.postId,
      required this.token,
      required this.postOwnerId,
      required this.postImageUrl,
      required this.itemId});
  @override
  ConvCommentsScreenState createState() => ConvCommentsScreenState(
      postId: postId,
      token: token,
      postOwnerId: postOwnerId,
      postImageUrl: postImageUrl,
      itemId: itemId);
}

class ConvCommentsScreenState extends State<ConvCommentsScreen> {
  final String postId;
  final String postOwnerId;
  final String postImageUrl;
  final String itemId;
  final String token;

  TextEditingController commentTextEditingController = TextEditingController();
  ConvCommentsScreenState(
      {required this.postId,
      required this.postOwnerId,
      required this.token,
      required this.postImageUrl,
      required this.itemId});

  String nid = const Uuid().v4();

  bool emojiShowing = false;
  bool isLoading = false;

  _onEmojiSelected(Emoji emoji) {
    commentTextEditingController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: commentTextEditingController.text.length));
  }

  _onBackspacePressed() {
    commentTextEditingController
      ..text =
          commentTextEditingController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: commentTextEditingController.text.length));
  }

  displayComments() {
    return StreamBuilder<QuerySnapshot>(
      stream: convCommentsRef
          .doc(itemId)
          .collection("Items")
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return loader();
        }
        List<CommentTile> comments = [];
        dataSnapshot.data;
        dataSnapshot.data!.docs.forEach((doc) {
          comments.add(CommentTile.fromDocument(doc));
        });
        return SingleChildScrollView(
          child: Column(
            children: comments,
          ),
        );
      },
    );
  }

  void saveCommentTile() async {
    DocumentSnapshot documentSnapshot = await conversationRef.doc(itemId).get();
    if (documentSnapshot.exists) {
      ConvModel data = ConvModel.fromDocument(documentSnapshot);
      int totalComments = (data.comments + 1);
      conversationRef.doc(itemId).update({
        "comments": totalComments,
      });
    }

    convCommentsRef.doc(itemId).collection("Items").doc().set({
      "comment": commentTextEditingController.text,
      "timestamp": DateTime.now(),
      "username": currentUser?.username,
      "itemId": itemId,
      "profileImage": currentUser?.url,
      "userId": currentUser?.id
    });

    commentTextEditingController.clear();
    bool isNotPostOwner = postOwnerId != currentUser?.id;
    if (!isNotPostOwner) {
      notify(
          userId: currentUser?.id ?? "",
          nid: nid,
          body: "commented on your answer",
          ownerId: postOwnerId,
          username: currentUser!.username,
          profileImage: currentUser!.url,
          token: token,
          type: "Conversation Comment");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: header(context, strTitle: "Comments"),
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
              padding: const EdgeInsets.only(
                  bottom: 0.0, top: 10.0, left: 8.0, right: 10.0),
              child: Column(children: [
                Expanded(
                  child: displayComments(),
                ),
                _buidMessageComposer(),
              ]))),
    );
  }

  _buidMessageComposer() {
    return Container(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: kWhite,
            height: 60.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 5.0),
                IconButton(
                  icon: Icon(
                    CupertinoIcons.smiley,
                    color: kGrey500,
                  ),
                  onPressed: () {
                    setState(() {
                      emojiShowing = !emojiShowing;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                      style: TextStyle(color: kBlack, fontSize: 14),
                      maxLines: 3,
                      controller: commentTextEditingController,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        hintText: "Comment...",
                        border: InputBorder.none,
                      )),
                ),
                IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (currentUser == null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginRegisterPage()));
                      } else {
                        displayToast("Sending...");
                        if (currentUser?.url == "") {
                          displayToast("Please upload a profile picture!");
                        } else if (currentUser?.blocked == 1) {
                          displayToast("Account blocked");
                        } else {
                          saveCommentTile();
                        }
                      }
                    })
              ],
            ),
          ),
          Offstage(
            offstage: !emojiShowing,
            child: SizedBox(
              height: 250,
              child: EmojiPicker(
                  onEmojiSelected: (Category? category, Emoji emoji) {
                    _onEmojiSelected(emoji);
                    setState(() {
                      emojiShowing = !emojiShowing;
                    });
                  },
                  onBackspacePressed: _onBackspacePressed,
                  config: Config(
                      columns: 7,
                      emojiSizeMax: 28 * (Platform.isIOS ? 1.30 : 1.0),
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      initCategory: Category.RECENT,
                      bgColor: const Color(0xFFF2F2F2),
                      indicatorColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconColorSelected: Colors.blue,
                      backspaceColor: Colors.blue,
                      showRecentsTab: true,
                      recentsLimit: 28,
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: const CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL)),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentTile extends StatefulWidget {
  final String id;
  final String userId;
  final String itemId;
  final String comment;
  final Timestamp timestamp;
  final String username;
  final String profileImage;

  CommentTile({required this.userId, required this.itemId, required this.id,  required this.username, required this.profileImage, required this.comment, required this.timestamp});

  factory CommentTile.fromDocument(DocumentSnapshot documentSnapshot) {
    return CommentTile(
      id: documentSnapshot.id,
      itemId: documentSnapshot["itemId"],
      userId: documentSnapshot["userId"],
      comment: documentSnapshot["comment"],
      username: documentSnapshot["username"],
      profileImage: documentSnapshot["profileImage"],
      timestamp: documentSnapshot["timestamp"],
    );
  }

  @override
  _CommentTileState createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 5),
      child: Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget.profileImage == ""
                ? CircleAvatar(
                    child: Icon(Icons.person, color: Colors.black54),
                    backgroundColor: Colors.grey[300],
                  )
                : GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserInfo(widget.userId))),
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(widget.profileImage),
                      radius: 25.0,
                      backgroundColor: Colors.black45,
                    ),
                  ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.username,
                      style: TextStyle(
                          fontSize: 15.0,
                          color: kBlack,
                          fontWeight: FontWeight.bold)),
                  RichText(
                    text: TextSpan(
                        children: widget.comment
                            .split(' ')
                            .map((String t) => validateText(context, t))
                            .toList()),
                  ),
                  Text(tAgo.format(widget.timestamp.toDate()),
                      style: Theme.of(context).textTheme.caption),
                  Divider()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
