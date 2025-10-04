// lib/widgets/mdropdown/mdropdown_decoration.dart
import 'package:flutter/material.dart';

class MDropdownDecoration {
  static const fillColor = Colors.white;
  static const hintTextColor = Color(0xFFA7A7A7);
  static final borderRadius = BorderRadius.circular(8.0);
  static final border = Border.all(color: Color(0xFFE0E0E0), width: 1.0);
  static const defaultPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 12);
  static const defaultHeight = 52.0;
  static const overlayIcon = Icon(
    Icons.keyboard_arrow_down_rounded,
    size: 20,
  );
}
