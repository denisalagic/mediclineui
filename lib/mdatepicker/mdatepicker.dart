import 'package:flutter/material.dart';

import '../constants/mcolors.dart';

class MDatePicker extends StatelessWidget {
  const MDatePicker({
    super.key,
    required this.controller,
    required this.onTap,
    required this.validator,
    required this.label,
    this.enabled,
  });

  final TextEditingController controller;
  final GestureTapCallback? onTap;
  final Function(String?) validator;
  final String label;
  final bool? enabled;

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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        suffixIcon: Icon(Icons.calendar_today, color: MColors.hintText),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: label,
        labelStyle: TextStyle(fontSize: 16.0, color: MColors.hintText, letterSpacing: 1.1),
      ),
      readOnly: true,
      onTap: onTap,
      enabled: enabled,
    );
  }
}
