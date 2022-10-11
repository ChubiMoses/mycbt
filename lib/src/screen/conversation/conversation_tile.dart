import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mycbt/src/screen/conversation/comments.dart';
import 'package:mycbt/src/screen/profile/user_info.dart';
import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/question/photo_preview.dart';
import 'package:mycbt/src/services/notify.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/more_action_dialog.dart';
import 'package:mycbt/src/widgets/validate_post_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:mycbt/src/models/user.dart';
import 'package:uuid/uuid.dart';

class ConversationTile extends StatefulWidget {
  final String postId;
  final String itemId;
  final String ownerId;
  final Timestamp timestamp;
  final dynamic likes;
  final String username;
  final String description;
  final String url;
  final int comments;
  final String profileImage;
  final int visible;
  final int lastAdded;

  ConversationTile(
      {required this.postId,
      required this.itemId,
      required this.ownerId,
      required this.timestamp,
      required this.likes,
      required this.username,
      required this.description,
      required this.url,
      required this.comments,
      required this.visible,
      required this.lastAdded,
      required this.profileImage});

  factory ConversationTile.fromDocument(DocumentSnapshot doc) {
    return ConversationTile(
      itemId: doc.id,
      postId: doc.data().toString().contains('postId') ? doc.get('postId') : "",
      ownerId:
          doc.data().toString().contains('ownerId') ? doc.get('ownerId') : "",
      likes: doc.data().toString().contains('likes') ? doc.get('likes') : "",
      username:
          doc.data().toString().contains('username') ? doc.get('username') : "",
      timestamp: doc.data().toString().contains('timestamp')
          ? doc.get('timestamp')
          : "",
      description: doc.data().toString().contains('description')
          ? doc.get('description')
          : "",
      url: doc.data().toString().contains('url') ? doc.get('url') : "",
      comments:
          doc.data().toString().contains('comments') ? doc.get('comments') : "",
      profileImage: doc.data().toString().contains('profileImage')
          ? doc.get('profileImage')
          : "",
      lastAdded: doc.data().toString().contains('lastAdded')
          ? doc.get('lastAdded')
          : 0,
      visible:
          doc.data().toString().contains('visible') ? doc.get('visible') : 0,
    );
  }
  @override
  // ignore: no_logic_in_create_state
  _ConversationTileState createState() => _ConversationTileState();
}

class _ConversationTileState extends State<ConversationTile> {
  String postId = "";
  String ownerId = "";
  Timestamp? timestamp;
  int comments = 0;
  String description = "";
  String url = "";
  int likeCount = 0;
  Map likes = {};
  bool isLiked = false;
  bool showHeart = false;
  String? currentOnlineUserId = currentUser?.id;
  String nid = const Uuid().v4();
  String username = "";
  String userImg = "";
  String token = "";
  bool isDeleted = false;
  @override
  void initState() {
    super.initState();
    postId = widget.postId;
    ownerId = widget.ownerId;
    timestamp = widget.timestamp;
    likes = widget.likes;
    comments = widget.comments;
    description = widget.description;
    url = widget.url;
    userInfo();
    likeCount = getTotalNumberOfLikes(widget.likes);
  }

  int getTotalNumberOfLikes(likes) {
    if (likes == null) {
      return 0;
    }

    int counter = 0;
    likes.values.forEach((eachValue) {
      if (eachValue == true) {
        counter = counter + 1;
      }
    });
    return counter;
  }

