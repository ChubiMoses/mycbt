import 'package:katex_flutter/katex_flutter.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/models/quiz.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mycbt/src/screen/admin/edit_questions.dart';
import 'package:mycbt/src/screen/conversation/conversation_modal.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:mycbt/src/widgets/editor_options_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/widgets/empty_state_widget.dart';

class QuestionView extends StatefulWidget {
  final String questionId;
  QuestionView({
    required this.questionId,
  });

  @override
  _StudyModeState createState() => _StudyModeState();
}

class _StudyModeState extends State<QuestionView> {
  int codeIndex = 0;
  var quiz = null;
  bool isLoading = true;
  int count = 0;

  @override
  void initState() {
    super.initState();
    getQuestionDetails();
  }

  void getQuestionDetails() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc =
        await yearOneQuestionsRef.doc(widget.questionId).get();
    quiz = Quiz.fromDocument(doc);
    setState(() {
      quiz = quiz;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: header(
          context,
          strTitle: isLoading ? "Overview" : quiz.year + "|" + quiz.course,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: Container(
                    child: isLoading
                        ? loader()
                        : quiz == null
                            ? EmptyStateWidget(
                                "No Question found", Icons.search)
                            : GestureDetector(
                                onDoubleTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditQuestions(
                                                question: quiz.question,
                                                answers: quiz.answer,
                                                view: "Exam",
                                                option1: quiz.option1,
                                                option2: quiz.option2,
                                                option3: quiz.option3,
                                                id: quiz.id,
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("1",
                                              style: TextStyle(
                                                  color: Colors.lightGreen)),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                KaTeX(
                                                  laTeXCode: Text(
                                                    quiz.question,
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                quiz.image == null
                                                    ? SizedBox.shrink()
                                                    : quiz.image == ""
                                                        ? SizedBox.shrink()
                                                        : Container(
                                                            width:
                                                                double.infinity,
                                                            height: 200.0,
                                                            child: Image(
                                                              image:
                                                                  CachedNetworkImageProvider(
                                                                      quiz.image),
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                            ),
                                                          ),
                                                SizedBox(height: 5),
                                                EditorOptions(
                                                    answer: quiz.answer,
                                                    option1: quiz.option1,
                                                    option2: quiz.option2,
                                                    option3: quiz.option3,
                                                    question: quiz.question,
                                                    id: quiz.id),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () =>
                                                     Navigator.push(context, MaterialPageRoute(
                                                    builder: (context) =>
                                                        ModalInsideModal(
                                                      questionId: quiz.id,
                                                      question: quiz.question,
                                                      answer: quiz.answer,
                                                      course: '',
                                                      view: '',
                                                      year: '',
                                                    ),
                                                     )
                                                  ),
                                                  child: Container(
                                                    width: 150,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 2.0,
                                                          color: kGrey200),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                40.0),
                                                        topRight:
                                                            Radius.circular(
                                                                40.0),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Icon(
                                                            CupertinoIcons
                                                                .chat_bubble_2,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                          Text("Conversation",
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )))
          ],
        ),
        floatingActionButton: MaterialButton(
            child: Icon(
              Icons.refresh,
              color: Colors.lightGreen,
            ),
            color: Colors.white,
            splashColor: Colors.lightGreen,
            minWidth: 45.0,
            height: 50.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0)),
            onPressed: () => getQuestionDetails()));
  }
}
