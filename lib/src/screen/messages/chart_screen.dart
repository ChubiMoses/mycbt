import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/data/models/chat_model.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/modal/message_file_selector.dart';
import 'package:mycbt/src/services/message_service.dart';
import 'package:mycbt/src/services/user_online_checker.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:mycbt/src/widgets/empty_state_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:mycbt/src/widgets/message/message_tile.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String view;
  final UserModel user;
  final VoidCallback refresh;
  ChatScreen({
    required this.view,
    required this.chatId,
    required this.refresh,
    required this.user,
  });
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool emojiShowing = false;
  List<ChatModel> chats = [];
  File? file;
  bool isLoading = true;
  bool isUploading = false;
  String chatId = "";
  bool unsentMessage = false;
  String image = "";
  TextEditingController controller = TextEditingController();
  bool isOnline = false;

  
  @override
  void initState() {
    super.initState();
    getChatId();
    isOnline = userOnline(widget.user.id, widget.user.lastSeen);
  }

  loadChats() {
    return StreamBuilder<QuerySnapshot>(
      stream: messageRef.where('chatId', isEqualTo: chatId).snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return loader();
        }
        if (dataSnapshot.data!.docs.isEmpty) {
          return EmptyStateWidget("Send message to ${widget.user.username}.",
              CupertinoIcons.chat_bubble);
        }
        List<MessageTile> messages = [];
        for (var doc in dataSnapshot.data!.docs) {
          messages.add(MessageTile.fromDocument(doc));
        }

        for (var element in messages) {
          if (element.seen == 0 && element.receiver == currentUser!.id) {
            messageRef.doc(element.id).update({"seen": 1});
          }
        }
        messages.sort((a, b) {
          return b.lastAdded.compareTo(a.lastAdded);
        });
        return ListView(
           physics: const BouncingScrollPhysics(),
          shrinkWrap: true, reverse: true, children: messages);
      },
    );
  }

  void pickImageFromGallery() async {
    FocusManager.instance.primaryFocus?.unfocus();
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: ['jpg', 'png'], type: FileType.custom);
    String? path = result?.files.single.path;
    if (path != null) {
      setState(() {
        file = File(path);
      });
    }
    if (file != null) {
      await sendMessage();
    }
    setState(() => isUploading = false);
  }

  //create chat id for new chats
  Future<void> getChatId() async {
    chatId = await createChat(userId: widget.user.id, chatId: widget.chatId);
    setState(() {
      chatId = chatId;
    });
  }

  // void loadMessages() async {
  //   messages = await getMessages(chatId);
  //   setState(() => messages = messages);
  //   setState(() => isLoading = false);
  // }

  Future<void> sendMessage() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await messageSaver(
        message: controller.text,
        chatId: chatId,
        receiverId: widget.user.id,
        file: file,
        isPdf: false);

    chatsRef.doc(chatId).update({'timestamp': DateTime.now()});
    setState(() => controller.text = "");
  }

  _onEmojiSelected(Emoji emoji) {
    controller
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
  }

  _onBackspacePressed() {
    controller
      ..text = controller.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
  }

  _buidMessageComposer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      height: 80.0,
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
                style:
                    const TextStyle(color: kBlack, fontWeight: FontWeight.w500),
                maxLines: 5,
                controller: controller,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: "Message...",
                  border: InputBorder.none,
                )),
          ),
          IconButton(
              icon: Icon(Icons.attachment),
              color: kGrey500,
              onPressed: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return MessageFileSelector(
                      message: controller.text,
                      chatId: chatId,
                      receiverId: widget.user.id,
                    );
                  })),
          IconButton(
              icon: Icon(Icons.send),
              onPressed: () => sendMessage(),
              color: Theme.of(context).primaryColor)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (widget.view == "messagesScreen") {
            widget.refresh();
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: kBgScaffold,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0.0,
            title: Container(
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(widget.user.url),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 14.0),
                      Text(
                        widget.user.username,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0),
                      ),
                      Text(
                        isOnline ? "Online" : "Offline",
                        style: TextStyle(color: Colors.white, fontSize: 10.0),
                      ),
                    ],
                  )
                ],
              ),
            ),
            actions: unsentMessage
                ? <Widget>[
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        messageRef
                            .doc(chatId)
                            .collection("Items")
                            .doc()
                            .update({'visible': 0}).then((value) {
                          displayToast("Message unsent.");
                          setState(() => unsentMessage = false);
                          // loadMessages();
                        });
                      },
                    ),
                  ]
                : null,
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: chatId == "" ? loader() : loadChats(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _buidMessageComposer(),
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
            ),
          ),
        ));
  }
}
