
import 'package:cloud_firestore/cloud_firestore.dart';
class PDFModel{
  final String? id;
  final String? school;
  final String? ownerId;
  final String? title;
  final int? bytes;
  final String? likes;
  final String? url;
  final String? code;
  final String? category;
  PDFModel({
    this.id,
    this.school,
    this.ownerId,
    this.title,
    this.bytes,
    this.likes,
    this.url,
    this.code,
    this.category, String? firebaseId
  });

  factory PDFModel.fromDocument(DocumentSnapshot doc) {
    return PDFModel(
      id: doc.id,
      school: doc['school'],
      ownerId: doc['ownerId'],
      title: doc['title'],
      bytes: doc['bytes'],
      likes: doc['likes'],
      url: doc['url'],
      category: doc['category'],
      code: doc['code'],
    );
  }
}

