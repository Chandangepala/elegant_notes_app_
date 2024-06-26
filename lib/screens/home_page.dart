import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app_ui/providers/notes_provider.dart';
import 'package:notes_app_ui/screens/add_note_page.dart';
import 'package:notes_app_ui/screens/note_page.dart';
import 'package:provider/provider.dart';

import '../model/notes_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<NoteModel> notesList = [];

  List<Color> colorList = [
    Colors.blue.shade300,
    Colors.amber.shade200,
    Colors.blue.shade200,
    Colors.blueGrey.shade300,
    Colors.cyan.shade300,
    Colors.deepOrange.shade300,
    Colors.greenAccent.shade200,
    Colors.green.shade300,
    Colors.grey.shade300,
    Colors.indigoAccent.shade200,
    Colors.lightBlue.shade400,
    Colors.lime.shade200,
    Colors.orange.shade300,
    Colors.pink.shade200,
    Colors.pinkAccent.shade100,
    Colors.red.shade300,
    Colors.teal.shade300,
    Colors.purple.shade300,
    Colors.white54,
    Colors.yellow.shade200,
    Colors.yellowAccent.shade100
  ];

  getNotes({required NotesProvider notesProvider}) async {
    notesList = await notesProvider.getUserNotes(userId: 1);
  }

  @override
  Widget build(BuildContext context) {
    print("colorListSize: ${colorList.length}" );
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black38,
            appBar: AppBar(
              backgroundColor: Colors.black12,
              title: Text("Notes", style: TextStyle(fontSize: 36,color: Colors.white),),
              actions: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.search, color: Colors.white, size: 32,),
                  ))],
            ),
            body: Consumer<NotesProvider>(builder: (context, notesProvider, child) {
              getNotes(notesProvider: notesProvider);
              return Padding(
                padding: EdgeInsets.all(8),
                child: MasonryGridView.builder(
                    itemCount: notesList.length,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return GridTile(
                          child: InkWell(
                            onLongPress: (){
                              bool deleted;
                              showMenu(context: context,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  color: Colors.grey.shade800,
                                  position: RelativeRect.fromDirectional(textDirection: TextDirection.ltr, start: 150, top: double.infinity, end: 150, bottom: 0),
                                  items: [
                                    PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.delete, color: Colors.white,),
                                            SizedBox(width: 15,),
                                            Text("Delete", style: TextStyle(color: Colors.white, fontSize: 16),),
                                          ],
                                        ))
                                  ]
                              ).then((value) async => {
                                if(value == 'delete') {
                                    deleted = await notesProvider.deleteNotes(noteId: notesList[index].id)
                                }
                              });
                            },
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NotePage(note: notesList[index],)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorList[notesList[index].mColor],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(notesList[index].title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,),),
                                    SizedBox(height: 15,),
                                    Text(notesList[index].date!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    }),
              );
            }),
            floatingActionButton: FloatingActionButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.black87,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddNotePage()));
              }, child: Icon(Icons.add, color: Colors.white,),),
        ),
    );
  }
}
