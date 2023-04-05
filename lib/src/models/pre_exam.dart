import 'package:cloud_firestore/cloud_firestore.dart';

class PreExamScore{
  final String? username;
  final int? score;
  final String? regNumber;
  final String? time;

  PreExamScore({
    this.username,
    this.regNumber,
    this.time,
    this.score,
  });

  factory PreExamScore.fromDocument(DocumentSnapshot doc) {
    return PreExamScore(
      username: doc.get('username') ?? "",
      regNumber: doc.get('regNumber') ?? "",
      time: doc.get('time') ?? "",
      score: doc.get('score') ?? "",
      );
   }
}
