import 'package:flutter/material.dart';
import 'package:todo_sqflite/screens/NoteList.dart';
import 'package:todo_sqflite/screens/NoteDetails.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/notesList': (context) => NoteList(),
    '/noteDetails': (context) => NoteDetails()
  } ,
  debugShowCheckedModeBanner: false,
  home: NoteList(),
));





