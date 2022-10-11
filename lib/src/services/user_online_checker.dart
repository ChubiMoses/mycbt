import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';

bool userOnline(String userid, Timestamp? lastVisit) {
 if(lastVisit != null){
   DateTime? date = lastVisit.toDate();
   
   int difference = DateTime.now().difference(date).inMinutes;
    if (difference > 5) {
      return false;
    } else {
      return true;
    }
  }
   return false;
 }

 void updateLastSeen(){
   if(currentUser != null){
      usersReference.doc(currentUser?.id).update({"lastSeen": DateTime.now()});
   }
 }
 
