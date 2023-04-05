import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/conversation/conversation_tile.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';

class AdminConversationView extends StatefulWidget {
  const AdminConversationView({Key? key}) : super(key: key);

  @override
  _AdminConversationViewState createState() => _AdminConversationViewState();
}

class _AdminConversationViewState extends State<AdminConversationView> {
 
  loadChats() {
    return StreamBuilder<QuerySnapshot>(
      stream:conversationRef.orderBy('timestamp', descending: true).snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return loader();
        }
       
        List<ConversationTile> messages = [];
        for (var doc in dataSnapshot.data!.docs) {
          messages.add(ConversationTile.fromDocument(doc));
        }

        return SingleChildScrollView(child: Column(children: messages));
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:header(context, strTitle: "Conversation", disapearBackButton: true),
        body:loadChats()
    );
  }
}
