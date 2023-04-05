import 'dart:async';
import 'dart:io';
import 'package:mycbt/src/models/event_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class EventsDBHelper {
  static EventsDBHelper? _databaseHelper;
  // Singleton EventsDBHelper
  static Database? _database; // Singleton Database
  String table = 'events';
  String day = 'day';
  String title = 'title';
  String id = 'id';
  String starts = 'starts';
  String ends = 'ends';

  EventsDBHelper._createInstance(); // Named constructor to create instance of EventsDBHelper

  factory EventsDBHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = EventsDBHelper._createInstance(); // This is executed only once, singleton object
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
    String path = directory.path + 'events.db';

    // Open/create the database at a given path
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $table ($id INTEGER PRIMARY KEY AUTOINCREMENT, $day TEXT, $title TEXT, $starts TEXT, $ends TEXT)');
  }

  // Fetch Operation: Get all quiz objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    //var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    //	var result = await db.rawQuery('SELECT * FROM $table WHERE userId =$currentUserId order by $id ASC');
    var result = await db.query(table, orderBy: '$id ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertEvent(EventModel event) async {
    Database db = await this.database;
    var result = await db.insert(table, event.toMap());
    return result;
  }

 
  Future<int> updateEvent(EventModel event) async {
  	var db = await this.database;
  	var result = await db.update(table, event.toMap(), where: '$id = ?', whereArgs: [event.id]);
  	return result;
  }


  // Delete Operation: Delete a Note object from database
  Future<int> deleteEvent(int eventId) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $table WHERE $id = $eventId');
    return result;
  }

  

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<EventModel>> getNoteList() async {
    var noteList = await getNoteMapList(); // Get 'Map List' from database
    int count = noteList.length; // Count the number of map entries in db table
    List<EventModel> events = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      events.add(EventModel.fromMapObject(noteList[i]));
    }
    return events;
  }
}
