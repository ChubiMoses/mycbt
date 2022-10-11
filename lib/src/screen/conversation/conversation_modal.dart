import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:katex_flutter/katex_flutter.dart';
import 'package:mycbt/src/models/quiz.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/services/network%20_checker.dart';
import 'package:mycbt/src/services/notify.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/screen/conversation/conversation_tile.dart';
import 'package:mycbt/src/screen/profile/profile_image.dart';
import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:mycbt/src/services/image_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ModalInsideModal extends StatefulWidget {
  final String questionId;
  final String question;
  final String answer;
  final String view;
  final String year;
  final String course;

  ModalInsideModal(
      {required this.questionId,
      required this.year,
      required this.view,
      required this.course,
      required this.question,
      required this.answer});

  @override
  _ModalInsideModalState createState() => _ModalInsideModalState();
}

class _ModalInsideModalState extends State<ModalInsideModal> {
  bool isLoading = true;
  int count = 0;
  List<ConversationTile> conversation = [];
  bool isTyping = false;
  bool isUploading = false;
  File? file;
  String question = "";
  String answer = "";
  String year = "";
  String course = "";
  bool emojiShowing = false;
  String postId = Uuid().v4();
  TextEditingController controller = TextEditingController();
  bool adReady = false;
  late BannerAd _bannerAd;
  Map<String, BannerAd> ads = <String, BannerAd>{};

  void handleTypeView() {
    setState(() => isTyping = true);
  }

