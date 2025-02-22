import 'package:flutter/material.dart';

import '../constants/mcolors.dart';

class MDatePicker extends StatelessWidget {
  const MDatePicker({
    super.key,
    required this.controller,
    required this.onTap,
    required this.validator,
    required this.label,
  });

  final TextEditingController controller;
  final Function onTap;
  final Function(String?) validator;
  final String label;

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
        suffixIcon: Icon(Icons.calendar_today, color: MColors.hintText),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: label,
        labelStyle: TextStyle(fontSize: 16.0, color: MColors.hintText),
      ),
      readOnly: true,
      onTap: onTap(),
    );
  }
}
