
import 'dart:async';
import 'dart:io';
import 'package:mycbt/src/models/docs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DocsDbHelper {

	static DocsDbHelper? _databaseHelper;
      // Singleton DocsDbHelper
	static Database? _database;                // Singleton Database
	 String table = 'Docs';
   String id =  'id';
   String firebaseId =  'firebaseId';
   String code =  'code';
   String title  =  'title';
   String pages =  'pages';
   String progress =  'progress';
   String filePath =  'filePath';

	

	DocsDbHelper._createInstance(); // Named constructor to create instance of DocsDbHelper

	factory DocsDbHelper() {

		if (_databaseHelper == null) {
			_databaseHelper = DocsDbHelper._createInstance(); // This is executed only once, singleton object
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
		String path = directory.path + 'docs.db';

		// Open/create the database at a given path
		var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
		return notesDatabase;
	}

	void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $table($id INTEGER PRIMARY KEY AUTOINCREMENT,$firebaseId TEXT, $title TEXT, $code TEXT,  $filePath TEXT, $pages  INTEGER, $progress  INTEGER)');
	}

	// Fetch Operation: Get all note objects from database
	Future<List<Map<String, dynamic>>> getNoteMapList() async {
		Database db = await database;
//	var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
	//	var result = await db.rawQuery('SELECT * FROM $table WHERE userId =$currentUserId order by $id ASC');
		var result = await db.query(table, orderBy: '$id DESC');
		return result;
	}

	// Insert Operation: Insert a Note object to database
	Future<int> insertNote(DocsModel note) async {
		Database db = await database;
		var result = await db.insert(table, note.toMap());
		return result;
	}

	// Update Operation: Update a Note object and save it to database
	Future<int> updateNote(DocsModel note) async {
		var db = await database;
		var result = await db.update(table, note.toMap(), where: '$id = ?', whereArgs: [note.firebaseId]);
		return result;
	}
  
   Future<int> updateProgress(DocsModel note, int docId) async {
		var db = await database;
		var result = await db.rawUpdate('UPDATE $table SET $progress = ?, $pages = ? WHERE $id = ?',
     ['${note.progress}','${note.pages}','$docId']);
		return result;
	}

	// Delete Operation: Delete a Note object from database
	Future<int> deleteNote(int noteId) async {
		var db = await database;
		int result = await db.rawDelete('DELETE FROM $table WHERE $id = $noteId');
		return result;
	}

	// Get number of Note objects in database
	Future<int> getCount() async {
		Database db = await database;
		List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $table');
		int? result = Sqflite.firstIntValue(x);
		return result!;
	}

	// Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
	Future<List<DocsModel>> getNoteList() async {
		var noteList = await getNoteMapList(); // Get 'Map List' from database
		int count = noteList.length;         // Count the number of map entries in db table
		List<DocsModel> notes =[];
		// For loop to create a 'Note List' from a 'Map List'
		for (int i = 0; i < count; i++) {
			notes.add(DocsModel.fromMapObject(noteList[i]));
		}
		return notes;
	}

}







