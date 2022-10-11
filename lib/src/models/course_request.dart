import 'package:cloud_firestore/cloud_firestore.dart';

class CourseRequestModel {
  int? id;
  String fID;
  String school;
  String course;

  CourseRequestModel({
    required this.fID,
    required this.school,
    required this.course,
  });

  CourseRequestModel.withId({
    required this.id,
    required this.fID,
    required this.school,
    required this.course,
  });

  factory CourseRequestModel.fromDocument(DocumentSnapshot doc) {
    return CourseRequestModel(
      fID: doc.id,
      school: doc.get('school') ?? "",
      course: doc.get('course') ?? "",
    );
  }
}
