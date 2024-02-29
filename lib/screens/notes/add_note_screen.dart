import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_note_app_with_php_api/models/note.dart';
import 'package:my_note_app_with_php_api/providers/notes_provider.dart';
import 'package:my_note_app_with_php_api/widgets/my_button.dart';
import 'package:my_note_app_with_php_api/widgets/my_text_field.dart';
import 'package:image_picker/image_picker.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool isLoading = false;
  XFile? xfile;

  void pickImageMethod() {
    showDialog(
      context: context,
      builder: (c) => SimpleDialog(
        children: [
          SimpleDialogOption(
            child: const Center(child: Text('Gallery')),
            onPressed: () {
              uploadImage(ImageSource.gallery);
            },
          ),
          SimpleDialogOption(
            child: const Center(child: Text('Camera')),
            onPressed: () {
              uploadImage(ImageSource.camera);
            },
          )
        ],
      ),
    );
  }

  void uploadImage(ImageSource source) async {
    Navigator.pop(context);
    xfile = await ImagePicker().pickImage(source: source);
    if (xfile != null) {
      setState(() {});
    }
  }

  void addFunctionality() async {
    isLoading = true;
    setState(() {});

    Note note = Note(
        noteId: 0,
        title: _titleController.text,
        content: _contentController.text,
        image: null);
    bool result = await note.insertNote(xfile);
    setState(() {
      isLoading = false;
    });
    if (result) {
      NotesProvider.instance.notes.add(note);
      NotesProvider.instance.refreshHomeScreen();
      _titleController.text = '';
      _contentController.text = '';
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'the note was added successfully!',
          ),
        ),
      );
      xfile = null;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('something went wrong when adding the note')));
    }
  }

  void saveButton() async {
    if (_contentController.text != '' || _titleController.text != '') {
      addFunctionality();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill one of the fields to add the note',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (xfile != null) Image.file(File(xfile!.path)),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    controller: _titleController,
                    hintText: 'Enter the title',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    controller: _contentController,
                    hintText: 'Enter the content',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyButton(
                    child: const Text('Add'),
                    onTap: saveButton,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyButton(
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : const Text('Upload Image'),
                    onTap: pickImageMethod,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
