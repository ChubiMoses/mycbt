import 'package:mycbt/src/models/answers.dart';
import 'package:mycbt/src/models/question.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/screen/conversation/comments.dart';
import 'package:mycbt/src/screen/conversation/conversation_tile.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/profile/select_school.dart';
import 'package:mycbt/src/screen/notification.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:mycbt/src/widgets/message/doc_message_tile.dart';
import 'package:mycbt/src/widgets/message/message_tile.dart';

Future<UserModel?> getUser(BuildContext context) async {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? user = _firebaseAuth.currentUser;
  String userID = user?.uid ?? "";
  DocumentSnapshot document = await usersReference.doc(userID).get();
  if (!document.exists) {
    user?.delete();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => LoginRegisterPage()),
        (Route<dynamic> route) => false);
  } else {
    currentUser = UserModel.fromDocument(document);
    if (currentUser?.school == "") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SelectSchool(
                userId: userID,
              )));
    }
    if (currentUser!.blocked == 1) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => LoginRegisterPage()),
          (Route<dynamic> route) => false);
      displayToast("Account blocked");
    } else if (currentUser?.hideUsers == null) {
      resetUserData(context, currentUser);
    } else {
      return currentUser;
    }
  }
  return currentUser;
}

void resetUserData(BuildContext context, UserModel? user) {
  usersReference.doc(user?.id).set({
    'id': user?.id,
    'username': user?.username,
    'url': user?.url,
    'email': user?.email,
    'rate': user?.rate,
    'blocked': user?.blocked,
    'timestamp': user?.timestamp,
    'phone': user?.phone,
    'gender': user?.gender,
    'school': user?.school,
    'course': user?.course,
    'token': user?.token,
    'points': 100,
    'hideUsers':"",
    'visited': DateTime.now(),
    'lastSeen': DateTime.now(),
    'code': user?.code ?? "",
    'subscribed': 0,
    'device': "",
    'badges': 0
  });

  getUser(context);
}

Future<List<UserModel>> getUsers() async {
  List<UserModel> users = [];
  await usersReference
      .orderBy('timestamp', descending: true)
      .get()
      .then((value) {
    users = value.docs.map((document) => UserModel.fromDocument(document)).toList();
    return users;
  });
  return users;
}

Future<UserModel?> userDetails(String userId) async {
  DocumentSnapshot document = await usersReference.doc(userId).get();
  currentUser = UserModel.fromDocument(document);
  return currentUser;
}

void updateCollections(String userId, String username, String profileImage, bool isImage) {
  //update questions collection
  questionsRef.where("userId", isEqualTo: userId).get().then((value) {
    List<Questions> questions =
        value.docs.map((e) => Questions.fromDocument(e)).toList();

        if(isImage){
           for (var item in questions) {
            questionsRef.doc(item.id).update({
              'profileImage':profileImage
            });
          }
        }else{
         for (var item in questions) {
          questionsRef.doc(item.id).update({
          'username':username,
          });
        }
        }
   
  });

//update answers collection
   answersRef.where("userId", isEqualTo: userId).get().then((value) {
    List<Answers> answers =
        value.docs.map((e) => Answers.fromDocument(e)).toList();

        if(isImage){
           for (var item in answers) {
            questionsRef.doc(item.id).update({
              'profileImage':profileImage
            });
          }
        }else{
         for (var item in answers) {
          questionsRef.doc(item.id).update({
           'username':username,
          });
        }
        }
   
  });

//update notification collection
   notificationReference
        .where("userId", isEqualTo:userId)
        .get().then((value) {
    List<NotificationsItem> noti =
        value.docs.map((e) => NotificationsItem.fromDocument(e)).toList();
        if(isImage){
           for (var item in noti) {
            notificationReference.doc(item.ownerId).collection("list").doc(item.id).update({
              'profileImage':profileImage
            });
          }
        }else{
         for (var item in noti) {
            notificationReference.doc(item.ownerId).collection("list").doc(item.id).update({
           'username':username,
          });
        }
        }
  });

  
//update messages collection
   messageRef.where("sender", isEqualTo: userId).get().then((value) {
    List<MessageTile> messages =
        value.docs.map((e) => MessageTile.fromDocument(e)).toList();

        if(isImage){
           for (var item in messages) {
            messageRef.doc(item.id).update({
              'profileImage':profileImage
            });
          }
        }else{
         for (var item in messages) {
          messageRef.doc(item.id).update({
           'username':username,
          });
        }
        }
   
  });

 
//update document conversation collection
   docConversationRef.where("sender", isEqualTo: userId).get().then((value) {
    List<DocConversationTile> messages =
        value.docs.map((e) => DocConversationTile.fromDocument(e)).toList();
        if(isImage){
           for (var item in messages) {
            docConversationRef.doc(item.docId).collection("Items").doc(item.id).update({
              'profileImage':profileImage
            });
          }
        }else{
         for (var item in messages) {
           docConversationRef.doc(item.docId).collection("Items").doc(item.id).update({
            'username':username,
          });
        }
        }
   
  });

  
//update questions conversation collection
   conversationRef.where("ownerId", isEqualTo: userId).get().then((value) {
    List<ConversationTile> messages =
        value.docs.map((e) => ConversationTile.fromDocument(e)).toList();

        if(isImage){
           for (var item in messages) {
            conversationRef.doc(item.itemId).update({
              'profileImage':profileImage
            });
          }
        }else{
         for (var item in messages) {
            conversationRef.doc(item.itemId).update({
            'username':username,
          });
        }
        }
   
  });

   
//update questions conversation collection
   convCommentsRef.where("userId", isEqualTo: userId).get().then((value) {
    List<CommentTile> messages =
        value.docs.map((e) => CommentTile.fromDocument(e)).toList();

        if(isImage){
           for (var item in messages) {
             convCommentsRef.doc(item.itemId).collection("Items").doc(item.id).update({
              'profileImage':profileImage
            });
          }
        }else{
         for (var item in messages) {
            convCommentsRef.doc(item.itemId).collection("Items").doc(item.id).update({
            'username':username,
          });
        }
        }
   
  });
}
