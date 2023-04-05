import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/services/image_service.dart';
import 'package:mycbt/src/services/network%20_checker.dart';
import 'package:mycbt/src/services/reward_bill_user.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  

class PDFDocUpload extends StatefulWidget {
  final String title;
  final int bytes;
  final String code;
  final File file;
  final String category;
  final String school;
  PDFDocUpload(
      {required this.file,
      required this.title,
      required this.school,
      required this.code,
      required this.category,
      required this.bytes});
  @override
  _UploadDocsState createState() => _UploadDocsState();
}

class _UploadDocsState extends State<PDFDocUpload> {
  int bytes = 0;
  String title = "";
  String message = "";
  List<DocModel> validPdf = [];
  bool uploadSuccess = false;
  bool uploadFailed = false;
  String id = const Uuid().v4();
  bool exist = false;
  String school = "";
  String courseId = "";

  @override
  void initState() {
    _handelConnetion();
    validatePdf();
    super.initState();
  }

  void _handelConnetion() async {
    networkChecker(context, "No internet connection");
  }

  Future saveToFirestore(String id, String url) async {
    studyMaterialsRef.doc(id).set({
      "id": id,
      "ownerId": currentUser?.id,
      "username":currentUser!.username,
      "ownerImage":currentUser!.url,
      "school": school,
      "title": widget.title,
      "originalTitle":widget.file.path.split("/").last,
      "bytes": widget.bytes,
      "likeIds": "",
      "ratings": "5,",
      "conversation": 0,
      "timestamp": DateTime.now(),
      "date":Jiffy(DateTime.now()).yMMMMd,
      'lastUpdated': DateTime.now().millisecondsSinceEpoch,
      'lastAdded': DateTime.now().millisecondsSinceEpoch,
      "visible": 0,
      "favorite": 0,
      "url": url,
      "category": widget.category,
      "code": widget.code,
    });

     //save to collection for older version
       qaDocRef.doc(id).set({
        "school": widget.school,
        'url': url,
        'updated': false,
        'visible': true,
        'type': 1,
        "title":"${widget.code} - ${widget.title}",
        "timestamp": DateTime.now(),
        'time': DateTime.now().millisecondsSinceEpoch / 1000.floor(),
      });
  }

  Future checkForExist() async {
    //query database to find similar document
    QuerySnapshot query1 = await studyMaterialsRef.where("title", isGreaterThanOrEqualTo: widget.title).get();
    validPdf = query1.docs .map((documentSnapshot) => DocModel.fromDocument(documentSnapshot)).toList();
    QuerySnapshot query2 = await studyMaterialsRef.where("originalTitle", isGreaterThanOrEqualTo:widget.file.path.split("/").last,).get();
    validPdf.addAll(query2.docs .map((documentSnapshot) => DocModel.fromDocument(documentSnapshot)).toList());
    QuerySnapshot query3 = await studyMaterialsRef.where("code", isGreaterThanOrEqualTo:widget.code).get();
    validPdf.addAll(query3.docs .map((documentSnapshot) => DocModel.fromDocument(documentSnapshot)).toList());
    if (validPdf != []) {
      for (var f in validPdf) {
        if (widget.bytes == f.bytes) {
          setState(() {
            exist = true;
          });
        }
      }
    }
  }

  Future<void> _uploadFile() async {
    if (widget.code != "" && widget.category != "") {
      String url = await uploadPDF(widget.file);
      await saveToFirestore(id, url);
      setState(() {
        uploadSuccess = true;
        title = "Upload successful.";
        //check if user is allowed to receive points after upload of after verification
        //snippet!.verifyPDF == 1 means receive points without verification
        //snippet!.verifyPDF == 2 means receive points after verification
       //snippet!.verifyPDF == 0 means stop pdf uploads

        if (snippet!.verifyPDF == 1) {
          rewardUser(currentUser!.id, 10);
          points += 10;
          message = "You have earned 10 points";
        } else if (snippet!.verifyPDF == 2) {
          message = "Points will be rewarded after verifying document, thanks.";
        }
      });
    } else {
      displayToast("Please select docs category");
      setState(() {
        uploadFailed = true;
        title = "Upload failed!";
      });
    }
  }

  // Check for file duplicate in the database
  validatePdf() async {
    await checkForExist();
    // Save pdf record in db after checking there is no duplicate
    if (exist == false) {
      await _uploadFile();
    } else if (exist == true) {
      setState(() {
        uploadFailed = true;
        title = "Doc exists in our database";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Column(
        children: <Widget>[
          Text(
              uploadSuccess
                  ? "Upload Succesful"
                  : uploadFailed
                      ? "Upload Failed"
                      : "Uploading...",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const Divider()
        ],
      ),
      children: <Widget>[
        uploadFailed
            ? customMessage(Icons.cancel_outlined)
            : uploadSuccess
                ? customMessage(Icons.check_circle)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).primaryColor),
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                      ),
                    ],
                  )
      ],
    );
  }

  Widget customMessage(IconData icon) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.suit_diamond_fill,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
              Text(uploadSuccess ? "10" : "0",
                  style: const TextStyle(
                      fontSize: 30.0,
                      color: kGrey600,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 100,
            child: Text(
                uploadSuccess
                    ? message
                    : "Document already exists.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13.0,
                    color: kGrey600,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
