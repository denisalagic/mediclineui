import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    this.enabled = false
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
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 4.0,
      ),
      child: TextFormField(
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
          labelStyle: GoogleFonts.ubuntu(
            fontSize: 16.0,
            letterSpacing: 1.1,
            color: MColors.hintText
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
        style: GoogleFonts.ubuntu(
            fontSize: 16.0,
            letterSpacing: 1.1,
        ),
        onTap: onTap,
        minLines: minLines,
        maxLines: maxLines,
        readOnly: enabled!,
      ),
    );
  }
}
