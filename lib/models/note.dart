// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_note_app_with_php_api/constants/api_links.dart';
import 'package:my_note_app_with_php_api/constants/functions.dart';
import 'package:my_note_app_with_php_api/models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class Note {
  int noteId;
  String title;
  String content;
  String? image;

  Note({
    required this.noteId,
    required this.title,
    required this.content,
    required this.image,
  });

  Future<bool> insertNote(XFile? imageFile) async {
    Map body = {
      'title': title,
      'content': content,
      'userId': User.currentUser!.id.toString(),
    };
    // in case we don't send the image
    if (imageFile == null) {
      dynamic response = await postRequest(
        linkAddNote,
        body,
      );

      if (response != 'error') {
        if (response['status'] == 'success') {
          noteId = int.parse(response['data']);
          return true;
        }
      }
      return false;
    } else {
      // in case we have the image in the file
      String fileName = '${Uuid().v1()}${path.basename(imageFile.path)}';
      dynamic response = await postRequestWithFile(
          linkAddNote, body, File(imageFile.path), fileName);
      if (response != 'error') {
        if (response['status'] == 'success') {
          image = fileName;
          noteId = int.parse(response['data']);
          return true;
        }
      }
      return false;
    }
  }

  Future<bool> update(XFile? file) async {
    Map body = {
      'title': title,
      'content': content,
      'noteId': noteId.toString(),
    };

    if (file != null) {
      String newImageName = '${Uuid().v1()}${path.basename(file.path)}';
      dynamic response = await postRequestWithFile(
          linkEditNote, body, File(file.path), newImageName);
      if (response != 'error') {
        if (response['status'] == 'success') {
          image = newImageName;
          return true;
        }
      }
    }

    dynamic response = await postRequest(linkEditNote, body);
    if (response != 'error') {
      if (response['status'] == 'success') {
        return true;
      }
    }
    return false;
  }

  factory Note.fromJson(Map json) {
    return Note(
      noteId: json['noteId'],
      title: json['title'],
      content: json['content'],
      image: json['image'],
    );
  }

  Future<bool> delete() async {
    Map body = {'noteId': noteId.toString()};
    dynamic response = await postRequest(linkDeleteNote, body);
    if (response != 'error') {
      if (response['status'] == 'success') {
        return true;
      }
    }
    return false;
  }

  static Future<List<Note>> getAllNotes() async {
    List<Note> notes = [];
    dynamic response = await postRequest(
        linkViewNote, {'userId': User.currentUser!.id.toString()});
    if (response != 'error') {
      if (response['status'] == 'success') {
        for (Map note in response['data']) {
          notes.add(Note.fromJson(note));
        }
      }
    }
    return notes;
  }
}
