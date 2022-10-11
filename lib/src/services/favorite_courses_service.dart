import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/utils/courses_db_helper.dart';
import 'package:mycbt/src/utils/favorite_courses_db.dart';
import 'package:sqflite/sqflite.dart';



CoursesDbHelper favoriteCoursesDb = CoursesDbHelper();


Future<void> addTofavorite(String fID) async {
    await favoriteCoursesDb.makeFavorite(fID, 1);
}


Future<void> deleteFavorite(String fID) async {
    await favoriteCoursesDb.removeFavorite(fID, 0);
}


Future<List<DocModel>> fetchFavorite() async {
  List<DocModel> courses = [];
  final Future<Database> dbFuture = favoriteCoursesDb.initializeDatabase();
  await dbFuture.then((database) async {
    Future<List<DocModel>> noteListFuture = favoriteCoursesDb.getNoteList();
    await noteListFuture.then((course) {
      courses = course;
    });
  });
  return courses;
}