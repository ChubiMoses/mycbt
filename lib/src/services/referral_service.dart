import 'package:mycbt/src/models/referral.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Referral?> getReferralInfo() async {
  if(currentUser != null){
    DocumentSnapshot documentSnapshot =  await agentsRef.doc(currentUser!.id).get();
    if (documentSnapshot.exists) {
      Referral referrer = Referral.fromDocument(documentSnapshot);
      return referrer;
    }
  }
}
