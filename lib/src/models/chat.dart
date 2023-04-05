import 'package:cloud_firestore/cloud_firestore.dart';



class ChatModel{
  final String id;
  final String sender;
  final String reciever;
  final Timestamp timestamp;
  
  ChatModel({
    required this.id,
    required this.sender,
    required this.reciever,
    required this.timestamp
  });

  factory ChatModel.fromDocument(DocumentSnapshot documentSnapshot){
       return ChatModel(
          id: documentSnapshot.id,
          sender: documentSnapshot['sender'],
          reciever : documentSnapshot['reciever'],
          timestamp : documentSnapshot['timestamp'],
       );
  }
 }
