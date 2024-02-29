import 'package:flutter/material.dart';
import 'package:my_note_app_with_php_api/constants/functions.dart';
import 'package:my_note_app_with_php_api/main.dart';
import 'package:my_note_app_with_php_api/models/user.dart';
import 'package:my_note_app_with_php_api/screens/home.dart';
import 'package:my_note_app_with_php_api/widgets/my_button.dart';
import 'package:my_note_app_with_php_api/widgets/my_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;

  void register() async {
    if (formState.currentState!.validate()) {
      bool result = await User.register(
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text);
      if (result) {
        await saveCurrentUserInSharedPrefs();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (c) => const MyApp(),
          ),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'something wrong',
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
        title: const Text("Register"),
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
                    controller: _usernameController,
                    hintText: 'Enter the username',
                    validator: validator,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
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
                    onTap: register,
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Register'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
