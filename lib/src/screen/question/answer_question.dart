import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/models/question.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/profile/profile_image.dart';
import 'package:mycbt/src/screen/question/questions_tile.dart';
import 'package:mycbt/src/services/image_service.dart';
import 'package:mycbt/src/services/notify.dart';
import 'package:mycbt/src/services/responsive_helper.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:uuid/uuid.dart';
import 'package:mycbt/src/screen/question/answers_view.dart';

class AnswerQuestion extends StatefulWidget {
  final String id;
  final String userId;
  final String token;
  const AnswerQuestion(this.id, this.userId, this.token, {Key? key}) : super(key: key);
  @override
  _AnswerQuestionState createState() => _AnswerQuestionState();
}

class _AnswerQuestionState extends State<AnswerQuestion> {
  File? file;
  TextEditingController postController = TextEditingController();
  String itemId = Uuid().v4();
  bool uploading = false;
  Questions? post;
  int answers = 0;
  bool isLoading = true;

  @override
  void initState() {
    getQuestion();
    super.initState();
  }

  void getQuestion() {
    questionsRef.doc(widget.id).get().then((value) {
      post = Questions.fromDocument(value);
      setState(() {
        post = post;
        isLoading = false;
      });
    });
  }

  void pickImageFromGallery() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: ['jpg', 'png'], type: FileType.custom);
    String? path = result?.files.single.path;
    if (path != null) {
      setState(() {
        file = File(path);
      });
    }
  }

  void clearPostInfo() {
    postController.clear();
    setState(() {
      file = null;
    });
  }

  void savePostInfoToFireStore(
      {required String image, required String answer}) {
    if (currentUser!.blocked == 1) {
      displayToast("Your Account has been suspended!");
    } else {
      answersRef.doc(widget.id).collection("Items").doc(itemId).set({
        "id": widget.id,
        "itemId": itemId,
        "userId": currentUser!.id,
        "username": currentUser!.username,
        "profileImage": currentUser!.url,
        "timestamp": DateTime.now(),
        "likeIds": "",
        'answer': answer,
        'image': image,
        'visible': 1,
        "dislikeIds": "",
        'lastAdded': DateTime.now().millisecondsSinceEpoch / 1000.floor(),
        'lastUpdated': DateTime.now().millisecondsSinceEpoch / 1000.floor(),
      });
      incAnswerCount();
      handleNotification();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => QuestionView(widget.id)));
    }
  }

  Future<void> incAnswerCount() async {
    questionsRef.doc(widget.id).get().then((value) {
      if (value.exists) {
        Questions data = Questions.fromDocument(value);
        int totalComments = (data.answers + 1);
        questionsRef.doc(post!.id).update({
          "answers": totalComments,
        });
      }
    });
  }

  handleNotification() {
    //  if (currentOnlineUserId != widget.userId) {
    notify(
        userId: currentUser!.id,
        username:currentUser!.username,
        profileImage:currentUser!.url,
        nid: widget.id,
        type: "Answer Question",
        body: "answered your question",
        ownerId: widget.userId,
        token: widget.token);
    // }
  }

  Future<void> handleSave() async {
    //Save post without image
    if (currentUser!.url == "") {
      _showAlertDialog('Hello!',
          'In other to answer, you will have to update your profile photo.');
    } else {
      if (postController.text.length > 5) {
        setState(() => uploading = true);
        if (file != null) {
          String downloadimage = await compressingPhoto(file!);
          savePostInfoToFireStore(
              image: downloadimage, answer: postController.text);
        } else {
          savePostInfoToFireStore(image: "", answer: postController.text);
        }
        setState(() => postController.clear());
        setState(() => uploading = false);
      } else {
        displayToast("Post is too short!");
      }
    }
    //  Focus.of(context).unfocus();
  }

  _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.white,
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: const Text("Update"),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    UploadProfileImage(userId: currentUser!.id, view: 'Update',)));
          },
        ),
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Answer  Question"),
      body: GestureDetector(
        onTap: () => Focus.of(context).unfocus(),
        child: SingleChildScrollView(
           padding:EdgeInsets.symmetric(
              horizontal:ResponsiveHelper.isDesktop(context) ? 300 :
              ResponsiveHelper.isTab(context) ? 200 : 0, vertical: ResponsiveHelper.isMobilePhone() ? 0 : 20),
          child: Column(
            children: <Widget>[
              uploading ? linearProgress() : SizedBox.shrink(),
              isLoading
                  ? loader()
                  : QuestionTile(
                      dislikeIds:post!.dislikeIds,
                      userId: post!.userId,
                      likeIds: post!.likeIds,
                      id: post!.id,
                      question: post!.question,
                      image: post!.image,
                      title: post!.title,
                      answers: post!.answers,
                      timestamp: post!.timestamp,
                      view: "Answer",
                      profileImage: post!.profileImage,
                      username: post!.username,
                    ),
              SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 10,
                  autofocus: true,
                  controller: postController,
                  readOnly: uploading ? true : false,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kGrey200)),
                      filled: true,
                      fillColor: kWhite,
                      hintText: 'Your answer',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: pickImageFromGallery,
                      child: CircleAvatar(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: kGrey300,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Icon(
                            Icons.add_a_photo,
                            color: kBlack,
                          ),
                        ),
                        radius: 20.0,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Question",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              file == null
                  ? SizedBox.shrink()
                  : Stack(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 100.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(file!), fit: BoxFit.cover)),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                              left: 180.0,
                            ),
                            child: CircleAvatar(
                              radius: 14.0,
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                              child: IconButton(
                                onPressed: () => setState(() => file = null),
                                icon: Icon(CupertinoIcons.clear,
                                    size: 12.0, color: Colors.white),
                              ),
                            ))
                      ],
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor:
              uploading ? kGrey400 : Theme.of(context).primaryColor,
          onPressed: uploading ? null : () => handleSave(),
          child: const Icon(Icons.check)),
    );
  }
}