  void userInfo() async {
    await usersReference.doc(ownerId).get().then((value) {
      setState(() {
        username = UserModel.fromDocument(value).username;
        userImg = UserModel.fromDocument(value).url;
        token = UserModel.fromDocument(value).token;
      });
    });
  }

//Hide item on delete
  void showDeleted() {
    setState(() {
      isDeleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentOnlineUserId] == true);
    return isDeleted
        ? SizedBox.shrink()
        : Container(
            margin: EdgeInsets.only(top: 5.0),
            padding: EdgeInsets.all(5.0),
            color: kWhite,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  createConversationTileHead(),
                  createConversationTileText(),
                  url != ""
                      ? createConversationTilePicture()
                      : SizedBox.shrink(),
                  createConversationTileFooter(),
                ]),
          );
  }

  void removeLike() {
    bool isNotConversationTileOwner = currentOnlineUserId != ownerId;
    if (isNotConversationTileOwner) {
      notificationReference
          .doc(ownerId)
          .collection("Items")
          .doc(postId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }

  addLike() {
    // if (currentOnlineUserId == ownerId) {
    notify(
        userId: currentUser?.id ?? "",
        nid: nid,
        body: "likes your answer",
        ownerId: ownerId,
        profileImage:currentUser!.url,
        username:currentUser!.username,
        token: token,
        type: "Like conversation answer");
    //  }
  }

  controlUserLikeConversationTile() {
    bool _liked = likes[currentOnlineUserId] == true;
    if (_liked) {
      conversationRef
          .doc(widget.itemId)
          .update({"likes.$currentOnlineUserId": false});
      removeLike();
      setState(() {
        likeCount = likeCount - 1;
        isLiked = false;
        likes[currentOnlineUserId] = false;
      });
    } else if (!_liked) {
      conversationRef
          .doc(widget.itemId)
          .update({"likes.$currentOnlineUserId": true});
      addLike();
      setState(() {
        likeCount = likeCount + 1;
        isLiked = true;
        likes[currentOnlineUserId] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 800), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  Widget createConversationTileHead() {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, left: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: userImg == ""
                      ? CircleAvatar(
                          radius: 25.0,
                          child:
                              const Icon(Icons.person, color: Colors.black54),
                          backgroundColor: Colors.grey[300],
                        )
                      : GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UserInfo(widget.ownerId))),
                          child: CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(userImg),
                            radius: 25.0,
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                ),
                SizedBox(
                  width: 6.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(username == "" ? "User" : username,
                        style: const TextStyle(
                            fontSize: 14.0,
                            color: kBlack,
                            fontWeight: FontWeight.bold)),
                    Text(tAgo.format(timestamp!.toDate()),
                        style: Theme.of(context).textTheme.caption)
                  ],
                )
              ],
            ),
          ),
          IconButton(
              icon: const Icon(Icons.more_horiz, color: Colors.black54),
              onPressed: () {
                if (currentUser == null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginRegisterPage()));
                } else {
                  moreAction(context,
                      ownerId: ownerId,
                      postId: widget.itemId,
                      showDeleted: showDeleted,
                      view: 'Conversation');
                }
              })
        ],
      ),
    );
  }

  createConversationTileText() {
    if (description == "") {
      return SizedBox.shrink();
    } else {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: RichText(
            text: TextSpan(
              children: description
                  .split(' ')
                  .map((String t) => validateText(context, t))
                  .toList(),
            ),
          ));
    }
  }

  createConversationTilePicture() {
    return GestureDetector(
      onDoubleTap: () => controlUserLikeConversationTile(),
      onTap: () => photoPreview(context, url),
      child: Stack(alignment: Alignment.center, children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
              height: 200.0,
              width: 320,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(url),
                      fit: BoxFit.contain))),
        ),
        showHeart
            ? Icon(Icons.favorite,
                size: 80.0, color: Theme.of(context).primaryColor)
            : Text(""),
      ]),
    );
  }

  createConversationTileFooter() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 0, right: 10.0),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (currentUser == null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginRegisterPage()));
                  } else {
                    controlUserLikeConversationTile();
                  }
                },
                child: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                    size: 30.0,
                    color: isLiked ? Theme.of(context).primaryColor : kBlack),
              ),
              Text(
                " $likeCount",
                style: TextStyle(color: Colors.black87),
              ),
              IconButton(
                splashColor: Colors.blue,
                icon:
                    Icon(CupertinoIcons.chat_bubble_2, size: 30, color: kBlack),
                onPressed: () => displayComments(context,
                    postId: postId,
                    ownerId: ownerId,
                    url: url,
                    itemId: widget.itemId),
              ),
              Text(
                "$comments",
                style: TextStyle(color: Colors.black87),
              ),
            ],
          ),
          Container(
            height: 35.0,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                currentUser == null
                    ? CircleAvatar(
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
                Container(
                  width: MediaQuery.of(context).size.width - 80,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: kGrey100)),
                  child: TextField(
                    onTap: () {
                      if (currentUser == null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginRegisterPage()));
                      } else {
                        displayComments(context,
                            postId: postId,
                            ownerId: ownerId,
                            url: url,
                            itemId: widget.itemId);
                      }
                    },
                    decoration: const InputDecoration(
                        isDense: true,
                        hintText: "Comment",
                        hintStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: kGrey600),
                        contentPadding: EdgeInsets.only(top: 6.0),
                        prefixIcon: Icon(
                          CupertinoIcons.chat_bubble,
                          color: kGrey600,
                        ),
                        border: InputBorder.none),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  displayComments(BuildContext context,
      {required String postId,
      required String ownerId,
      required String url,
      required String itemId}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ConvCommentsScreen(
          postId: postId,
          token: token,
          postOwnerId: ownerId,
          postImageUrl: url,
          itemId: itemId);
    }));
  }

  void photoPreview(BuildContext context, photo) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhotoPreview(photo)));
  }
}
