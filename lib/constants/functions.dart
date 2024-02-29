import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:my_note_app_with_php_api/main.dart';
import 'package:my_note_app_with_php_api/models/user.dart';

Future<dynamic> postRequest(String url, Map body) async {
  try {
    Response response = await http.post(Uri.parse(url), body: body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  } catch (e) {
    print(e.toString());
  }
  return 'error';
}

String? validator(String? val) {
  if (val == '' || val == null) {
    return 'Please fill the text field';
  }
}


postRequestWithFile(String url, Map data, File file, String fileName) async {
  await Future.delayed(Duration(seconds: 2));
  MultipartRequest  request = http.MultipartRequest("POST", Uri.parse(url));

  int  length = await file.length();
  ByteStream  stream = http.ByteStream(file.openRead());
  MultipartFile  multiPartFile =
      http.MultipartFile('file', stream, length, filename: fileName);

  request.files.add(multiPartFile);
  data.forEach((key, value) {
    request.fields[key] = value;
  });

  StreamedResponse  myRequest = await request.send();
  Response  response = await http.Response.fromStream(myRequest);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }
  return 'error';
}

Future<void> saveCurrentUserInSharedPrefs() async {
  await sharedPref.setInt('id', User.currentUser!.id);
  await sharedPref.setString('username', User.currentUser!.username);
  await sharedPref.setString('email', User.currentUser!.email);
}

void setCurrentUserUsingSharedPrefs() {
  int id = sharedPref.getInt('id')!;
  String username = sharedPref.getString('username')!;
  String email = sharedPref.getString('email')!;
  User.currentUser =
      User(id: id, username: username, email: email, password: '0');
}

Future<void> deleteCurrentUserFromSharedPrefs() async {
  sharedPref.clear();
}
