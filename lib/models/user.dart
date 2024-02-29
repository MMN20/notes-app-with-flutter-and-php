import 'package:my_note_app_with_php_api/constants/api_links.dart';
import 'package:my_note_app_with_php_api/constants/functions.dart';

class User {
  int id;
  String username;
  String email;
  String password;
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map json) {
    return User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        password: json['password']);
  }

  Map toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password
    };
  }

  static User? currentUser;

  static Future<bool> login(String email, String password) async {
    dynamic response =
        await postRequest(linkLogin, {'email': email, 'password': password});
    if (response != 'error') {
      if (response['status'] == 'success') {
        currentUser = User.fromJson(response['data']);
        return true;
      }
    }
    return false;
  }

  static Future<bool> register(
      {required String username,
      required String email,
      required String password}) async {
    dynamic response = await postRequest(
      linkRegister,
      {
        'email': email,
        'password': password,
        'username': username,
      },
    );

    if (response != 'error') {
      if (response['status'] == 'success') {
        currentUser = User(
          id: int.parse(response['data']),
          username: username,
          email: email,
          password: password,
        );
        return true;
      }
    }
    return false;
  }

  static void logOut() {
    currentUser = null;
  }
}
