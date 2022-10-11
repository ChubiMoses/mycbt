import 'package:mycbt/src/models/post_model.dart';
import 'package:mycbt/src/models/offline_gist_model.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/utils/gist_db_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as tAgo;

GistDatabase databaseHelper = GistDatabase();

//Sync gist databases
Future<void> gistSync(int time) async {
  QuerySnapshot querySnapshot =
      await questionsRef.where("time", isGreaterThan: time).get();

  List<Post> gist = querySnapshot.docs
      .map((document) => Post.fromDocument(document))
      .toList();
  saveOffline(gist);
}

//fetch and save all gist in sqlflite
Future<void> saveGistsOffline() async {
  QuerySnapshot querySnapshot = await questionsRef.get();
  List<Post> gists = querySnapshot.docs
      .map((documentSnapshot) => Post.fromDocument(documentSnapshot))
      .toList();
  databaseHelper.truncate();
  saveOffline(gists);
}

Future<int> fetchFomSql() async {
  int count = 0;
  final Future<Database> dbFuture = databaseHelper.initializeDatabase();
  await dbFuture.then((database) async {
    Future<List<OfflineGistModel>> noteListFuture =
        databaseHelper.getGistList();
    await noteListFuture.then((gists) {
      return count = gists.length;
    });
  });
  return count;
}

Future<void> saveOffline(List<Post> gist) async {
  gist.forEach((e) async {
    int likes = likesCount(e.likes);
    if (e.visible == null) {
      questionsRef.doc(e.postId).set({
        "postId": e.postId,
        "ownerId": e.ownerId,
        "timestamp": e.timestamp,
        "likes": e.likes,
        'username': e.username,
        'description': e.description,
        'url': e.url,
        'visible': 0,
        'lastUpdated': DateTime.now().millisecondsSinceEpoch / 1000.floor(),
        'comments': e.comments,
        'time': DateTime.now().millisecondsSinceEpoch / 1000.floor(),
      });
    }

    OfflineGistModel data = OfflineGistModel(
        postId: e.postId,
        ownerId: e.ownerId,
        visible: e.visible == null ? 0 : e.visible,
        time: tAgo.format(e.timestamp!.toDate()),
        url: e.url,
        likes: likes,
        username: e.username,
        description: e.description,
        comments: e.comments);
    await databaseHelper.insert(data);
  });
}

int likesCount(dynamic likes) {
  if (likes == null) {
    return 0;
  }

  int counter = 0;
  likes.values.forEach((eachValue) {
    print(eachValue);
    if (eachValue == true) {
      counter = counter + 1;
    }
  });
  return counter;
}

Future<List<OfflineGistModel>> getGists() async {
  List<OfflineGistModel> gists = [];
  final Future<Database> dbFuture = databaseHelper.initializeDatabase();
  await dbFuture.then((database) async {
    Future<List<OfflineGistModel>> noteListFuture =
        databaseHelper.getGistList();
    await noteListFuture.then((gist) {
      gists = gist;
    });
  });
  return gists;
}

Future<List<OfflineGistModel>> getMyGist(String ownerId) async {
  List<OfflineGistModel> gists = [];
  final Future<Database> dbFuture = databaseHelper.initializeDatabase();
  await dbFuture.then((database) async {
    Future<List<OfflineGistModel>> noteListFuture =
        databaseHelper.getMyGistList(ownerId);
    await noteListFuture.then((gist) {
      gists = gist;
    });
  });
  return gists;
}

Future<OfflineGistModel?> getGistDetails(String id) async {
  OfflineGistModel gists;
  final Future<Database> dbFuture = databaseHelper.initializeDatabase();
  await dbFuture.then((database) async {
    Future<OfflineGistModel> noteListFuture = databaseHelper.getGistInfo(id);
    await noteListFuture.then((g) {
     return gists = g;
    });
  });
}
