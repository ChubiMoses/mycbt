import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/models/docs.dart';
import 'package:mycbt/src/models/user.dart';
import 'package:mycbt/src/screen/documents/download_courses.dart';
import 'package:mycbt/src/services/file_service.dart';
import 'package:mycbt/src/services/hide_content.dart';
import 'package:mycbt/src/services/users_service.dart';
import 'package:mycbt/src/utils/docs_db.dart';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/utils/courses_db_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

CoursesDbHelper databaseHelper = CoursesDbHelper();

//Check if new course has been added to db
Future<void> updateCouses() async {
  String timestamp;
  timestamp = await readTimestamp();
  int time = int.parse(timestamp);
  List<DocModel> courses = [];
  QuerySnapshot query1 =
      await studyMaterialsRef.where("lastAdded", isGreaterThan: time).get();
  List<DocModel> pdf = query1.docs
      .map((documentSnapshot) => DocModel.fromDocument(documentSnapshot))
      .toList();
  QuerySnapshot query2 =
      await cbtCoursesRef.where("lastAdded", isGreaterThan: time).get();
  List<DocModel> cbt = query2.docs
      .map((documentSnapshot) => DocModel.fromDocument(documentSnapshot))
      .toList();

  courses.addAll(cbt);
  courses.addAll(pdf);
  if (courses.isNotEmpty) {
      saveTimestamp(DateTime.now().millisecondsSinceEpoch.toString());
    }
  saveOffline(courses);
}

Future<List<DocModel>> getCBTCourses(int limit)async{
  QuerySnapshot query = await cbtCoursesRef.limit(limit).get();
    return  query.docs.map((documentSnapshot) => DocModel.fromDocument(documentSnapshot)).toList();
}


Future<List<DocModel>> getCourses(int limit)async{
  QuerySnapshot query = await studyMaterialsRef.limit(limit).get();
    return  query.docs.map((documentSnapshot) => DocModel.fromDocument(documentSnapshot)).toList();
}


//listen for changes made to documents on the server
void updateChanges() async {
  String timestamp;
  timestamp = await readTimestamp();
  int time = int.parse(timestamp);
  List<DocModel> courses = [];

  QuerySnapshot query1 =
      await studyMaterialsRef.where("lastUpdated", isGreaterThan: time).get();
  List<DocModel> pdf = query1.docs
      .map((documentSnapshot) => DocModel.fromDocument(documentSnapshot))
      .toList();
  QuerySnapshot query2 =
      await cbtCoursesRef.where("lastUpdated", isGreaterThan: time).get();
  List<DocModel> cbt = query2.docs
      .map((documentSnapshot) => DocModel.fromDocument(documentSnapshot))
      .toList();

  courses.addAll(cbt);
  courses.addAll(pdf);
  if (courses.isNotEmpty) {
      saveTimestamp(DateTime.now().millisecondsSinceEpoch.toString());
  }
  courses.forEach((e) async {
    DocModel data = DocModel(
          fID: e.fID,
          username:e.username,
          ownerImage: e.ownerImage,
          ratings: e.ratings,
          ownerId: e.ownerId,
          visible: e.visible,
          category: e.category,
          bytes: e.bytes,
          code: e.code,
          conversation: e.conversation,
          title: e.title,
          school: e.school,
          url: e.url);

    await databaseHelper.updateChanges(data);
  });
}

//download  courses to sqlflite
Future<void> donwloadCourses() async {
  List<DocModel> courses = [];
  QuerySnapshot query1 = await studyMaterialsRef.get();
  List<DocModel> pdf = query1.docs
      .map((documentSnapshot) => DocModel.fromDocument(documentSnapshot))
      .toList();
  QuerySnapshot query2 = await cbtCoursesRef.get();
  List<DocModel> cbt = query2.docs
      .map((documentSnapshot) => DocModel.fromDocument(documentSnapshot))
      .toList();

  databaseHelper.truncateCourses();
  courses.addAll(cbt);
  courses.addAll(pdf);

  saveOffline(courses);
}


