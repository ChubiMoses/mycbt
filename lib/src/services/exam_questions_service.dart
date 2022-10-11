import 'dart:math';
import 'package:mycbt/src/models/questions.dart';

List<QuizModel> questions = [];
int count = 0;
final _random = new Random();

Future<int> questionAvailable(
    List<QuizModel> dbQuestions, String course) async {
  int count = 0;
  dbQuestions.forEach((element) {
    if (element.course == course) {
      count = count + 1;
    }
  });
  return count;
}

Future<List<QuizModel>> fetchQuizQuestion(List<QuizModel> dbQuestions,
    String schoolName, String year, String course) async {
  questions = [];

  dbQuestions.forEach((element) {
    //filter along with year if school Q&A is available in years else dont(FUTMINA)

    if (year != null) {
      if (element.school == schoolName &&
          element.year == year &&
          element.course == course) {
        questions.add(element);
      }
    } else {
      if (element.school == schoolName && element.course == course) {
        questions.add(element);
      }
    }
  });

  if (questions.length <= 5) {
    questions = await randomSelect(dbQuestions, schoolName, year, course);
    return questions;
  } else {
    if (schoolName == "Federal University of Technology Minna") {
      questions = List.generate(
          60, (_) => questions[_random.nextInt(questions.length)]);
    }

    return questions;
  }
}

Future<List<QuizModel>> randomSelect(List<QuizModel> dbQuestions,
    String schoolName, String year, String course) async {
  questions = [];

  dbQuestions.forEach((element) {
    if (element.school == schoolName && element.course == course) {
      questions.add(element);
    }
  });

  if (questions.length <= 15) {
    return [];
  } else {
    //questions = List.generate(35, (_) => questions..shuffle()).first;
    questions =
        List.generate(35, (_) => questions[_random.nextInt(questions.length)]);
    final ids = questions.map((e) => e.firebaseId).toSet();
    questions.retainWhere((x) => ids.remove(x.firebaseId));

    return questions;
  }
}

// void generateQuestions(List<Quiz> questions) {
//   questions =
//       List.generate(10, (_) => questions[_random.nextInt(questions.length)]);
//   questions.forEach((element) {
//     preExamsQuestions.doc().set({
//       "id": "",
//       "subject": "",
//       "category": "",
//       "code": "",
//       "course": "English",
//       "school": "",
//       "year": "",
//       "question": element.question,
//       "answer": element.answer,
//       "option1": element.option1,
//       "option2": element.option2,
//       "option3": element.option3,
//       "image": "",
//       "timestamp": timestamp,
//       'time': DateTime.now().millisecondsSinceEpoch / 1000.floor(),
//     });
//   });
// }


