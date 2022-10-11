import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String username;
  String url;
  int rate;
  int blocked;
  String email;
  Timestamp? timestamp;
  String phone;
  String gender;
  String school;
  String course;
  String code;
  String token;
  String hideUsers;
  Timestamp visited;
  Timestamp lastSeen;
  int points;
  int subscribed;
  String device;
  int badges;
  UserModel(
      {required this.id,
      required this.username,
      required this.url,
      required this.email,
      required this.blocked,
      required this.rate,
      required this.hideUsers,
      required this.timestamp,
      required this.phone,
      required this.gender,
      required this.school,
      required this.course,
      required this.code,
      required this.token,
      required this.points,
      required this.subscribed,
      required this.device,
      required this.lastSeen,
      required this.badges,
      required this.visited});

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      email: doc.data().toString().contains('email') ? doc.get('email') : "",
      blocked:doc.data().toString().contains('blocked') ?  doc.get('blocked') : 0,
      timestamp:doc.data().toString().contains('timestamp') ?  doc.get('timestamp') : "",
      hideUsers:doc.data().toString().contains('hideUsers') ?  doc.get('hideUsers') : null,
      username:doc.data().toString().contains('username') ?  doc.get('username') : "",
      url:doc.data().toString().contains('url') ?  doc.get('url') : "",
      rate:doc.data().toString().contains('rate') ?  doc.get('rate') : 0,
      phone:doc.data().toString().contains('phone') ?  doc.get('phone') : "",
      gender:doc.data().toString().contains('gender') ?  doc.get('gender') : "",
      school:doc.data().toString().contains('school') ?  doc.get('school') : "",
      course:doc.data().toString().contains('course') ?  doc.get('course') : "",
      code:doc.data().toString().contains('code') ?  doc.get('code') : "",
      token:doc.data().toString().contains('token') ?  doc.get('token') : "",
      points:doc.data().toString().contains('points') ?  doc.get('points') : 0,
      visited:doc.data().toString().contains('visited') ?  doc.get('visited') : null,
      lastSeen:doc.data().toString().contains('lastSeen') ?  doc.get('lastSeen') : null,
      badges: doc.data().toString().contains('badges') ? doc.get('badges') : 0,
      subscribed:doc.data().toString().contains('subscribed') ? doc.get('subscribed'):0,
      device: doc.data().toString().contains('device') ? doc.get('device') : "",
    );
  }
}
