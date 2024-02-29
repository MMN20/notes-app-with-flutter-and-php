import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_note_app_with_php_api/constants/api_links.dart';
import 'package:my_note_app_with_php_api/models/note.dart';
import 'package:my_note_app_with_php_api/providers/notes_provider.dart';
import 'package:my_note_app_with_php_api/widgets/my_button.dart';
import 'package:my_note_app_with_php_api/widgets/my_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({super.key, required this.note});
  final Note note;
  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late String initTitle;
  late String initContent;
  XFile? xfile;
  bool isLoading = false;
  void initControllers() {
    _titleController.text = widget.note.title;
    initTitle = widget.note.title;
    _contentController.text = widget.note.content;
    initContent = widget.note.content;
  }

  @override
  void initState() {
    super.initState();
    initControllers();
  }

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
    xfile = await ImagePicker().pickImage(source: source);
    Navigator.pop(context);
    if (xfile != null) {
      setState(() {});
    }
  }

  void updateFunctionality() async {
    String oldContent = widget.note.content;
    String oldTitle = widget.note.title;
    widget.note.content = _contentController.text;
    widget.note.title = _titleController.text;
    bool result;
    isLoading = true;
    setState(() {});

    if (xfile != null) {
      result = await widget.note.update(xfile);
    } else {
      result = await widget.note.update(null);
    }

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'The note was updated successfully',
          ),
        ),
      );
      widget.note.content = _contentController.text;
      widget.note.title = _titleController.text;
      setState(() {});

      NotesProvider.instance.refreshHomeScreen();
    } else {
      if (widget.note.content != oldContent && widget.note.title != oldTitle) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'failed to update the note',
            ),
          ),
        );
        widget.note.content = oldContent;
        widget.note.title = oldTitle;
      }
    }
    isLoading = false;
    setState(() {});
  }

  void saveButton() async {
    updateFunctionality();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                (xfile != null)
                    ? Image.file(File(xfile!.path))
                    : (widget.note.image != null)
                        ? Image.network(
                            '${linkImageRoot}/${widget.note.image!}')
                        : Container(),
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
                  onTap: saveButton,
                  child: isLoading
                      ? CircularProgressIndicator()
                      : const Text(
                          'edit',
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MyButton(
                  onTap: pickImageMethod,
                  child: Text(
                    widget.note.image == null ? 'Upload Image' : 'Change Image',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
