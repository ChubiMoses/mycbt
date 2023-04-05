import 'package:cloud_firestore/cloud_firestore.dart';
class Answers{
  final String id;
  final String itemId;
  final String userId;
  final String username;
  final String profileImage;
  final Timestamp timestamp;
  final String likes;
  final String answer;
  final String url;

  Answers({
   required this.id,
   required this.userId,
   required this.timestamp,
   required this.likes,
   required this.url,
   required this.answer,
   required this.itemId,
   required this.username,
   required this.profileImage
  });

  factory Answers.fromDocument(DocumentSnapshot doc){
       return Answers(
          id: doc.get('id')??"",
          userId:  doc.get('userId')??"",
          likes :  doc.get('likes')??"",
          timestamp:  doc.get('timestamp')??"",
          url:  doc.get('url')??"", 
          answer:  doc.get('answer')??"",
          itemId:  doc.get('itemId')??"",
          username:  doc.get('username')??"",
          profileImage:  doc.get('profileImage')??"",   
       );
  }

    
 }
