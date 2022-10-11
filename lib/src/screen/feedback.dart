import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:uuid/uuid.dart';

class FeedBack extends StatefulWidget {
  final String page;
  FeedBack(this.page);
  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  final formkey = GlobalKey<FormState>();
  String id = Uuid().v4();
  bool uploading = false;
  bool uploadDone = false;
  String feedback = "";

  saveFeedback() async {
    setState(() {
      uploading = true;
      id = Uuid().v4();
    });

//save feedback
    feedbackRef.doc(id).set({
      "id": id,
      "userId": currentUser?.id,
      "feedback": feedback,
    });
//user has rated using feedback, will have to rate again in next version
    settingsReference.doc(currentUser?.id).update({
      "rate": 3,
    });

    setState(() {
      uploading = false;
      uploadDone = true;
    });
  }

  validate() {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      saveFeedback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, strTitle: "Feedback"),
        backgroundColor:kBgScaffold,
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: uploading
                ? loader()
                : uploadDone
                    ? Card(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.check_circle),
                              Text("Feedback sent, thank you."),
                              TextButton(
                                child: const Text(
                                  "Done",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0),
                                ),
                                onPressed: () => Navigator.pop(context),
                                 style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.white),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      kPrimaryColor),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
               ),
                            ],
                          ),
                        ),
                      )
                    : Card(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 5.0),
                            Text(widget.page == "Rate"
                                ? "You rated us poor!"
                                : ""),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: Form(
                                key: formkey,
                                child: TextFormField(
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                      labelText: 'Feeback',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0))),
                                  validator: (val) => val!.length < 5
                                      ? "Your feed back is too short!"
                                      : null,
                                  onSaved: (val) => feedback = val!,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                widget.page == "Rate"
                                    ? "Please, tell us what you don't like about our App and we will work on it."
                                    : "Having issues or feedback? please let us know.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            TextButton(
                              child: Text(
                                "Send",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                              ),
                              onPressed: () => validate(),
                               style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        kPrimaryColor),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                ),
                              ),
                              
                            ),
                          ],
                        ),
                      )));
  }
}
