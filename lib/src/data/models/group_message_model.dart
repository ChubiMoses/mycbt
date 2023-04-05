import 'package:cloud_firestore/cloud_firestore.dart';

class GroupMessageModel {
  final String id;
  final String docId;
  final String sender;
  final String receiver;
  final String message;
  final String file;
  final String username;
  final String fileType;
  final int visible;
  final String profileImage;
  final Timestamp timestamp;
  final dynamic seen;

  GroupMessageModel(
      {
      required this.id,
      required this.docId,
      required this.seen,
      required this.sender,
      required this.receiver,
      required this.file,
      required this.visible,
      required this.message,
      required this.fileType,
      required this.profileImage,
      required this.username,
      required this.timestamp});

  factory GroupMessageModel.fromDocument(DocumentSnapshot doc) {
    return GroupMessageModel(
      id: doc.id,
      sender: doc.get('sender') ?? "",
      docId: doc.get('docId') ?? "",
      seen: doc.get('seen') ?? "",
      visible: doc.get('visible') ?? "",
      receiver: doc.get('receiver') ?? "",
      profileImage: doc.get('profileImage') ?? "",
      username: doc.get('username') ?? "",
      message: doc.get('message') ?? "",
      file: doc.get('file') ?? "",
      fileType: doc.get('fileType') ?? "",
      timestamp: doc.get('timestamp') ?? "",
    );
  }
}
