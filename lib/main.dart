import 'package:flutter/material.dart';
import 'package:my_note_app_with_php_api/constants/functions.dart';
import 'package:my_note_app_with_php_api/providers/notes_provider.dart';
import 'package:my_note_app_with_php_api/screens/auth/login_screen.dart';
import 'package:my_note_app_with_php_api/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  if (sharedPref.getInt('id') != null) {
    setCurrentUserUsingSharedPrefs();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
      ),
      home: sharedPref.getInt('id') == null
          ? const LoginScreen()
          : ChangeNotifierProvider(
              create: (c) => NotesProvider(),
              child: const HomeScreen(),
            ),
    );
  }
}
