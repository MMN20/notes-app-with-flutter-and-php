import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.child, required this.onTap});
  final Widget child;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      child: child,
      textColor: Colors.white,
      color: Colors.blue,
    );
  }
}
