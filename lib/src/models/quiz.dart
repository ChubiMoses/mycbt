
import 'package:cloud_firestore/cloud_firestore.dart';

class Quiz {
  final String id;
  final String subject;
  final String category;
  final String code;
  final String school;
  final String course;
  final String year;
  final String question;
  final String answer;
  final String option1;
  final String option2;
  final String option3;
  final String image;
  final Timestamp? timestamp;

  Quiz({
   required this.id,
   required this.subject,
   required this.code,
   required this.category,
   required this.school,
   required this.course,
   required this.year,
   required this.question,
   required this.answer,
   required this.option1,
   required this.option2,
   required  this.option3,
   required  this.image,
   required this.timestamp
  });

  factory Quiz.fromDocument(DocumentSnapshot doc) {
    return Quiz(
      id:doc.id,
      subject: doc.get('subject') ?? "",
      category: doc.get('category') ?? "",
      school: doc.get('school') ?? "",
      code: doc.get('code') ?? "",
      course: doc.get('course') ?? "",
      year: doc.get('year') ?? "",
      question: doc.get('question') ?? "",
      answer: doc.get('answer') ?? "",
      option1: doc.get('option1') ?? "",
      option2: doc.get('option2') ?? "",
      option3: doc.get('option3') ?? "",
      image: doc.get('image') ?? "",
      timestamp: doc.get('timestamp') ?? "",
    );
  }
  
}
