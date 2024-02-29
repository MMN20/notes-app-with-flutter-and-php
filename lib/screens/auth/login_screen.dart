import 'package:flutter/material.dart';
import 'package:my_note_app_with_php_api/constants/functions.dart';
import 'package:my_note_app_with_php_api/main.dart';
import 'package:my_note_app_with_php_api/models/user.dart';
import 'package:my_note_app_with_php_api/screens/auth/register_screen.dart';
import 'package:my_note_app_with_php_api/screens/home.dart';
import 'package:my_note_app_with_php_api/widgets/my_button.dart';
import 'package:my_note_app_with_php_api/widgets/my_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;

  void login() async {
    if (formState.currentState!.validate()) {
      bool result =
          await User.login(_emailController.text, _passwordController.text);
      if (result) {
        await saveCurrentUserInSharedPrefs();
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (c) => const MyApp()), (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'The email or the password is wrong',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formState,
              child: Column(
                children: [
                  MyTextField(
                    controller: _emailController,
                    hintText: 'Enter the email',
                    validator: validator,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  MyTextField(
                    controller: _passwordController,
                    hintText: 'Enter the password',
                    validator: validator,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyButton(
                    onTap: login,
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Login'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: Text('Register'),
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
