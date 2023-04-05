import 'dart:async';
import 'dart:io';
import 'package:mycbt/src/models/offline_gist_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class GistDatabase {
  static GistDatabase? _databaseHelper;
  // Singleton GistDatabase
  static Database? _database; // Singleton Database
  String table = 'gist';
  String id = 'id';
  String postId = 'postId';
  String ownerId = 'ownerId';
  String time = 'time';
  String likes = 'likes';
  String username = 'username';
  String description = 'description';
  String url = 'url';
  String comments = 'comments';
  String visible = 'visible';

  GistDatabase._createInstance(); // Named constructor to create instance of GistDatabase

  factory GistDatabase() {
    if (_databaseHelper == null) {
      _databaseHelper = GistDatabase
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
    String path = directory.path + 'gistdb.db';

    // Open/create the database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $table($id INTEGER PRIMARY KEY AUTOINCREMENT, $postId TEXT UNIQUE, $ownerId TEXT, $time TEXT, $likes INTEGER, $visible INTEGER,  $username TEXT, $description TEXT, $url TEXT, $comments INTEGER)');
  }

  // Fetch Operation: Get all quiz objects from database
  Future<List<Map<String, dynamic>>> getData() async {
    Database db = await this.database;
    //	var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    //	var result = await db.rawQuery('SELECT * FROM $table WHERE userId =$currentUserId order by $id ASC');
    var result = await db.query(table, orderBy: '$id ASC');
    return result;
  }

  // Fetch Operation: Get all quiz objects from database
  Future<List<Map<String, dynamic>>> getDataInfo(String id) async {
    Database db = await this.database;
    //	var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.rawQuery('SELECT * FROM $table WHERE id =$id');
    // var result = await db.query(table, orderBy: '$id ASC');
    return result;
  }

  // Fetch Operation: Get my gist
  Future<List<Map<String, dynamic>>> myGist(String id) async {
    Database db = await this.database;
    //	var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.rawQuery('SELECT * FROM $table WHERE ownerId =$id');
    // var result = await db.query(table, orderBy: '$id ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insert(OfflineGistModel quiz) async {
    Database db = await this.database;
    var result = await db.insert(table, quiz.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> update(OfflineGistModel quiz) async {
    var db = await this.database;
    var result = await db.update(table, quiz.toMap(),
        where: '$id = ?', whereArgs: [quiz.postId]);
    return result;
  }

  //  Future<int> updateProgress(OfflineGistModel quiz) async {
  // 	var db = await this.database;
  // 	var result = await db.rawUpdate('UPDATE $table SET $progress = ?, $pages = ? WHERE $firebaseId = ?',
  //    ['${quiz.progress}','${quiz.pages}','${quiz.firebaseId}']);
  // 	return result;
  // }

  // Delete Operation: Delete a Note object from database
  Future<int> delete(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $table WHERE $id = $id');
    return result;
  }

  //delete all questions
  Future<int> truncate() async {
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
  Future<List<OfflineGistModel>> getGistList() async {
    var noteList = await getData(); // Get 'Map List' from database
    int count = noteList.length; // Count the number of map entries in db table
    List<OfflineGistModel> notes = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      notes.add(OfflineGistModel.fromMapObject(noteList[i]));
    }
    return notes;
  }

  Future<List<OfflineGistModel>> getMyGistList(String ownerId) async {
    var data = await myGist(ownerId); // Get 'Map List' from database
    int count = data.length; // Count the number of map entries in db table
    List<OfflineGistModel> gist = [];
    for (int i = 0; i < count; i++) {
      gist.add(OfflineGistModel.fromMapObject(data[i]));
    }
    return gist;
  }

  Future<OfflineGistModel> getGistInfo(String id) async {
    var data = await getDataInfo(id); // Get 'Map List' from database
    OfflineGistModel notes;
    notes = OfflineGistModel.fromMapObject(data[0]);
    return notes;
  }
}
