import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String text)? onChanged;

  const TextFormFieldWidget({
    super.key,
    required this.controller,
    required this.hintText, this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: hintText,
        hintText: hintText,
        filled: true,
        fillColor: Colors.white
      ),
    );
  }
}
