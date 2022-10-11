import 'dart:async';
import 'dart:io';
import 'package:mycbt/src/models/questions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class QuizDbHelper {
  static QuizDbHelper? _databaseHelper;
  // Singleton QuizDbHelper
  static Database? _database; // Singleton Database
  String table = 'questions';
  String id = 'id';
  String firebaseId = 'firebaseId';
  String subject = 'subject';
  String category = 'category';
  String code = 'code';
  String school = 'school';
  String course = 'course';
  String year = 'year';
  String question = 'question';
  String answer = 'answer';
  String option1 = 'option1';
  String option2 = 'option2';
  String option3 = 'option3';
  String image = 'image';

  QuizDbHelper._createInstance(); // Named constructor to create instance of QuizDbHelper

  factory QuizDbHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = QuizDbHelper
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
    String path = directory.path + 'cbt.db';

    // Open/create the database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $table($id INTEGER PRIMARY KEY AUTOINCREMENT,$firebaseId TEXT UNIQUE, $subject TEXT, $category TEXT, $code TEXT,  $school TEXT, $course TEXT, $year TEXT, $question TEXT, $answer TEXT, $option1 TEXT, $option2 TEXT,$option3 TEXT,  $image TEXT)');
  }

  // Fetch Operation: Get all quiz objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    //	var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    //	var result = await db.rawQuery('SELECT * FROM $table WHERE userId =$currentUserId order by $id ASC');
    var result = await db.query(table, orderBy: '$id ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertQuiz(QuizModel quiz) async {
    Database db = await this.database;
    var result = await db.insert(table, quiz.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateNote(QuizModel quiz) async {
    var db = await this.database;
    var result = await db.update(table, quiz.toMap(),
        where: '$id = ?', whereArgs: [quiz.firebaseId]);
    return result;
  }

  //  Future<int> updateProgress(QuizModel quiz) async {
  // 	var db = await this.database;
  // 	var result = await db.rawUpdate('UPDATE $table SET $progress = ?, $pages = ? WHERE $firebaseId = ?',
  //    ['${quiz.progress}','${quiz.pages}','${quiz.firebaseId}']);
  // 	return result;
  // }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $table WHERE $id = $id');
    return result;
  }

  //delete all questions
  Future<int> truncateQuiz() async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $table');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $table');
    int? result = Sqflite.firstIntValue(x);
    return result!;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<QuizModel>> getNoteList() async {
    var noteList = await getNoteMapList(); // Get 'Map List' from database
    int count = noteList.length; // Count the number of map entries in db table
    List<QuizModel> notes = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      notes.add(QuizModel.fromMapObject(noteList[i]));
    }
    return notes;
  }
}
