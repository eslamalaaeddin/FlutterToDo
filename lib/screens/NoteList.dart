

import 'package:flutter/material.dart';
import 'package:todo_sqflite/models/Note.dart';
import 'package:todo_sqflite/utils/DatabaseHelper.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if(noteList == null){
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () { navigateToAddNote('Add Note'); },
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getListView(){
    return ListView.builder(
      itemCount: noteList.length,
      itemBuilder: (context, index){
        return Container(
          margin: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          child: Card(
            child: ListTile(
              onTap: () {navigateToEditNote('Edit Note', index);},
              title: Text(noteList[index].title),
              subtitle: Text(noteList[index].date),
              leading: CircleAvatar(
                backgroundColor: getPriorityColor(noteList[index].priority),
              ),
              trailing: GestureDetector(child: Icon(Icons.delete), onTap: (){_delete(context, noteList[index]);},),
            ),
          ),
        );
      },
    );
  }

  Color getPriorityColor(int priority){
    switch(priority){
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      case 3:
        return Colors.green;
        break;

      default:
        return Colors.yellow;
    }
  }

  //it takes the note that you want to delete
  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if(result != 0){
      showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void updateListView() {
    final Future  dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }


  void navigateToAddNote(String title){ 
    Navigator.pushNamed(context, '/noteDetails', arguments: {'title': title});
  }

  void navigateToEditNote(String title, int index){
    Note currentNote = noteList[index];
    Navigator.pushNamed(
        context,
        '/noteDetails',
        arguments: {
          'title': title,
          'noteId': currentNote.id,
          'noteTitle': currentNote.title,
          'noteDescription': currentNote.title,
          'notePriority': currentNote.title,
          'noteDate': currentNote.title,
        }
        );
  }
}



void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
