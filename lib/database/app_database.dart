import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:notes_app_ui/model/notes_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase{
  //Singleton class creation
  AppDatabase._();
  static final AppDatabase db = AppDatabase._();

  static const String DBNAME = "elegant_notes.db";
  static const String NOTES_TABLE = "notes_table";
  static const String COLUMNS_NOTE_ID = "note_id";
  static const String COLUMN_NOTE_TITLE = 'note_title';
  static const String COLUMN_NOTE_DESC = 'note_desc';
  static const String COLUMN_NOTE_COLOR_CODE = 'note_color';
  static const String COLUMN_NOTE_DATE = 'note_date';
  static const String COLUMN_USER_ID = 'user_id';

  Database? mDB;

  Future<Database> getDB() async{
    if(mDB != null){
      return mDB!;
    }else{
      mDB = await openDB();
      return mDB!;
    }
  }

  //To create and initialize database
  Future<Database> openDB() async{
    var rootPath = await getApplicationDocumentsDirectory();
    var dbPath = join(rootPath.path, DBNAME);
    return await openDatabase(dbPath, version: 2,
    onCreate: (db, version){
        db.execute(
          'create table $NOTES_TABLE ($COLUMNS_NOTE_ID integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text, $COLUMN_NOTE_COLOR_CODE integer, $COLUMN_NOTE_DATE text, $COLUMN_USER_ID integer)'
        );
      }
    );
  }

  //To insert data in database table
  Future<bool> insertNote({required NoteModel note}) async{
    var mainDB = await getDB();
    int rowEffect = await mainDB.insert(NOTES_TABLE, note.toMap());
    return rowEffect > 0;
  }

  //To fetch data from database table
  Future<List<NoteModel>> fetchUserNotes({required userId}) async{
    var mainDB = await getDB();

    List<NoteModel> notesModelList = [];
    try{
      List<Map<String, dynamic>> notesList  = await mainDB.query(NOTES_TABLE, where: "$COLUMN_USER_ID = ?", whereArgs: [userId]);

      for(Map<String, dynamic> eachNote in notesList){
        notesModelList.add(NoteModel.fromMap(eachNote));
      }
    }catch(e){
      print("Error: $e");
    }
    return notesModelList;
  }

  Future<NoteModel> getNote({required userId, required noteId}) async{
    var mainDB = await getDB();
    var note = await mainDB.query(NOTES_TABLE, where: "$COLUMN_USER_ID = ? and $COLUMNS_NOTE_ID = ?", whereArgs: [userId, noteId]);
    return NoteModel.fromMap(note[0]);
  }
  Future<bool> deleteNote({required noteId}) async{
      var mainDB = await getDB();
      int deleted = await mainDB.delete(NOTES_TABLE, where: "$COLUMNS_NOTE_ID = ?", whereArgs: [noteId]);
      return deleted > 0;
  }

  Future<bool> updateNote({required NoteModel noteModel}) async{
    var mainDB = await getDB();
    int  updated = await mainDB.update(NOTES_TABLE, noteModel.toMap(), where: "$COLUMNS_NOTE_ID =  ?", whereArgs: [noteModel.id]);
    return updated > 0;
  }
}