import 'package:cloud_firestore/cloud_firestore.dart';

class MyGroupModel {
  final String id;
  final String groupId;
  final double lastUpdated;

  MyGroupModel(
      {required this.id,
      required this.groupId,
      required this.lastUpdated
     });

  factory MyGroupModel.fromDocument(DocumentSnapshot documentSnapshot) {
    return MyGroupModel(
      id: documentSnapshot.id,
      groupId: documentSnapshot.get('groupId') ?? "",
      lastUpdated: documentSnapshot.get('lastUpdated') ?? "",
    );
  }
}
