import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_note_app_with_php_api/constants/api_links.dart';
import 'package:my_note_app_with_php_api/models/note.dart';
import 'package:my_note_app_with_php_api/providers/notes_provider.dart';
import 'package:my_note_app_with_php_api/screens/notes/edit_note_screen.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget({super.key, required this.note});
  final Note note;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => EditNoteScreen(
              note: note,
            ),
          ),
        );
      },
      title: Text(
        note.title,
      ),
      subtitle: Text(
        note.content,
      ),
      trailing: IconButton(
        onPressed: () async {
          bool result = await note.delete();
          if (result) {
            NotesProvider.instance.notes.remove(note);
            NotesProvider.instance.refreshHomeScreen();
          }
        },
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
      leading: note.image != null
          ? CircleAvatar(
              backgroundImage: NetworkImage('$linkImageRoot/${note.image}'),
            )
          : SizedBox(
              width: 2,
            ),
    );
  }
}
