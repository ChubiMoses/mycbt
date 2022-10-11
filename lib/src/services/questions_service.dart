import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/models/quiz.dart';
import 'package:mycbt/src/models/questions.dart';
import 'package:mycbt/src/utils/quiz_db_helper.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

QuizDbHelper databaseHelper = QuizDbHelper();

Future<void> questionUpdate(String course, String school) async {
  QuerySnapshot querySnapshot = await yearOneQuestionsRef
      .where("course", isEqualTo: course)
      .where("school", isEqualTo: school)
      .get();
  List<Quiz> quiz = querySnapshot.docs
      .map((documentSnapshot) => Quiz.fromDocument(documentSnapshot))
      .toList();
  print(quiz.length);
  saveOffline(quiz);
}

Future<void> quizSync(int time) async {
  QuerySnapshot querySnapshot =
      await yearOneQuestionsRef.where("time", isGreaterThan: time).get();
  List<Quiz> quiz = querySnapshot.docs
      .map((documentSnapshot) => Quiz.fromDocument(documentSnapshot))
      .toList();
  saveOffline(quiz);
}

Future<void> updateQuiz() async {
  QuerySnapshot querySnapshot = await yearOneQuestionsRef
      .where("school", isNotEqualTo: "Benue State University")
      .get();
  List<Quiz> quiz = querySnapshot.docs
      .map((documentSnapshot) => Quiz.fromDocument(documentSnapshot))
      .toList();
  databaseHelper.truncateQuiz();
  saveOffline(quiz);
}

Future<void> clearQuizDatabase() async {
  await databaseHelper.truncateQuiz();
 

}

Future<int> fetchOffline() async {
  int count = 0;
  final Future<Database> dbFuture = databaseHelper.initializeDatabase();
  await dbFuture.then((database) async {
    Future<List<QuizModel>> noteListFuture = databaseHelper.getNoteList();
    await noteListFuture.then((quiz) {
      return count = quiz.length;
    });
  });
  return count;
}

Future<void> saveOffline(List<Quiz> questions) async {
  questions.forEach((e) async {
    print(e.answer);
    QuizModel data = QuizModel(
        firebaseId: e.id,
        subject: e.subject,
        code: e.code,
        category: e.category,
        course: e.course,
        school: e.school,
        year: e.year,
        question: e.question,
        answer: e.answer,
        option1: e.option1,
        option2: e.option2,
        option3: e.option3,
        image: e.image);
    await databaseHelper.insertQuiz(data);
  });
}

Future<List<QuizModel>> fetchAllQuestions() async {
  List<QuizModel> questions = [];
  final Future<Database> dbFuture = databaseHelper.initializeDatabase();
  await dbFuture.then((database) async {
    Future<List<QuizModel>> noteListFuture = databaseHelper.getNoteList();
    await noteListFuture.then((quiz) {
      questions = quiz;
    });
  });
  return questions;
}

// void correctQuestions() async {
//   QuerySnapshot querySnapshot = await yearOneQuestionsRef
//       .where("course", isEqualTo: "GST311 - ENTREPRENEURSHIP I")
//       .get();
//   List<Quiz> quiz = querySnapshot.docs
//       .map((documentSnapshot) => Quiz.fromDocument(documentSnapshot))
//       .toList();
//   quiz.forEach((element) {
//     print(element.question);
//     yearOneQuestionsRef.doc(element.id).update({
//       "course": "GST110 - USE OF ENGLISH & LIBRARY",
//     });
//   });
// //GST311 - GENERAL ENTREPRENEURSHIP
//   displayToast("Done");
// }
