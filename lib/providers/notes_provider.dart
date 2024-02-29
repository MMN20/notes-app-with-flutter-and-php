import 'package:flutter/material.dart';
import 'package:my_note_app_with_php_api/models/note.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> notes = [];

  Future<void> setNotes() async {
    notes = await Note.getAllNotes();
    notifyListeners();
  }

  void refreshHomeScreen() {
    notifyListeners();
  }

  static late NotesProvider instance;

  NotesProvider() {
    instance = this;
    setNotes();
  }
}