  loadChats() {
    return StreamBuilder<QuerySnapshot>(
      stream: conversationRef
          .where("postId", isEqualTo: widget.questionId)
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return loader();
        }
        if (dataSnapshot.data!.docs.isEmpty) {
          return emptyWidget();
        }

        List<ConversationTile> posts = [];
        for (var doc in dataSnapshot.data!.docs) {
          posts.add(ConversationTile.fromDocument(doc));
        }

        conversation = posts;

        return SingleChildScrollView(child: Column(children: posts));
      },
    );
  }

  void getQuestionDetails() async {
    DocumentSnapshot doc =
        await yearOneQuestionsRef.doc(widget.questionId).get();
    Quiz quiz = Quiz.fromDocument(doc);

    setState(() {
      question = quiz.question;
      answer = quiz.answer;
      year = quiz.year;
      course = quiz.course;
    });

    if (widget.view != "Notification") {
      if (widget.answer != answer) {
        SnackBar snackBar = SnackBar(
            content: Text('Question updated... please update questions.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    isLoading = false;
  }

  @override
  void initState() {
    _bannerAd = BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            adReady = true;
          });
        }, onAdFailedToLoad: (ad, LoadAdError error) {
          adReady = false;
          ad.dispose();
        }),
        request: AdRequest())
      ..load();

    networkChecker(context, "No internet connection");
    getQuestionDetails();
    super.initState();
  }

  void controlSave() async {
    String image = "";
    if (currentUser?.url == "") {
      _showAlertDialog('Hello!', 'Upload a profile photo first.');
    } else {
      if (controller.text.length > 2) {
        //Await and upload photo
        if (file != null) {
          setState(() => isUploading = true);
          image = await compressingPhoto(file!);
        }

        await saveConversationTileInfoToFireStore(
            url: image, description: controller.text);
      } else {
        displayToast("Post is too short!");
      }
      setState(() {
        controller.clear();
      });
    }
  }

  saveConversationTileInfoToFireStore(
      {required String url, required String description}) {
    if (currentUser?.blocked == 1) {
      displayToast("Your account has been suspended!");
    } else {
      notificationLoop();
      conversationRef.doc().set({
        "postId": widget.questionId,
        "ownerId": currentUser?.id,
        "timestamp": DateTime.now(),
        "likes": {},
        'username': currentUser?.username,
        'description': description,
        'url': url,
        'profileImage': currentUser?.url,
        'comments': 0,
        'visible': 1,
        'lastAdded': DateTime.now().millisecondsSinceEpoch,
        'lastUpdated': DateTime.now().millisecondsSinceEpoch,
      });

      displayToast("Saving post...");
      setState(() => file = null);
      setState(() => isUploading = false);
      setState(() => isTyping = false);
    }
  }

  void notificationLoop() {
    try {
      final ids = conversation.map((e) => e.ownerId).toSet();
      conversation.retainWhere((x) => ids.remove(x.ownerId));
      for (var element in conversation) {
        if (element.ownerId != currentUser!.id) {
          usersReference.doc(element.ownerId).get().then((value) {
            String token = UserModel.fromDocument(value).token;
            String username = UserModel.fromDocument(value).username;
            notify(
                userId: currentUser?.id ?? "",
                nid: widget.questionId,
                ownerId: element.ownerId,
                username: element.username,
                profileImage: element.profileImage,
                token: token,
                body:
                    username + " also shared thought on $course $year answer.",
                type: "Conversation");
          });
        }
      }
    } catch (e) {
      displayToast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgScaffold,
      appBar: header(context, strTitle: "Conversation"),
      body: isLoading
          ? loader()
          : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Material(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: SafeArea(
                        child: Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              color: kWhite,
                              width: MediaQuery.of(context).size.width - 10,
                              child: Padding(
                                padding: EdgeInsets.all(30.0),
                                child: Column(
                                  children: [
                                    KaTeX(
                                        laTeXCode: Text(question,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: kBlack400,
                                                fontSize: 15))),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Answer: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: kBlack),
                                        ),
                                        KaTeX(
                                            laTeXCode: Text(answer,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .primaryColor)))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            adReady
                                ? SizedBox(
                                    height: _bannerAd.size.height.toDouble(),
                                    width: _bannerAd.size.width.toDouble(),
                                    child: AdWidget(ad: _bannerAd),
                                  )
                                : SizedBox.shrink(),
                            loadChats()
                          ],
                        ),
                        SizedBox(height: 30),
                        Container(
                          child: _buidMessageComposer(),
                        ),
                      ],
                    ))),
              ),
            ),
    );
  }

  _buidMessageComposer() {
    return Column(
      children: [
        Container(
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
                        TextStyle(color: kBlack, fontWeight: FontWeight.w500),
                    maxLines: 5,
                    controller: controller,
                    autofocus: false,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      hintText: 'What\'s your answer?',
                      border: InputBorder.none,
                    )),
              ),
              isUploading
                  ? SizedBox.shrink()
                  : IconButton(
                      icon: Icon(Icons.add_a_photo),
                      color: kGrey500,
                      onPressed: () => pickImage(),
                    ),
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (currentUser == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginRegisterPage()));
                    } else {
                      displayToast("Sending...");
                      if (controller.text.length < 3) {
                        displayToast("Post too short");
                      } else {
                        if (currentUser?.blocked == 1 ||
                            currentUser?.url == "") {
                          displayToast("Please upload a profile picture!");
                        } else {
                          controlSave();
                        }
                      }
                    }
                  },
                  color: Theme.of(context).primaryColor)
            ],
          ),
        ),
        file == null
            ? SizedBox.shrink()
            : isUploading
                ? loader()
                : Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      height: 100,
                      width: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(file!), fit: BoxFit.contain)),
                    ),
                  ),
      ],
    );
  }

  _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.white,
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text("Update"),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UploadProfileImage(
                    userId: currentUser?.id ?? "", view: 'Update')));
          },
        ),
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  Widget emptyWidget() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(CupertinoIcons.chat_bubble_2, size: 100.0, color: Colors.grey),
          SizedBox(
              width: 150.0,
              child: Text("Gone through the question; what's your own answer?.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1)),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void pickImage() async {
    FocusManager.instance.primaryFocus?.unfocus();
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowedExtensions: [
      'jpg',
      'png',
    ], type: FileType.custom);
    String? path = result?.files.single.path;
    if (path != null) {
      setState(() {
        file = File(path);
      });
    }
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
}
