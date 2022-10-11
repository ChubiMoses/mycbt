import 'package:flutter/material.dart';
import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/models/docs.dart';
import 'package:mycbt/src/screen/documents/download_courses.dart';
import 'package:mycbt/src/services/file_service.dart';
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
        likeIds: e.likeIds,
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
    if (e.visible == 1) {
      DocModel data = DocModel(
          fID: e.fID,
          likeIds: e.likeIds,
          ownerId: e.ownerId,
          visible: e.visible,
          category: e.category,
          bytes: e.bytes,
          code: e.code,
          conversation: e.conversation,
          title: e.title,
          school: e.school,
          url: e.url);
      await databaseHelper.insertCourse(data);
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

  List<DocModel> temp = await fetchCourses();
  if (temp.isNotEmpty) {
    temp.shuffle();
    temp.forEach((element) {
      courses.add(element);
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
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
