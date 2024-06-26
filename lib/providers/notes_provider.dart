import 'package:flutter/cupertino.dart';
import 'package:notes_app_ui/database/app_database.dart';
import 'package:notes_app_ui/model/notes_model.dart';

class NotesProvider extends ChangeNotifier{
  List<NoteModel> notesList = [];

  Future<bool> addNotes({required newNote}) async{
    bool check = await AppDatabase.db.insertNote(note: newNote);
    return check;
  }

  Future<List<NoteModel>> getUserNotes({required userId}) async{
    notesList = await AppDatabase.db.fetchUserNotes(userId: userId);
    notifyListeners();
    return notesList;
  }

  Future<bool> deleteNotes({required noteId}) async{
    bool deleted = await AppDatabase.db.deleteNote(noteId: noteId);
    return deleted;
  }

  Future<bool> updateNotes({required noteModel}) async{
    bool updated = await AppDatabase.db.updateNote(noteModel: noteModel);
    return updated;
  }

  Future<NoteModel> getSingleNote({required NoteModel noteModel}) async{
    NoteModel note = await AppDatabase.db.getNote(userId: noteModel.userId, noteId: noteModel.id);
    return note;
  }
}