import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String chatId;
  final String sender;
  final String receiver;
  final String message;
  final String username;
  final String profilePicture;
  final String file;
  final Timestamp timestamp;
  final bool seen;
  final int visible;
  final String fileType;
  final int lastAdded;

  MessageModel(
      {required this.id,
      required this.chatId,
      required this.lastAdded,
      required this.seen,
      required this.username,
      required this.profilePicture,
      required this.sender,
      required this.visible,
      required this.receiver,
      required this.file,
      required this.fileType,
      required this.message,
      required this.timestamp});

  factory MessageModel.fromDocument(DocumentSnapshot doc) {
    return MessageModel(
      id: doc.id,
      sender: doc.get('sender') ?? "",
      chatId: doc.get('chatId') ?? "",
      seen: doc.get('seen') ?? false,
      lastAdded: doc.get('lastAdded') ?? "",
      receiver: doc.get('receiver') ?? "",
      message: doc.get('message') ?? "",
      username: doc.get('username') ?? "",
      profilePicture: doc.get('profilePicture') ?? "",
      timestamp: doc.get('timestamp') ?? "",
      visible: doc.get('visible') ?? "",
      file: doc.get('file') ?? "",
      fileType: doc.get('fileType') ?? "",
    );
  }
}
