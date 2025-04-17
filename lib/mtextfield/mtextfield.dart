import 'package:flutter/material.dart';

import '../constants/mcolors.dart';

class MTextField extends StatelessWidget {
  const MTextField({
    super.key,
    required this.controller,
    required this.onTap,
    required this.validator,
    required this.label,
    this.minLines,
    this.maxLines,
  });

  final TextEditingController controller;
  final GestureTapCallback? onTap;
  final Function(String?) validator;
  final String label;
  final int? minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (val) {
        return validator(val);
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(width: 0, style: BorderStyle.none),
        ),
        hoverColor: Colors.white,
        focusColor: Colors.white,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: label,
        labelStyle: TextStyle(fontSize: 16.0, color: MColors.hintText, letterSpacing: 1.1),
      ),
      onTap: onTap,
      minLines: minLines,
      maxLines: maxLines,
    );
  }
}
