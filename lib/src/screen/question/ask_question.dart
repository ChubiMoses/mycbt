import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:mycbt/src/screen/modal/earn_points_modal.dart';
import 'package:mycbt/src/screen/profile/profile_image.dart';
import 'package:mycbt/src/services/image_service.dart';
import 'package:mycbt/src/services/reward_bill_user.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:uuid/uuid.dart';

class AskQuestion extends StatefulWidget {
  final VoidCallback refresh;
  const AskQuestion(this.refresh, {Key? key}) : super(key: key);
  @override
  _AskQuestionState createState() => _AskQuestionState();
}

class _AskQuestionState extends State<AskQuestion> {
  File? file;
  TextEditingController titleController = TextEditingController();
  TextEditingController postController = TextEditingController();
  bool uploading = false;
  String id = const Uuid().v4();
  List<String> category = [
    "Category",
    "History",
    "Arts",
    "Business",
    "Health",
    "Law",
    "Biology",
    "Computers and Technology",
    "Chemistry",
    "Engineering",
    "Mathematics",
    "Programming",
    "Geography",
    "Others"
  ];
  String _selectedCat = "Category";

  pickImageFromGallery() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: ['jpg', 'png'], type: FileType.custom);
    String? path = result?.files.single.path;
    if (path != null) {
      setState(() {
        file = File(path);
      });
    }
  }

  clearPostInfo() {
    postController.clear();
    setState(() {
      file = null;
    });
  }

  savePostInfoToFireStore(
      {required String url, required String title, required String question}) {
    if (currentUser!.blocked == 1) {
      displayToast("Your Account has been suspended!");
    } else {
      questionsRef.doc(id).set({
        "id": id,
        "userId": currentUser!.id,
        "profileImage": currentUser!.url,
        "username": currentUser!.username,
        "timestamp": DateTime.now(),
        "likeIds": "",
        "dislikeIds": "",
        "title": title,
        'question': question,
        'visible': 1,
        'image': url,
        'answers': 0,
        'category': _selectedCat,
        'lastAdded': DateTime.now().millisecondsSinceEpoch / 1000.floor(),
        'lastUpdated': DateTime.now().millisecondsSinceEpoch / 1000.floor(),
      });

      if (!subscribed) {
        billUser(currentUser!.id, 5);
      }
      widget.refresh();
      displayToast("Question posted.");
      Navigator.pop(context);
    }
  }

  void handleSave() async {
    if (currentUser == null) {
      Navigator.push(context,MaterialPageRoute(builder: (context) => LoginRegisterPage()));
    } else {
      if(_selectedCat == "Category") {
        displayToast("Please select category");
      } else {
        if(!subscribed  && points < 5) {
            showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return EarnPointsModal(
                    message: "You need 5 points to ask question.",
                    code: "ask question",
                  );
                });
        
        } else {
          if (currentUser?.url == "") {
            displayToast("hello");
            _showAlertDialog('Hello!',
                'Please  update your profile picture.');
          } else {
            if (postController.text.length > 5) {
              if (titleController.text.length > 5) {
                  setState(() => uploading = true);
                  if (file != null) {
                    String downloadUrl = await compressingPhoto(file!);
                    await savePostInfoToFireStore(
                        url: downloadUrl,
                        title: titleController.text,
                        question: postController.text);
                  } else {
                    await savePostInfoToFireStore(
                        url: "",
                        title: titleController.text,
                        question: postController.text);
                  }
                  setState(() => postController.clear());
               
              } else {
                displayToast("Question title is too short.");
              }
            } else {
              displayToast("Question length is too short.");
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Ask  Question"),
      body: GestureDetector(
        onTap: () => Focus.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              uploading ? linearProgress() : SizedBox.shrink(),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.all(2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    currentUser == null
                        ? CircleAvatar(
                            child: Icon(Icons.person, color: Colors.black54),
                            backgroundColor: Colors.grey[300],
                          )
                        : currentUser!.url == ""
                            ? CircleAvatar(
                                child:
                                    Icon(Icons.person, color: Colors.black54),
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
                                size: 12.0,
                                color: Theme.of(context).primaryColor),
                            currentUser == null
                                ? Text("")
                                : Text(currentUser!.points.toString(),
                                    style: Theme.of(context).textTheme.caption),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.all(2.0),
                child: TextField(
                  maxLines: 1,
                  maxLength: 50,
                  readOnly: uploading ? true : false,
                  controller: titleController,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  // ignore: prefer__ructors
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kGrey200)),
                      filled: true,
                      fillColor: kWhite,
                      hintText: 'Title',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      helperText: "e.g Calculate the area of triangle",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor))),
                ),
              ),
              SizedBox(height: 5.0),
              Padding(
                padding: EdgeInsets.all(2.0),
                child: TextField(
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  maxLines: 10,
                  readOnly: uploading ? true : false,
                  controller: postController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: kWhite,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kGrey200)),
                      hintText: 'Whats is your question?',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor))),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: kWhite,
                    border: Border.all(color: kGrey200),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: DropdownButton(
                      isExpanded: true,
                      underline: SizedBox.shrink(),
                      hint: Text("Select category"),
                      value: _selectedCat,
                      items: category.map((t) {
                        return DropdownMenuItem(
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                t,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14),
                              )),
                          value: t,
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedCat = val.toString();
                        });
                      }),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                          child: Icon(
                            Icons.add_a_photo,
                            color: kBlack,
                          ),
                        ),
                        radius: 20.0,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Image",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.0),
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
                            padding: EdgeInsets.only(
                              left: 180.0,
                            ),
                            child: CircleAvatar(
                              radius: 14.0,
                              backgroundColor: kBlack,
                              child: IconButton(
                                onPressed: () => setState(() => file = null),
                                icon: Icon(CupertinoIcons.clear,
                                    size: 12.0, color: Colors.white),
                              ),
                            ))
                      ],
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
          onPressed: () => handleSave(),
          child: Icon(Icons.check)),
    );
  }

  _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.white,
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: const Text("Update"),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  UploadProfileImage(userId: currentUser!.id, view: 'Update'))),
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
}
