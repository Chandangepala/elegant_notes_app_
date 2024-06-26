import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app_ui/providers/notes_provider.dart';
import 'package:provider/provider.dart';
import '../model/notes_model.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black38,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Consumer<NotesProvider>(builder: (context, notesProvider, child){
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back_ios_new, size: 32, color: Colors.white,)),
                    TextButton(onPressed: () async{
                      if(titleController.text.isNotEmpty && descController.text.isNotEmpty){
                        DateTime dateNow = DateTime.now();
                        String fDateNow = DateFormat('MMMM d, yyyy').format(dateNow);
                        bool inserted = await notesProvider.addNotes(newNote: NoteModel(title: titleController.text, desc: descController.text, mColor: Random().nextInt(20), date: fDateNow, userId: 1));
                          if(inserted){
                            Navigator.pop(context);
                          }
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Missing Title or Description!"))
                        ) ;
                      }
                    },
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Text("Save", style: TextStyle(color: Colors.white, fontSize: 16, ),)))
                  ],
                ),
                SizedBox(height: 40,),
                TextField(
                  controller: titleController,
                  cursorColor: Colors.grey,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white
                  ),
                  decoration: InputDecoration(
                      labelText: "Title",
                      labelStyle: TextStyle(
                          color: Colors.white
                      ),
                      hintText: "Enter Title",
                      focusColor: Colors.grey,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white)
                      )
                  ),
                ),
                SizedBox(height: 30,),
                TextField(
                  controller: descController,
                  minLines: 8,
                  maxLines: 16,
                  cursorColor: Colors.grey,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                  ),
                  decoration: InputDecoration(
                      labelText: "Type something...",
                      labelStyle: TextStyle(
                          color: Colors.white
                      ),
                      hintText: "Enter Title",
                      focusColor: Colors.grey,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white)
                      )
                  ),
                ),
              ],
            );
          })
        ),
      ),
    );
  }
}
