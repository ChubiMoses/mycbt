import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/modal/message_file_selector_modal.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/services/doc_conv_services.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:mycbt/src/widgets/message/doc_message_tile.dart';

class DocConversation extends StatefulWidget {
  final String title;
  final String code;
  final String docId;

  const DocConversation({
    required this.title,
    required this.code,
    required this.docId,
  });

  @override
  _DocConversationState createState() => _DocConversationState();
}

class _DocConversationState extends State<DocConversation> {
  bool emojiShowing = false;
  List<DocConversationTile> messages = [];
  ScrollController scrollController = ScrollController();
  File? file;
  bool isLoading = true;
  bool isUploading = false;
  TextEditingController controller = TextEditingController();
  bool adReady = false;
  late BannerAd _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            adReady = true;
          });
        }, onAdFailedToLoad: (ad, LoadAdError error) {
          adReady = false;
          ad.dispose();
        }),
        request: const AdRequest())
      ..load();
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

  void pickImageFromGallery() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: ['jpg', 'png'], type: FileType.custom);
    String? path = result?.files.single.path;
    if (path != null) {
      setState(() {
        file = File(path);
      });
      if (file != null) {
        await handleSend();
      }
      setState(() => isUploading = false);
    }
  }

  Future<void> handleSend() async {
    if (currentUser == null) {
      displayToast("Please login");
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
      if (controller.text.isNotEmpty) {
        await sendMessage(
            messages, widget.code, controller.text, widget.docId, null, false);
        displayToast("Sent...");
        setState(() => controller.text = "");
      }
    }
  }

  loadChats() {
    setState(() {
      messages = [];
    });
    return StreamBuilder<QuerySnapshot>(
      stream: docConversationRef
          .doc(widget.docId)
          .collection("Items")
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return loader();
        }
        if (dataSnapshot.data!.docs.isEmpty) {
          return emptyStateWidget();
        }
        messages = [];
        for (var doc in dataSnapshot.data!.docs) {
          messages.add(DocConversationTile.fromDocument(doc));
        }

        return ListView(
            physics: const BouncingScrollPhysics(),
            // controller: scrollController,
            reverse: true,
            shrinkWrap: true,
            children: messages);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgScaffold,
      appBar: AppBar(
        title: Text(
          widget.code + " Discussion",
          style: const TextStyle(color: kWhite, fontSize: 16),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: loadChats(),
              ),
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
                        bgColor: Color(0xFFF2F2F2),
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
    );
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
            icon: const Icon(
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
                style: TextStyle(color: kBlack, fontWeight: FontWeight.w500),
                maxLines: 5,
                controller: controller,
                autofocus: false,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none,
                )),
          ),
          isUploading
              ? SizedBox.shrink()
              : IconButton(
                  icon: Icon(Icons.attachment_outlined),
                  color: kGrey500,
                  onPressed: () {
                    if (currentUser == null) {
                      displayToast("Please login");
                    } else {
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return MessageFileSelector(
                                message: controller.text,
                                docId: widget.docId,
                                messages: messages,
                                code: widget.code,
                                refresh: () {});
                          });
                    }
                  },
                ),
          IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                FocusScope.of(context).autofocus;
                handleSend();
              },
              color: Theme.of(context).primaryColor)
        ],
      ),
    );
  }

  Widget emptyStateWidget() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(CupertinoIcons.chat_bubble_2, size: 100.0, color: Colors.grey),
          SizedBox(
              width: 150.0,
              child: Text("Gone through ${widget.code}? share your thought!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1)),
          const SizedBox(
            height: 20,
          ),
          adReady
              ? SizedBox(
                  height: _bannerAd.size.height.toDouble(),
                  width: _bannerAd.size.width.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
