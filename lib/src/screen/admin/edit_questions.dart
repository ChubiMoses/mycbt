import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/buttons.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:katex_flutter/katex_flutter.dart';

class EditQuestions extends StatefulWidget {
  final String question;
  final String answers;
  final String option1;
  final String option2;
  final String option3;
  final String id;
  final String view;
  EditQuestions(
      {
      required this.question,
      required this.view,
      required this.id,
      required this.answers,
      required this.option3,
      required this.option2,
      required this.option1});
  @override
  _EditQuestionsState createState() => _EditQuestionsState();
}

class _EditQuestionsState extends State<EditQuestions> {
  TextEditingController answerController = TextEditingController();
  TextEditingController option1Controller = TextEditingController();
  TextEditingController option2Controller = TextEditingController();
  TextEditingController option3Controller = TextEditingController();
  TextEditingController questionController = TextEditingController();
  String question = "";
  String answer = "";
  String option1 = "";
  String option2 = "";
  String option3 = "";
  bool _uploading = false;

  void saveQuestion() async {
    if (widget.view == "Test") {
      preExamsQuestions.doc(widget.id).update({
        "question": questionController.text,
        "answer": answerController.text,
        "option1": option1Controller.text,
        "option2": option2Controller.text,
        "option3": option3Controller.text,
      });
    } else {
      yearOneQuestionsRef.doc(widget.id).update({
        "question": questionController.text,
        "answer": answerController.text,
        "option1": option1Controller.text,
        "option2": option2Controller.text,
        "option3": option3Controller.text,
      });
    }

    setState(() {
      questionController.clear();
      answerController.clear();
      option1Controller.clear();
      option2Controller.clear();
      option3Controller.clear();
      _uploading = false;
    });
    displayToast("Question saved");
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    questionController.text = widget.question;
    answerController.text = widget.answers;
    option1Controller.text = widget.option1;
    option2Controller.text = widget.option2;
    option3Controller.text = widget.option3;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.bodyText1;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          centerTitle: false,
          elevation: 2.0,
          title: Text("Edit Questions",
              style: TextStyle(fontSize: 20.0, color: Colors.white)),
          actions: [
            IconButton(
                icon: Icon(Icons.delete), onPressed: () => deleteQuestion())
          ]),
      body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: _uploading
              ? loader()
              : Card(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: TextFormField(
                          maxLines: 2,
                          controller: questionController,
                          style: textStyle,
                          decoration: InputDecoration(
                              labelText: 'Question',
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (val) =>
                              val?.length == 0 ? "Field empty" : null,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          latexPreview(question),
                          IconButton(
                            onPressed: () => questionTex(),
                            icon: Icon(Icons.crop_rotate),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: TextFormField(
                          maxLines: 2,
                          controller: answerController,
                          style: textStyle,
                          decoration: InputDecoration(
                              labelText: 'Answer',
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (val) =>
                              val?.length == 0 ? "Field empty" : null,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          latexPreview(answer),
                          IconButton(
                            onPressed: () => answerTex(),
                            icon: Icon(Icons.crop_rotate),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: TextFormField(
                          maxLines: 2,
                          style: textStyle,
                          controller: option1Controller,
                          decoration: InputDecoration(
                              labelText: 'option1',
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (val) =>
                              val?.length == 0 ? "Field empty" : null,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          latexPreview(option1),
                          IconButton(
                            onPressed: () => option1Tex(),
                            icon: Icon(Icons.crop_rotate),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: TextFormField(
                          maxLines: 2,
                          style: textStyle,
                          controller: option2Controller,
                          decoration: InputDecoration(
                              labelText: 'Option2',
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (val) =>
                              val?.length == 0 ? "Field empty" : null,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          latexPreview(option2),
                          IconButton(
                            onPressed: () => option2Tex(),
                            icon: Icon(Icons.crop_rotate),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: TextFormField(
                          maxLines: 2,
                          controller: option3Controller,
                          style: textStyle,
                          decoration: InputDecoration(
                              labelText: 'Option3',
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (val) =>
                              val?.length == 0 ? "Field empty" : null,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          latexPreview(option3),
                          IconButton(
                            onPressed: () => option3Tex(),
                            icon: Icon(Icons.crop_rotate),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButtonWidget(btnText:"Save" , onPressed: () => saveQuestion(),) 
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }

  Widget latexPreview(String latex) {
    return Container(
        width: MediaQuery.of(context).size.width - 120,
        child: Builder(
          builder: (context) => KaTeX(
            laTeXCode:
                Text(latex, style: Theme.of(context).textTheme.bodyText2),
          ),
        ));
  }

  void questionTex() {
    setState(() {
      question = questionController.text;
    });
  }

  void answerTex() {
    setState(() {
      answer = answerController.text;
    });
  }

  void option1Tex() {
    setState(() {
      option1 = option1Controller.text;
    });
  }

  void option2Tex() {
    setState(() {
      option2 = option2Controller.text;
    });
  }

  void option3Tex() {
    setState(() {
      option3 = option3Controller.text;
    });
  }

  deleteQuestion() {
    yearOneQuestionsRef.doc(widget.id).delete();
    displayToast("Question Deleted");
    Navigator.pop(context);
  }
}
