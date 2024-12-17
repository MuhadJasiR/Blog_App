import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  const AuthField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.obscure = false});

  final String hintText;
  final TextEditingController controller;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is missing!";
        }

        null;
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
      ),
      obscureText: obscure,
    );
  }
}
