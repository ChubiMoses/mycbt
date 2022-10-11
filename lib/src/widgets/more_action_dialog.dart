import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/question/report.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/displayToast.dart';

moreAction(mContext,
    {required String ownerId,
    required VoidCallback showDeleted,
    required String postId,
    required String view}) {
  return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            ownerId == currentUser?.id
                ? SizedBox.shrink()
                : SimpleDialogOption(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.flag, color: kGrey500),
                            SizedBox(width: 10.0),
                            Text("Report",
                                style: Theme.of(context).textTheme.bodyText1),
                          ],
                        ),
                      ],
                    ),
                    onPressed: () => reportPost(
                      context,
                      postId: postId,
                      view: view,
                      ownerId: ownerId,
                    ),
                  ),
            currentUser?.username == "Admin"
                ? SimpleDialogOption(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.delete, color: kGrey500),
                            SizedBox(width: 10.0),
                            Text("Delete",
                                style: Theme.of(context).textTheme.bodyText1),
                          ],
                        ),
                      ],
                    ),
                    onPressed: () => deletePost(context, postId, view),
                  )
                : SizedBox.shrink(),
            ownerId == currentUser?.id
                ? SimpleDialogOption(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.delete, color: kGrey500),
                            SizedBox(width: 10.0),
                            Text("Delete",
                                style: Theme.of(context).textTheme.bodyText1),
                          ],
                        ),
                      ],
                    ),
                    onPressed: () {
                      //hide item from conversation tile on deleted
                      showDeleted();
                      deletePost(context, postId, view);
                    },
                  )
                : SizedBox.shrink(),
          ],
        );
      });
}

void reportPost(
  context, {
  postId,
  view,
  ownerId,
}) {
  Navigator.pop(context);
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ReportScreen(postId: postId, view: view, ownerId: ownerId)));
}

void deletePost(context, String postId, view) {
  Navigator.pop(context);
  if (view == "Conversation") {
    conversationRef.doc(postId).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
        storageReference.child("Post_$postId.jpg").delete();
      }
      displayToast("Deleting conversation...");
    });
  } else {
    void deletePost(context, String postId) {
      Navigator.pop(context);
      questionsRef.doc(postId).get().then((doc) {
        if (doc.exists) {
          doc.reference.delete();
          storageReference.child("Post_$postId.jpg").delete();
        }
        displayToast("Deleting post...");
      });
    }
  }
}

  // void blockUser(context, ownerId) {
  //   Navigator.pop(context);
  //   usersReference.doc(ownerId).update({"blocked": 1}).then((doc) {
  //     displayToast("Account suspended!");
  //   });
  