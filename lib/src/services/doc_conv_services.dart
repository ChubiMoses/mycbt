import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycbt/src/data/models/group_message_model.dart';
import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/services/image_service.dart';
import 'package:mycbt/src/services/notify.dart';
import 'package:mycbt/src/services/user_online_checker.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/message/doc_message_tile.dart';

Future<void> sendMessage(List<DocConversationTile> mesageList, String code,
    String message, String docId, File? file, bool isPdf) async {
  String url = "";
  if (file != null) {
    //PDF FILE
    if (isPdf) {
      url = await uploadPDF(file);
    } else {
      //IMAGE FILE
      url = await compressingPhoto(file);
    }
  }

  docConversationRef.doc(docId).collection("Items").doc().set({
    'docId': docId,
    'sender': currentUser!.id,
    'receiver': docId,
    'message': message,
    'username': currentUser!.username,
    'profileImage': currentUser!.url,
    'file': url,
    'fileType': isPdf ? 'pdf' : 'image',
    'timestamp': DateTime.now(),
    'visible': 1,
    'lastAdded': DateTime.now().millisecondsSinceEpoch / 1000.floor(),
    'lastUpdated': DateTime.now().millisecondsSinceEpoch / 1000.floor(),
    'seen': {currentUser!.id: true}
  });

  final ids = mesageList.map((e) => e.sender).toSet();
  mesageList.retainWhere((x) => ids.remove(x.sender));
  for (var element in mesageList) {
    if (element.sender != currentUser!.id) {
      usersReference.doc(element.sender).get().then((value) {
        String token = UserModel.fromDocument(value).token;
        Timestamp? lastSeen = UserModel.fromDocument(value).lastSeen;
        bool isOnline = userOnline(element.sender, lastSeen);
        if (!isOnline) {
          notify(
              userId: element.sender,
              nid: docId,
              ownerId: element.sender,
              username: element.username,
              profileImage: element.profileImage,
              token: token,
              body: " also shared thought on $code study material",
              type: "Document Conversation");
        }
      });
    }
  }

  //increment number of conversations
  studyMaterialsRef.doc(docId).get().then((value) {
    int? conversation = DocModel.fromDocument(value).conversation;
    studyMaterialsRef.doc(docId).update({
      'conversation': conversation! + 1,
      'lastUpdated': DateTime.now().millisecondsSinceEpoch
    });
  });

  // //group updated with new message
  // groupsRef.doc(docId).update({'lastUpdated': DateTime.now().millisecondsSinceEpoch / 1000.floor()});

  // //my group updated with new message
  // myGroupsRef.doc(currentUser.id).collection("Items").doc(docId).update({
  //   'lastUpdated': DateTime.now().millisecondsSinceEpoch / 1000.floor(),
  // });
}

// void joinGroup(String membersId, String docId) {
//   String? ids = membersId + currentUser!.id + ",";
//   groupsRef.doc(docId).update({'membersId': ids});
//   myGroupsRef.doc(currentUser.id).collection("Items").doc(docId).set({
//     'docId': docId,
//     'lastUpdated': DateTime.now().millisecondsSinceEpoch / 1000.floor(),
//   });
// }

// void leaveGroup(String membersId, String docId) {
//   List<String> userIds = membersId.split(',');
//    userIds.remove(currentUser!.id);
//    String ids = userIds.join(",");
//   groupsRef.doc(docId).update({'membersId': ids});
//}
