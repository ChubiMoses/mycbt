import 'package:flutter/material.dart';
import 'package:mycbt/src/models/question.dart';
import 'package:mycbt/src/screen/question/questions_tile.dart';
import 'package:mycbt/src/screen/question/questions_view.dart';
import 'package:mycbt/src/services/question_service.dart';
import 'package:mycbt/src/utils/colors.dart';

class QuestileTile extends StatefulWidget {
  const QuestileTile({Key? key}) : super(key: key);

  @override
  _QuestileTileState createState() => _QuestileTileState();
}

class _QuestileTileState extends State<QuestileTile> {
  List<Questions> questions = [];
  bool questionsLoading = true;

  @override
  void initState() {
    super.initState();
    // loadAds();
    fetchQuestions();
    super.initState();
  }

  void fetchQuestions() async {
    setState(() => questionsLoading = true);
    questions = await loadQuestions();
    setState(() {
      questions = questions;
      questionsLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return questions.isEmpty
        ? const SizedBox.shrink()
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(6, (i) {
                  if (i == 5) {
                    return InkWell(
                      onTap: (() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuestionsView('')));
                      }),
                      child: Container(
                        width: 300,
                        height: 230,
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[300]!,
                                spreadRadius: 1,
                                blurRadius: 5,
                              )
                            ],
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                            child: Text(
                          "36+ \n More",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              color: kWhite,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    );
                  }
                  return Container(
                      width: 300,
                      height: 230,
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300]!,
                            spreadRadius: 1,
                            blurRadius: 5,
                          )
                        ],
                        color: kWhite,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: QuestionTile(
                        dislikeIds: questions[i].dislikeIds,
                        likeIds: questions[i].likeIds,
                        title: questions[i].title,
                        id: questions[i].id,
                        question: questions[i].question,
                        image: questions[i].image,
                        answers: questions[i].answers,
                        view: "homescreen",
                        timestamp: questions[i].timestamp,
                        profileImage: questions[i].profileImage,
                        userId: questions[i].userId,
                        username: questions[i].username,
                      ));
                })
              ],
            ));
  }
}
