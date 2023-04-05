import 'package:cloud_firestore/cloud_firestore.dart';
class ChatModel{
  final String id;
  final String sender;
  final String receiver;
  final Timestamp timestamp;
  
  ChatModel({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.timestamp
  });

  factory ChatModel.fromDocument(DocumentSnapshot documentSnapshot){
       return ChatModel(
          id: documentSnapshot.id,
          sender: documentSnapshot['sender'],
          receiver : documentSnapshot['receiver'],
          timestamp : documentSnapshot['timestamp'],
       );
  }
 }
