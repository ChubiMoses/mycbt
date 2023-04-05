import 'package:cloud_firestore/cloud_firestore.dart';



class Suggest{
  final String? id;
  final String? answer;
  final dynamic users;
  final String? qid;

  
  Suggest({
    this.id,
    this.answer,
    this.users,
    this.qid,
  });

  factory Suggest.fromDocument(DocumentSnapshot documentSnapshot){
       return Suggest(
          id: documentSnapshot.id,
          answer: documentSnapshot['answer'],
          users : documentSnapshot['users'],
          qid: documentSnapshot['qid'], 
       );
  }

    
 }
