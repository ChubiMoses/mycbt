import 'package:cloud_firestore/cloud_firestore.dart';

class Questions {
  final String id;
  final String userId;
  final String title;
  final String username;
  final String profileImage;
  final Timestamp timestamp;
  final String likeIds;
  final int answers;
  final String question;
  final String image;
  final String category;
  final String dislikeIds;
  final int visible;

  Questions(
      {required this.id,
      required this.userId,
       required this.dislikeIds,
      required this.title,
      required this.username,
      required this.profileImage,
      required this.timestamp,
      required this.likeIds,
      required this.question,
      required this.image,
      required this.answers,
      required this.visible,
      required this.category});

  factory Questions.fromDocument(DocumentSnapshot doc) {
    return Questions(
      id: doc.get('id') ?? "",
      userId: doc.get('userId') ?? "",
      dislikeIds: doc.get('dislikeIds') ?? "",
      title: doc.get('title') ?? "",
      profileImage: doc.get('profileImage') ?? "",
      username: doc.get('username') ?? "",
      likeIds: doc.get('likeIds') ?? "",
      timestamp: doc.get('timestamp') ?? "",
      image: doc.get('image') ?? "",
      question: doc.get('question') ?? "",
      answers: doc.get('answers') ?? "",
      visible: doc.get('visible') ?? "",
      category: doc.get('category') ?? "",
    );
  }
}
