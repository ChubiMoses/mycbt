import 'package:flutter/material.dart';
import 'package:mycbt/src/models/pre_exam.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';

class PreeExamResult extends StatefulWidget {

  @override
  _PreeExamResultState createState() => _PreeExamResultState();
}

class _PreeExamResultState extends State<PreeExamResult> {
  bool isLoading = true;
  List<PreExamScore> score = [];
  String result = "";
  @override
  void initState() {
    getScores();
    super.initState();
  }

  void getScores() async {
    await preExamResult.orderBy("score", descending:true).get().then((value) {
      score = value.docs
          .map((document) => PreExamScore.fromDocument(document))
          .toList();
    });

    // score.forEach((element) {
    //   result += "USERNAME:" +
    //       element.username +
    //       ", " +
    //       "REG NUMBER:" +
    //       element.regNumber +
    //       ", " +
    //       "TIME:" +
    //       element.time +
    //       ", " +
    //       "SCORE:" +
    //       element.score.toString()+
    //       " \n";
    // });
    setState(() {
      result = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, strTitle: "Result"),
        body:isLoading ? loader() : 
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SelectableText(
            result,
          ),
        ));
  }
}
