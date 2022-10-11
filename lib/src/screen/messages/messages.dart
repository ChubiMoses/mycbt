import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mycbt/src/data/models/message_model.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/messages/chart_screen.dart';
import 'package:mycbt/src/services/user_online_checker.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/empty_state_widget.dart';
import 'package:mycbt/src/widgets/message/message_tile.dart';

class Messages extends StatefulWidget {
  final VoidCallback refreshMessage;
  Messages(this.refreshMessage);
  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  List<MessageTile> messages = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getMessages();
  }

  void getMessages() async {
    messages = [];
    QuerySnapshot querySnapshot = await messageRef.orderBy('timestamp', descending: true).get();
    List<MessageTile> messagesList = querySnapshot.docs
        .map((document) => MessageTile.fromDocument(document))
        .toList();

     final ids = messagesList.map((e) => e.chatId).toSet();
     messagesList.retainWhere((x) => ids.remove(x.chatId));

    for (var e in messagesList) {
      if (e.receiver == currentUser?.id || e.sender == currentUser?.id) {
        messages.add(e);
      }
    }
    setState(() => messages = messages);
    setState(() => isLoading = false);
  }

  Future<UserModel> getUser(String userId) async {
    UserModel user;
    DocumentSnapshot snap = await usersReference.doc(userId).get();
    user = UserModel.fromDocument(snap);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          updateLastSeen();
          widget.refreshMessage();
          return true;
        },
        child: Scaffold(
          appBar: header(
            context,
            strTitle: "Messages",
          ),
          body: SafeArea(
              child: isLoading
                  ? loader()
                  : messages.isEmpty
                      ? EmptyStateWidget(
                          "You don't have a message at the moment.",
                          CupertinoIcons.chat_bubble,
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                             physics: const BouncingScrollPhysics(),
                            itemCount: messages.length,
                            itemBuilder: (BuildContext context, int index) {
                              final MessageTile message = messages[index];
                              bool seen = false;
                              String messageBody = message.message;
                              if (message.seen == 1) {
                                seen = true;
                              }
                              return FutureBuilder(
                                future: getUser(
                                    message.sender == currentUser?.id
                                        ? message.receiver
                                        : message.sender),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return loader();
                                  }
                                  UserModel? user = snapshot.data as UserModel?;
                                  return GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ChatScreen(
                                                  chatId: message.id,
                                                  refresh: getMessages,
                                                  user: user!,
                                                  view: 'messagesScreen',
                                                ))),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 6, right: 6, left: 6),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    radius: 25,
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                            user!.url),
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 4.0,
                                                      ),
                                                      Text(user.username,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14.0,
                                                          )),
                                                      SizedBox(
                                                        height: 1.0,
                                                      ),
                                                      Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    200,
                                                                child: Text(
                                                                    messageBody.length ==
                                                                            0
                                                                        ? "sent an image"
                                                                        : messageBody,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          kBlack400,
                                                                      fontSize:
                                                                          14.0,
                                                                    )),
                                                              ),
                                                            ],
                                                          )),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  message.timestamp == null
                                                      ? SizedBox.shrink()
                                                      : Text(
                                                          DateFormat.jm()
                                                              .format(message
                                                                  .timestamp
                                                                  .toDate()),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12.0,
                                                              fontFamily:
                                                                  "Lato"),
                                                        ),

                                                  //Check if unread
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  seen
                                                      ? Icon(
                                                          Icons
                                                              .check_circle_outline,
                                                          size: 12,
                                                          color:
                                                              Theme
                                                                      .of(
                                                                          context)
                                                                  .primaryColor)
                                                      : message
                                                                  .sender ==
                                                              currentUser?.id
                                                          ? Icon(
                                                              Icons
                                                                  .check_circle_outline,
                                                              size: 12,
                                                              color: kGrey300)
                                                          : Container(
                                                              width: 25.0,
                                                              height: 13.0,
                                                              decoration: BoxDecoration(
                                                                  color: Theme
                                                                          .of(
                                                                              context)
                                                                      .primaryColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30.0)),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                'NEW',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 8.0,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        )),
        ));
  }
}
