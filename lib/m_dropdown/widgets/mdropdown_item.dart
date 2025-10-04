// lib/widgets/mdropdown/mdropdown_item.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MDropdownItem<T> extends StatelessWidget {
  const MDropdownItem({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
    this.isMulti = false,
  });

  final T item;
  final bool selected;
  final VoidCallback onTap;
  final bool isMulti;

  @override
  Widget build(BuildContext context) {
    /*if (isMulti) {
      return CheckboxListTile(
        dense: true,
        title: Text(
          item.toString(),
          softWrap: true,  // Add this line
          overflow: TextOverflow.visible,
          style: GoogleFonts.ubuntu(fontSize: 15),
        ),
        value: selected,
        onChanged: (_) => onTap(),
      );
    }*/

    return ListTile(
      dense: true,
      title: Text(
        item.toString(),
        style: GoogleFonts.ubuntu(fontSize: 15),
      ),
      trailing: selected ? const Icon(Icons.check_circle, color: Colors.green) : null,
      onTap: onTap,
    );
  }
}
