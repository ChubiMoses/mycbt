import 'package:cloud_firestore/cloud_firestore.dart';

class ConvModel {
  final String postId;
  final String itemId;
  final String ownerId;
  final Timestamp timestamp;
  final dynamic likes;
  final String username;
  final String description;
  final String url;
  final int comments;
  final String profileImage;

  ConvModel(
      {required this.postId,
      required this.itemId,
      required this.ownerId,
      required this.timestamp,
      required this.likes,
      required this.username,
      required this.description,
      required this.url,
      required this.comments,
      required this.profileImage});

  factory ConvModel.fromDocument(DocumentSnapshot documentSnapshot) {
    return ConvModel(
      itemId: documentSnapshot.id,
      postId: documentSnapshot['postId'],
      ownerId: documentSnapshot['ownerId'],
      likes: documentSnapshot['likes'],
      username: documentSnapshot['username'],
      timestamp: documentSnapshot['timestamp'],
      description: documentSnapshot['description'],
      url: documentSnapshot['url'],
      comments: documentSnapshot['comments'],
      profileImage: documentSnapshot['profileImage'],
    );
  }
}
