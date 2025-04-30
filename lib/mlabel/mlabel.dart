import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MOrderLabel extends StatelessWidget {
  const MOrderLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.roboto(
          fontSize: 14.0, fontWeight: FontWeight.bold, letterSpacing: 2.0),
    );
  }
}