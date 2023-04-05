import 'package:cloud_firestore/cloud_firestore.dart';

class SubList {
  final  String id;
  final String url;
  final String device;
  final String ownerId;
  final String phone;
  final String account;
  final String name;
  final String school;
  final String date;
  final bool approved;
  SubList(
      {
      required this.id,
      required this.url,
     required  this.device,
      required this.ownerId,
     required  this.phone,
     required  this.account,
     required  this.name,
     required  this.school,
     required this.approved,
     required  this.date});

  factory SubList.fromDocument(DocumentSnapshot doc) {
    return SubList(
      id: doc.get('id') ?? "",
      url: doc.get('url') ?? "",
      device: doc.get('device') ?? "",
      ownerId: doc.get('ownerId') ?? "",
      phone: doc.get('phone') ?? "",
      account: doc.get('account') ?? "",
      approved: doc.get('approved') ?? "",
      name: doc.get('name') ?? "",
      school: doc.get('school') ?? "",
      date: doc.get('date') ?? "",
    );
  }
}

class Subs {
  final String ownerId;
  final String device;

  Subs({
   required  this.device,
   required this.ownerId,
  });

  factory Subs.fromDocument(DocumentSnapshot doc) {
    return Subs(
      device: doc.get('device') ?? "",
      ownerId: doc.get('ownerId') ?? "",
    );
  }
}
