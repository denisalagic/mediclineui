import 'package:flutter/material.dart';

import '../constants/mcolors.dart';

class MCard extends StatelessWidget {
  const MCard({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      margin: const EdgeInsets.all(0),
      elevation: 0,
      color: MColors.background,
      child: child,
    );
  }
}
