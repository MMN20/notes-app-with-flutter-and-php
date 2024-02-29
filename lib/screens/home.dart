import 'package:flutter/material.dart';
import 'package:my_note_app_with_php_api/constants/functions.dart';
import 'package:my_note_app_with_php_api/main.dart';
import 'package:my_note_app_with_php_api/models/note.dart';
import 'package:my_note_app_with_php_api/models/user.dart';
import 'package:my_note_app_with_php_api/providers/notes_provider.dart';
import 'package:my_note_app_with_php_api/screens/auth/login_screen.dart';
import 'package:my_note_app_with_php_api/screens/notes/add_note_screen.dart';
import 'package:my_note_app_with_php_api/screens/notes/edit_note_screen.dart';
import 'package:my_note_app_with_php_api/widgets/note_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<NotesProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => AddNoteScreen()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              User.logOut();
              await deleteCurrentUserFromSharedPrefs();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (c) => const MyApp()),
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.exit_to_app,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: prov.notes.length,
        itemBuilder: (c, index) {
          print('================== ${prov.notes[index].image}');
          return NoteWidget(
            note: prov.notes[index],
          );
        },
      ),
    );
  }
}
