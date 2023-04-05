import 'package:cloud_firestore/cloud_firestore.dart';

class GroupMemberModel {
  final String id;
  final String userId;

  GroupMemberModel({
    required this.id,
    required this.userId,
  });

  factory GroupMemberModel.fromDocument(DocumentSnapshot documentSnapshot) {
    return GroupMemberModel(
      id: documentSnapshot.id,
      userId: documentSnapshot.get('userId') ?? "",
    );
  }
}
