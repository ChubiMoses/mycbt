import 'dart:async';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();

class ReportScreen extends StatefulWidget {
  final String postId;
  final String view;
  final String ownerId;
  const ReportScreen(
      {required this.postId, required this.ownerId, required this.view});
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController reportController = TextEditingController();
  String selectedOption = "";
  String report = "";
  List<String> options = [
    "It's suspicious or spam",
    "It's displays a sensitive photo or video",
    "It's abusive",
    "It's harmful",
    "It contains copyrighted materials",
  ];

  reportPDF() {
    reportReference.doc().set({
      "postId": widget.postId,
      "view": widget.view,
      "ownerId": widget.ownerId,
      "report": reportController.text + selectedOption
    });
    SnackBar snackBar = const SnackBar(
        content: Text("Report sent. our team will look into it, Thank you!"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Timer(const Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context, strTitle: "Report an Issue"),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Text(
                    "Help us understand the problem. what's going on with this post?",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
              ),
              ListView.builder(
                  itemCount: options.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    return Card(
                      color: selectedOption == options[i]
                          ? Theme.of(context).primaryColor
                          : kWhite,
                      elevation: 0.0,
                      child: ListTile(
                        onTap: () => setState(
                          () => selectedOption = options[i],
                        ),
                        trailing: Icon(Icons.chevron_right),
                        title: Text(
                          options[i],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color:
                                selectedOption == options[i] ? kWhite : kBlack,
                          ),
                        ),
                      ),
                    );
                  }),
              selectedOption != ""
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 15.0),
                          child: TextFormField(
                              controller: reportController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                  helperText: "Any Additional information?",
                                  fillColor: kWhite,
                                  filled: true,
                                  labelText: 'Report(Optional)',
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: kGrey200),
                                      borderRadius:
                                          BorderRadius.circular(5.0)))),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          width: MediaQuery.of(context).size.width - 50,
                          child: TextButton(
                            onPressed: () => reportPDF(),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 70.0, vertical: 15),
                              child: Text("DONE",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kWhite)),
                            ),
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
                        )
                      ],
                    )
                  : SizedBox.shrink()
            ])),
      ),
    );
  }
}
