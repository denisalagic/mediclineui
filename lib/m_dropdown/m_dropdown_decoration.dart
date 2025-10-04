import 'package:flutter/material.dart';

class MDropdownDecoration {
  static const _defaultBorderColor = Color(0xFFE0E0E0);
  static const defaultFillColor = Colors.white;

  static const defaultBorder = Border.fromBorderSide(
    BorderSide(
      color: _defaultBorderColor,
      width: 1.2,
    ),
  );

  static const defaultRadius = BorderRadius.all(Radius.circular(8));
  static const defaultPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  static const defaultIcon = Icon(
    Icons.keyboard_arrow_down_rounded,
    size: 20,
  );
}
