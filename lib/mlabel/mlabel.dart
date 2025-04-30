import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MLabel extends StatelessWidget {
  const MLabel({super.key, required this.label, this.isBig = false,});

  final String label;
  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.ubuntu(
        fontSize: isBig ? 16.0 : 14.0,
        letterSpacing: 2.0,
        color: isBig ? Colors.black87 : Colors.grey.shade800,
      ),
    );
  }
}
