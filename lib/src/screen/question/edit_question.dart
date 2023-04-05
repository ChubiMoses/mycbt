import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/profile/profile_image.dart';
import 'package:mycbt/src/screen/question/answers_view.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:uuid/uuid.dart';

class EditQuestion extends StatefulWidget {
  final String title;
  final String question;
  final String id;
   EditQuestion(this.id, this.question, this.title, {Key? key})
      : super(key: key);
  @override
  _EditQuestionState createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {
  File? file;
  TextEditingController titleController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  bool isLoading = false;
  String id =  Uuid().v4();

  @override
  void initState() {
    titleController.text = widget.title;
    questionController.text = widget.question;
    super.initState();
  }

  void updateQuestion() {
    setState(() => isLoading = true);
    if (titleController.text.isEmpty) {
      displayToast("Please enter question title");
    } else if (questionController.text.isEmpty) {
      displayToast("Please enter your question.");
    } else {
      questionsRef.doc(widget.id).update({
        "title": titleController.text,
        'question': questionController.text,
        'lastAdded': DateTime.now().millisecondsSinceEpoch / 1000.floor(),
        'lastUpdated': DateTime.now().millisecondsSinceEpoch / 1000.floor(),
      });
      setState(() => isLoading = false);
    }

    displayToast("Question updated.");
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => QuestionView(widget.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Ask  Question"),
      body: GestureDetector(
        onTap: () => Focus.of(context).unfocus(),
        child: SingleChildScrollView(
          padding:  EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              isLoading ? linearProgress() :  SizedBox.shrink(),
              Padding(
                padding:  EdgeInsets.all(2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    currentUser == null
                        ? CircleAvatar(
                            child:
                                 Icon(Icons.person, color: Colors.black54),
                            backgroundColor: Colors.grey[300],
                          )
                        : currentUser!.url == ""
                            ? CircleAvatar(
                                child:  Icon(Icons.person,
                                    color: Colors.black54),
                                backgroundColor: Colors.grey[300],
                              )
                            : CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    currentUser!.url),
                                radius: 25.0,
                                backgroundColor: Colors.grey[300],
                              ),
                     SizedBox(
                      width: 6.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            currentUser == null
                                ? "User"
                                : currentUser!.username,
                            style: Theme.of(context).textTheme.subtitle2),
                        Row(
                          children: [
                             Icon(CupertinoIcons.suit_diamond_fill,
                                size: 12.0, color: Colors.lightBlue),
                            currentUser == null
                                ?  Text("")
                                : Text(currentUser!.points.toString(),
                                    style: Theme.of(context).textTheme.caption),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
               SizedBox(height: 20.0),
              Padding(
                padding:  EdgeInsets.all(2.0),
                child: TextField(
                  maxLines: 2,
                  maxLength: 50,
                  readOnly: isLoading ? true : false,
                  controller: titleController,
                  textCapitalization: TextCapitalization.sentences,
                  style:  TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                  // ignore: prefer__ructors
                  decoration: InputDecoration(
                      enabledBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color: kGrey200)),
                      filled: true,
                      fillColor: kWhite,
                      hintText: 'Title',
                      hintStyle:  TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      helperText: "e.g Calculate the area of triangle",
                      focusedBorder:  OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor))),
                ),
              ),
               SizedBox(height: 5.0),
              Padding(
                padding:  EdgeInsets.all(2.0),
                child: TextField(
                  style:  TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                  maxLines: 10,
                  readOnly: isLoading ? true : false,
                  controller: questionController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: kWhite,
                      enabledBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color: kGrey200)),
                      hintText: 'Whats is your question?',
                      hintStyle:  TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      focusedBorder:  OutlineInputBorder(
                          borderSide:  BorderSide(
                              color: Theme.of(context).primaryColor))),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => updateQuestion(),
          child:  Icon(Icons.check)),
    );
  }

  _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.white,
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child:  const Text("Update"),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  UploadProfileImage(userId: currentUser!.id,view: 'Update'))),
        ),
        TextButton(
          child:  const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
