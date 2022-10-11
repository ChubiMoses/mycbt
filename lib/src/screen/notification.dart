import 'package:mycbt/src/screen/conversation/conversation_modal.dart';
import 'package:mycbt/src/screen/conversation/doc_conversation.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/messages/messages.dart';
import 'package:mycbt/src/screen/question/answers_view.dart';
import 'package:mycbt/src/screen/question/photo_preview.dart';
import 'package:mycbt/src/services/notification_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/widgets/empty_state_widget.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:mycbt/src/utils/firebase_collections.dart';

class NotificationScreen extends StatefulWidget {
  final VoidCallback refreshNotification;
  const NotificationScreen({Key? key, required this.refreshNotification})
      : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          seenNotification();
          widget.refreshNotification();
          return true;
        },
        child: Scaffold(
            appBar: header(context, strTitle: "Notifications"),
            body: currentUser == null
                ? EmptyStateWidget(
                    "You don't have a notification at the moment.",
                    Icons.notifications)
                : FutureBuilder<dynamic>(
                    future: retrieveNotifications(),
                    builder: (context, dataSnapshot) {
                      if (!dataSnapshot.hasData) {
                        return loader();
                      }
                      // if (dataSnapshot.data!.docs.isEmpty) {
                      //   EmptyStateWidget("You don't have a notification",
                      //       Icons.notifications);
                      // }
                      return ListView(children: dataSnapshot.data!);
                    },
                  )));
  }

  retrieveNotifications() async {
    QuerySnapshot querySnapshot = await notificationReference
        .doc(currentUser?.id)
        .collection("list")
        .orderBy("timestamp", descending: true)
        .limit(60)
        .get();
    List<NotificationsItem> notificationItems = [];
    querySnapshot.docs.forEach((document) {
      notificationItems.add(NotificationsItem.fromDocument(document));
    });
    return notificationItems;
  }
}

String notificationItemText = "";
Widget? mediaPreview;

class NotificationsItem extends StatefulWidget {
  final String ownerId;
  final String id;
  final String type;
  final String userId;
  final String username;
  final String profileImage;
  final String body;
  final String nid;
  final Timestamp timestamp;
  final int seen;

  NotificationsItem(
      {required this.ownerId,
      required this.nid,
      required this.seen,
      required this.body,
       required this.id,
      required this.type,
      required this.username,
      required this.profileImage,
      required this.userId,
      required this.timestamp});

  factory NotificationsItem.fromDocument(DocumentSnapshot doc) {
    return NotificationsItem(
       id: doc.id,
        ownerId: doc.get("ownerId") ?? "",
        nid: doc.get("nid") ?? "",
        type: doc.get("type") ?? "",
        body: doc.get("body") ?? "",
        userId: doc.get("userId") ?? "",
        profileImage: doc.get("profileImage") ?? "",
        username: doc.get("username") ?? "",
        timestamp: doc.get("timestamp") ?? "",
        seen: doc.get("seen") ?? "");
  }

  @override
  _NotificationsItemState createState() => _NotificationsItemState();
}

class _NotificationsItemState extends State<NotificationsItem> {
  List<String> admin = ["Failed", "Welcome", "Points", "Success"];

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    return Padding(
        padding: EdgeInsets.only(bottom: 1.0),
        child: Column(
          children: [
            Container(
              color: Colors.white54,
              child: ListTile(
                onTap: () => displayFullPost(context),
                title: RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 14.0, color: Colors.black),
                      children: [
                        TextSpan(
                            text: admin.contains(widget.type)
                                ? ""
                                : widget.username+ " ",
                            style: TextStyle(
                                fontSize: 14.0,
                                color: kBlack,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: "$notificationItemText",
                          style: TextStyle(fontSize: 14.0),
                        )
                      ]),
                ),
                leading: admin.contains(widget.type)
                    ? CircleAvatar(
                        backgroundImage: AssetImage("assets/images/logo.png"),
                        radius: 25.0,
                        backgroundColor: Colors.grey[300],
                      )
                    : widget.profileImage == ""
                        ? CircleAvatar(
                            child: Icon(Icons.person, color: Colors.black54),
                            backgroundColor: Colors.grey[300],
                          )
                        : GestureDetector(
                            onTap: () =>
                                photoPreview(context, widget.profileImage),
                            child: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  widget.profileImage),
                              radius: 25.0,
                              backgroundColor: Colors.grey[300],
                            ),
                          ),
                subtitle: Text(
                  tAgo.format(widget.timestamp.toDate()),
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.caption,
                ),
                trailing: mediaPreview,
              ),
            ),
            Divider(
              height: 2,
              color: kGrey200,
            )
          ],
        ));
  }

  configureMediaPreview(context) {
    if (widget.seen == 0) {
      mediaPreview = Container(
        height: 15.0,
        width: 35.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0), color: Colors.green),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Text(
            "new",
            style: TextStyle(color: Colors.white, fontSize: 10.0),
          ),
        )),
      );
    } else {
      mediaPreview = SizedBox.shrink();
    }

    if (widget.type == "Like Answer") {
      notificationItemText = "likes your Answer.";
    } else if (widget.type == "Comment") {
      notificationItemText = "commented on your post.";
    } else if (widget.type == "Welcome") {
      notificationItemText =
          "Welcome to My CBT, Thanks  for joining the community. ";
    } else if (widget.type == "Success") {
      notificationItemText =
          "Your subscription was successful! thank you for choosing My CBT.";
    } else if (widget.type == "Failed") {
      notificationItemText =
          "Subscription failed due to invalid payment details, please try again.";
    } else if (widget.type == "Conversation Comment") {
      notificationItemText = "commented on your answer.";
    } else if (widget.type == "Conversation") {
      notificationItemText = widget.body;
    } else if (widget.type == "Like answer") {
      notificationItemText = "likes your answer.";
    } else {
      notificationItemText = widget.body;
    }
  }

  void displayFullPost(BuildContext context) {
    notificationReference
        .doc(currentUser?.id)
        .collection("list")
        .doc(widget.nid)
        .update({"seen": 1});
    //display post
    if (widget.type == "Like Answer" ||
        widget.type == "Like Question" ||
        widget.type == "Answer Question") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => QuestionView(widget.nid)));
    }
    if (widget.type == "Document Conversation") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DocConversation(
                    docId: widget.nid,
                    code: '',
                    title: '',
                  )));
    }
    if (widget.type == "Message") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Messages(() {})));
    }
    if (widget.type == "Conversation" ||
        widget.type == "Conversation Comment" ||
        widget.type == "Like conversation answer") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ModalInsideModal(
                    questionId: widget.nid,
                    view: "Notification",
                    answer: '',
                    course: '',
                    question: '',
                    year: '',
                  )));
    }
  }

  void photoPreview(BuildContext context, String photo) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhotoPreview(photo)));
  }
}
