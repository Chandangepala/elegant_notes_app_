import 'dart:ui';

import 'package:notes_app_ui/database/app_database.dart';

class NoteModel {
  int userId;
  int? id;
  String title;
  String desc;
  int mColor;
  String? date;

  NoteModel(
      {this.id, required this.title, required this.desc, required this.mColor, this.date, required this.userId});

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
        id: map[AppDatabase.COLUMNS_NOTE_ID],
        title: map[AppDatabase.COLUMN_NOTE_TITLE],
        desc: map[AppDatabase.COLUMN_NOTE_DESC],
        mColor: map[AppDatabase.COLUMN_NOTE_COLOR_CODE],
        date: map[AppDatabase.COLUMN_NOTE_DATE],
        userId: map[AppDatabase.COLUMN_USER_ID]);
  }

  Map<String, dynamic> toMap() {
    return{
      //AppDatabase.COLUMNS_NOTE_ID : id,
      AppDatabase.COLUMN_NOTE_TITLE: title,
      AppDatabase.COLUMN_NOTE_DESC: desc,
      AppDatabase.COLUMN_NOTE_COLOR_CODE: mColor,
      AppDatabase.COLUMN_NOTE_DATE: date,
      AppDatabase.COLUMN_USER_ID: userId
    };
  }
}
