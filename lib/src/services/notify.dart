import 'package:mycbt/src/utils/firebase_collections.dart';

void notify(
    {required String ownerId,
   required String nid,
   required String type,
   required String body,
   required String userId,
   required String token,
   required String username,
   required String profileImage, 
   }) {
     
         notificationReference.doc(ownerId).collection("list").add({
          "ownerId": ownerId,
          "type": type,
          "username": username,
          "profileImage": profileImage,
          "body": body,
          "nid": nid,
          "token":token,
          "userId": userId,
          "timestamp": DateTime.now(),
          "seen": 0
        });
 
}

