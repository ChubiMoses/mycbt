import 'package:cloud_firestore/cloud_firestore.dart';

class OldDocModel {
  String id;
  String school;
  String title;
  String url;
  int type;



  OldDocModel({required this.id,  required this.type,required  this.school,required  this.title, required this.url});

  factory OldDocModel.fromDocument(DocumentSnapshot doc) {
    return OldDocModel(
      id: doc.id,
      school: doc.get('school') ?? "",
      title: doc.get('title') ?? "",
      type: doc.get('type') ?? "",
      url: doc.get('url') ?? "",
    );
  }

}