Future<void> clearCourses() async {
  await databaseHelper.truncateCourses();
}

Future<void> saveOffline(List<DocModel> course) async {
  course.forEach((e) async {
    if ( e.visible == 1) {
      if(e.dateUploaded == "" && e.bytes != 0){
      UserModel user = await userDetails(e.ownerId!) as UserModel;
       studyMaterialsRef.doc(e.fID).set({
        "id": e.id,
        "ownerId": e.ownerId,
        "username":user.username,
        "ownerImage":user.url,
        "school": e.school,
        "title": e.title,
        "originalTitle":e.originalTitle,
        "bytes": e.bytes,
        "ratings":'5,',
        "likeIds": "",
        "conversation": 0,
        "dateUploaded":Jiffy(DateTime.now()).yMMMMd,
        "timestamp": DateTime.now(),
        'lastUpdated': DateTime.now().millisecondsSinceEpoch,
        'lastAdded': DateTime.now().millisecondsSinceEpoch,
        "visible": e.visible,
        "favorite":e.favorite,
        "url":e.url,
        "category": e.category,
        "code":e.code,
      });
       DocModel data = DocModel(
          fID: e.fID,
          username:e.username,
          ownerImage: e.ownerImage,
          ratings: e.ratings,
          ownerId: e.ownerId,
          visible: e.visible,
          category: e.category,
          bytes: e.bytes,
          code: e.code,
          conversation: e.conversation,
          title: e.title,
          school: e.school,
           dateUploaded: e.dateUploaded,
          url: e.url);

          await databaseHelper.insertCourse(data);
    }else{
        DocModel data = DocModel(
          fID: e.fID,
          username:e.username,
          ownerImage: e.ownerImage,
          ratings: e.ratings,
          ownerId: e.ownerId,
          visible: e.visible,
          category: e.category,
          dateUploaded: e.dateUploaded,
          bytes: e.bytes,
          code: e.code,
          conversation: e.conversation,
          title: e.title,
          school: e.school,
          url: e.url);

          await databaseHelper.insertCourse(data);
      }
    }
  });
}

Future<List<DocModel>> fetchCourses() async {
  List<DocModel> courses = [];
  final Future<Database> dbFuture = databaseHelper.initializeDatabase();
  await dbFuture.then((database) async {
    Future<List<DocModel>> noteListFuture = databaseHelper.getNoteList();
    await noteListFuture.then((course) {
      courses = course;
    });
  });
  return courses;
}

Future<List<DocModel>> getCoursesList(BuildContext context) async {
  List<DocModel> courses = [];
  //contents hidden by user
  List huddenUserIds = [];
  List<Content> contents = await HideContentService().getHiddenContent();
  contents.forEach((element) {
    huddenUserIds.add(element.id);
  });

  List<DocModel> temp = await fetchCourses();
  if (temp.isNotEmpty) {
    temp.shuffle();
    temp.forEach((element) {
       if(!huddenUserIds.contains(element.ownerId) ){
          courses.add(element);
       }
    });

    //check if new courses has been added to firebase
    updateCouses();
    //check if changes was made to the document
    updateChanges();
    //If user is online then update was successful hence save the time
    return courses;
  } else {
    SnackBar snackBar =
        const SnackBar(content: Text("Internet connection required."));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // ignore: use_build_context_synchronously
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ContentUpdate()));
  }
  return [];
}

Future<List<DocsModel>> fetchDownloads() async {
  DocsDbHelper docdatabaseHelper = DocsDbHelper();
  List<DocsModel> pdf = [];
  final Future<Database> dbFuture = docdatabaseHelper.initializeDatabase();
  await dbFuture.then((database) async {
    Future<List<DocsModel>> noteListFuture = docdatabaseHelper.getNoteList();
    await noteListFuture.then((pdfList) {
      return pdf = pdfList;
    });
  });
  return pdf;
}
