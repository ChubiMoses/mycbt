import 'package:mycbt/src/models/question.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<List<Questions>> loadQuestions() async {
  QuerySnapshot querySnapshot = await questionsRef.orderBy("timestamp", descending: true).get();
  List<Questions> questions = querySnapshot.docs.map((document) => Questions.fromDocument(document)).toList();
  return questions;
}

