import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycbt/src/data/models/chat_model.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/services/image_service.dart';
import 'package:mycbt/src/services/user_online_checker.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:uuid/uuid.dart';
import 'notify.dart';

//create chat id for new chats
Future<String> createChat(
    {required String userId, required String chatId}) async {
  List<ChatModel> chats = [];
  QuerySnapshot querySnapshot = await chatsRef
      .where('sender', isEqualTo: currentUser!.id)
      .where('receiver', isEqualTo: userId)
      .get();
  QuerySnapshot snapshot = await chatsRef
      .where('receiver', isEqualTo: currentUser!.id)
      .where('sender', isEqualTo: userId)
      .get();
  if (querySnapshot.docs.isEmpty && snapshot.docs.isEmpty) {
    chatId = const Uuid().v4();
    chatsRef.doc(chatId).set({
      "sender": currentUser!.id,
      "receiver": userId,
      "timestamp": DateTime.now()
    });
  } else if (querySnapshot.docs.isNotEmpty) {
    chats = querySnapshot.docs
        .map((document) => ChatModel.fromDocument(document))
        .toList();
    chatId = chats[0].id;
  } else if (snapshot.docs.isNotEmpty) {
    chats = snapshot.docs
        .map((document) => ChatModel.fromDocument(document))
        .toList();
    chatId = chats[0].id;
  } else {
    chatId = chatId;
  }
  return chatId;
}

Future<int> unSeenMessageCount(UserModel? currentUser) async {
  int count = 0;
  if (currentUser != null) {
    await messageRef
        .where('receiver', isEqualTo: currentUser.id)
        .where('seen', isEqualTo: 0)
        .get()
        .then((value) {
      return count = value.docs.length;
    });
  }
  return count;
}

Future<void> messageSaver(
    {String? message,
    String? chatId,
    String? receiverId,
    File? file,
    required bool isPdf}) async {
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

  messageRef.doc().set({
    'chatId': chatId,
    'sender': currentUser!.id,
    'receiver': receiverId,
    'message': message,
    'timestamp': DateTime.now(),
    'seen': 0,
    'file': url,
    'fileType': file == null
        ? ""
        : isPdf
            ? 'pdf'
            : 'image',
    'visible': 1,
    'username': currentUser?.username,
    'profilePicture': currentUser?.url,
    'lastAdded': DateTime.now().millisecondsSinceEpoch,
    'lastUpdated': DateTime.now().millisecondsSinceEpoch,
  });

  usersReference.doc(receiverId).get().then((value) {
    String? token = UserModel.fromDocument(value).token;
    Timestamp? lastSeen = UserModel.fromDocument(value).lastSeen;
    bool isOnline = userOnline(receiverId!, lastSeen);
    if(!isOnline){
      notify(
        userId: currentUser!.id,
        nid: chatId!,
        ownerId: receiverId,
        username: currentUser!.username,
        profileImage: currentUser!.url,
        token: token,
        body: "sent you a message",
        type: "Message");
    }
    
  });
}
