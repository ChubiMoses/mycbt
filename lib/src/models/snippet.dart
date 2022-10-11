import 'package:cloud_firestore/cloud_firestore.dart';

class Snippet {
  final String amount;
  final bool free;
  final String paystack;
  final String phone;
  final String video;
  final String whatsapp;
  final String pass;
  final int duration;
  final bool preexam;
  final int verifyPDF;

  Snippet(
      {
      required this.amount,
      required this.duration,
      required this.pass,
      required this.free,
      required this.video,
       required this.phone,
      required this.paystack,
       required this.verifyPDF,
      required this.whatsapp,
      required this.preexam,});

  factory Snippet.fromDocument(DocumentSnapshot doc) {
    return Snippet(
      video: doc.get('video') ?? "",
      amount: doc.get('amount') ?? "",
      free: doc.get('free') ??false,
      whatsapp: doc.get('whatsapp') ?? "",
      phone: doc.get('phone') ?? "",
      paystack: doc.get('paystack') ?? "",
      verifyPDF: doc.get('verifyPDF') ?? "",
      pass: doc.get('password') ?? "",
      duration: doc.get('duration') ?? 0,
      preexam: doc.get('preexam') ?? "",
    );
  }
}
