// @ dart=2.9
import 'dart:async';
import 'dart:io';
import 'package:mycbt/src/models/doc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class CoursesDbHelper {
  static CoursesDbHelper? _databaseHelper;
  // Singleton CoursesDbHelper
  static Database? _database; // Singleton Database
  String table = 'courses';
  String title = 'title';
  String id = 'id';
  String fID = 'fID';
  String school = 'school';
  String url = 'url';
  String type = 'type';
  String ownerId = "ownerId";
  String bytes = "bytes";
  String visible = "visible";
  String conversation = "conversation";
  String likeIds = "likeIds";
  String code = "code";
  String favorite = "favorite";
  String category = "category";

  // ignore: unused_element
  CoursesDbHelper._createInstance(); // Named constructor to create instance of CoursesDbHelper

  factory CoursesDbHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = CoursesDbHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'cbin.db';

    // Open/create the database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $table ($id INTEGER PRIMARY KEY AUTOINCREMENT, $fID TEXT UNIQUE,'
        '$title TEXT, $type INTEGER , $school TEXT, $url TEXT, $ownerId TEXT, $conversation INTEGER,'
        ' $likeIds TEXT, $category TEXT, $favorite INTEGER, $bytes INTEGER,  $visible INTEGER , $code TEXT)');
  }

  // Fetch Operation: Get all quiz objects from database
  Future<List<Map<String, dynamic>>?> getNoteMapList() async {
    Database? db = await database;
    // var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    //	var result = await db.rawQuery('SELECT * FROM $table WHERE userId =$currentUserId order by $id ASC');
    var result = await db.query(table, orderBy: '$id ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int?> insertCourse(DocModel course) async {
    Database? db = await database;
    var result = await db.insert(table, course.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  // Future<int> updateNote(DocModel course) async {
  // 	var db = await database;
  // 	var result = await db.update(table, course.toMap(), where: '$id = ?', whereArgs: [quiz.firebaseId]);
  // 	return result;
  // }

   Future<int> makeFavorite(String courseId,int value) async {
    var db = await database;
    var result = await db.rawUpdate(
        'UPDATE $table SET $favorite = ? WHERE $fID = ?',
        [value, courseId]);
    return result;
  }

  Future<int> removeFavorite(String courseId, int value) async {
    var db = await database;
    var result = await db.rawUpdate(
        'UPDATE $table SET $favorite = ? WHERE $fID = ?',
        [value, courseId]);
    return result;
  }


  Future<int> updateChanges(DocModel course) async {
    var db = await database;
    var result = await db.rawUpdate(
        'UPDATE $table SET $visible = ?, $conversation = ? WHERE $fID = ?',
        ['${course.visible}', '${course.conversation}', '${course.fID}']);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int?> deleteNote(int id) async {
    var db = await database;
    int? result = await db.rawDelete('DELETE FROM $table WHERE $id = $id');
    return result;
  }

  //delete all questions
  Future<int?> truncateCourses() async {
    var db = await database;
    int? result = await db.rawDelete('DELETE FROM $table');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database? db = await database;
    List<Map<String, dynamic>>? x =
        await db.rawQuery('SELECT COUNT (*) from $table');
    int? result = Sqflite.firstIntValue(x);
    return result!;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<DocModel>> getNoteList() async {
    var noteList = await getNoteMapList(); // Get 'Map List' from database
    int? count =
        noteList?.length; // Count the number of map entries in db table
    List<DocModel> notes = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count!; i++) {
      notes.add(DocModel.fromMapObject(noteList![i]));
    }
    return notes;
  }
}
