import 'package:flutter/material.dart';

import '../constants/mcolors.dart';

class MTextField extends StatelessWidget {
  const MTextField({
    super.key,
    required this.controller,
    this.onTap,
    this.validator,
    required this.label,
    this.minLines,
    this.maxLines,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled
  });

  final TextEditingController controller;
  final GestureTapCallback? onTap;
  final Function(String?)? validator;
  final String label;
  final int? minLines;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (val) {
        return validator != null ? validator!(val) : null;
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
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: label,
        labelStyle: TextStyle(fontSize: 16.0, color: MColors.hintText, letterSpacing: 1.1),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      onTap: onTap,
      minLines: minLines,
      maxLines: maxLines,
      enabled: enabled,
    );
  }
}
