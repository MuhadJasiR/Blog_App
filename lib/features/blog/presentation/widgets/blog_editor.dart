import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  const BlogEditor(
      {super.key, required this.controller, required this.hintText});

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: null,
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is empty!..";
        }
        return null;
      },
    );
  }
}
