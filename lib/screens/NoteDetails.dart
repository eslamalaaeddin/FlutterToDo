import 'package:flutter/material.dart';
import 'package:todo_sqflite/models/Note.dart';
import 'package:todo_sqflite/utils/DatabaseHelper.dart';
import 'package:intl/intl.dart';

class NoteDetails extends StatefulWidget {
  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  TextEditingController titleTextEditController;
  TextEditingController descriptionTextEditController;
  Map args;
  DatabaseHelper databaseHelper = DatabaseHelper();
  String title;

  int noteId;
  String noteTitle;
  String noteDescription;
  int notePriority;
  String noteDate;

  Note note;

  @override
  Widget build(BuildContext context) {
    titleTextEditController = TextEditingController();
    descriptionTextEditController = TextEditingController();

    args = ModalRoute.of(context).settings.arguments;
    title = args['title'];
    noteId = args['noteId'];
    noteTitle = args['noteTitle'];
    noteDescription = args['noteDescription'];
    notePriority = args['notePriority'];
    noteDate = args['noteDate'];

   note =
       Note.withId( noteId, noteTitle ,  noteDate, notePriority, noteDescription);

    titleTextEditController.text = noteTitle;
    descriptionTextEditController.text = noteDescription;


    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    items: <String>['High', 'Medium', 'Low'].map((String priority) {
                      return DropdownMenuItem<String>(
                        value: getPriorityAsString(note.priority),
                        child: Text(priority),
                      );
                    }).toList(),
                    onChanged: (valueSelectedByUser) {
                      // setState(() {
                        updatePriorityAsInteger(valueSelectedByUser);
                      // });
                      print('$valueSelectedByUser');
                  },
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: TextFormField(
                controller: titleTextEditController,
                onTap: (){print(titleTextEditController.text);},
                decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 5.0),
                  )
                ),
                onChanged: (value){
                  // setState(() {
                    updateTitle();
                  // });
                },
    ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: TextFormField(
                controller: descriptionTextEditController,
                onTap: (){
                  print(descriptionTextEditController.text);
                },
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 5.0),
                  )
                ),
                onChanged: (value){
                  print(value);
                  // setState(() {
                    updateDescription();
                  // });
                },
    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      child: Card(
                        color: Colors.green,
                        child: FlatButton(
                            onPressed: (){
                              setState(() {
                                saveNote();
                              });
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            )
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Card(
                        color: Colors.red,
                        child: FlatButton(
                            onPressed: (){
                              setState(() {
                                deleteNote();
                              });
                            },
                            child: Text('Delete', style: TextStyle(color: Colors.white),)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
    )
    ,
    );

  }

  void updatePriorityAsInteger(String value){
    switch (value){
      case 'High':
        note.priority = 1;
        break;
      case 'Medium':
        note.priority = 2;
        break;
      case 'Low':
        note.priority = 3;
    }
  }

  String getPriorityAsString(int value){
    String priority;
    switch(value){
      case 1:
        priority = 'High';
        break;
      case 2:
        priority = 'Medium';
        break;
      case 3:
        priority = 'Low';
    }
    return priority;
  }

  void updateTitle(){
    note.title = titleTextEditController.text;
  }

  void updateDescription(){
    note.description = descriptionTextEditController.text;
  }

  void saveNote() async {

    note.date = note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    //Update
    if (note.id == null){
      result = await databaseHelper.updateNote(note);
    }
    //Insert
    else{
      result = await databaseHelper.insertNote(note);
    }

    if(result != 0){
      _showAlertDialog('Status', 'Note Saved Successfully');
    }

    else{
      _showAlertDialog('Status', '$result');
    }
  }


  void deleteNote() async {
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }
    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }



}
