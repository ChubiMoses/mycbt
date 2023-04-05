import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String name;
  final String image;
  final String ownerId;
  final String about;
  final int members;
  final String membersId;
  final double lastUpdated;
  final Timestamp timestamp;

  GroupModel({required this.id, required this.about, required this.ownerId, required this.members, required this.membersId, required this.image, required this.lastUpdated, required this.name, required this.timestamp});

  factory GroupModel.fromDocument(DocumentSnapshot documentSnapshot) {
    return GroupModel(
      id: documentSnapshot.id,
      ownerId: documentSnapshot.get('ownerId') ?? "",
      members: documentSnapshot.get('members') ?? "",
      membersId: documentSnapshot.get('membersId') ?? "",
      image: documentSnapshot.get('image') ?? "",
      about: documentSnapshot.get('about') ?? "",
      timestamp: documentSnapshot.get('timestamp') ?? "",
      name: documentSnapshot.get('name') ?? "",
      lastUpdated: documentSnapshot.get('lastUpdated') ?? "",
    );
  }
}
