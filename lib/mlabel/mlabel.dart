import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MLabel extends StatelessWidget {
  const MLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.ibmPlexSans(
        fontSize: 14.0,
        letterSpacing: 2.0,
        color: Colors.grey.shade800,
      ),
    );
  }
}
