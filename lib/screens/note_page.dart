import 'package:flutter/material.dart';
import 'package:notes_app_ui/model/notes_model.dart';
import 'package:notes_app_ui/providers/notes_provider.dart';
import 'package:provider/provider.dart';

class NotePage extends StatefulWidget {
  NoteModel note;
  NotePage({super.key, required this.note});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool editMode = false;
  NoteModel? updatedNote;
  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (BuildContext context, noteProvider, Widget? child) {
        return Scaffold(
          backgroundColor: Colors.black38,
          appBar: AppBar(
            backgroundColor: Colors.black12,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                  color: Colors.white,
                )),
            actions: [
              Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.withOpacity(0.5)),
                  child: IconButton(
                    icon: editMode
                        ? Icon(Icons.save, size: 32, color: Colors.white)
                        : Icon(Icons.create_rounded,
                            size: 32, color: Colors.white),
                    onPressed: () async {
                      bool updated;
                      if (editMode) {
                          updated = await noteProvider.updateNotes(
                            noteModel: NoteModel(
                                id: widget.note.id,
                                title: titleController.text,
                                desc: descController.text,
                                mColor: widget.note.mColor,
                                date: widget.note.date,
                                userId: widget.note.userId));
                          print(updated);
                          if(updated){
                             updatedNote = await noteProvider.getSingleNote(noteModel: widget.note);
                          }
                        editMode = false;
                      } else {
                        editMode = true;
                      }
                      setState(() {
                        titleController.text = updatedNote != null ?  updatedNote!.title : widget.note.title;
                        descController.text = updatedNote != null ?  updatedNote!.desc : widget.note.desc;
                      });
                    },
                  ))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                editMode
                    ? TextField(
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.white),
                        controller: titleController,
                        decoration: InputDecoration(
                            label: Text('Title'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      )
                    : Text(
                        updatedNote != null ?  updatedNote!.title : widget.note.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.white),
                      ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${widget.note.date}",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                editMode
                    ? TextField(
                        maxLines: 7,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                        controller: descController,
                        decoration: InputDecoration(
                            label: Text('Description'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      )
                    : Text(
                        updatedNote != null ?  updatedNote!.desc : widget.note.desc,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}
