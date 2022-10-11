import 'package:cloud_firestore/cloud_firestore.dart';

class Comment  {
  final String userName;
  final String userId;
  final String url;
  final String comment;
  final Timestamp timestamp;
  
  Comment({required this.userName, required this.userId, required this.url, required this.comment, required this.timestamp});
  
  factory Comment.fromDocument(DocumentSnapshot documentSnapshot){
    return Comment(
     userName: documentSnapshot["username"],
     userId: documentSnapshot["userId"],
     url: documentSnapshot["url"],
     comment: documentSnapshot["comment"],
     timestamp: documentSnapshot["timestamp"],

    );
  }
}