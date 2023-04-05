
import 'package:cloud_firestore/cloud_firestore.dart';

class  Settings{
   int? points;
   int? darkMode;
   int? hSwipe;
   int? notification;
   int? rate;


  Settings({
    this.points,
    this.darkMode,
    this.hSwipe,
    this.notification,
    this.rate
  });
  
factory Settings.fromDocument(DocumentSnapshot doc) {
    return Settings(
      points: doc['points'],
      darkMode: doc['darkMode'],
      hSwipe: doc['hSwipe'],
      notification: doc['notification'],
      rate: doc['rate']
    );
}
}









