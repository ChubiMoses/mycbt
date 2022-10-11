import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesModel {
  final String id;
  final String chatId;
  final String sender;
  final String reciever;
  final String message;
  final String image;
  final Timestamp timestamp;
  final bool seen;


  MessagesModel({required this.id,required this.chatId,required this.seen,required this.sender,required this.reciever,required this.image,required this.message, required this.timestamp});

  factory MessagesModel.fromDocument(DocumentSnapshot doc) {
    return MessagesModel(
      id: doc.id,
      sender: doc.get('sender') ?? "",
      chatId: doc.get('chatId') ?? "",
      seen: doc.get('seen') ?? "",
      reciever: doc.get('reciever') ?? "",
      message: doc.get('message') ?? "",
      image: doc.get('image') ?? "",
      timestamp: doc.get('timestamp') ?? "",
    );
  }
}


