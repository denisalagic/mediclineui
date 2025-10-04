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
    return ListTile(
      dense: true,
      tileColor: Colors.red,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
      onTap: onTap,
      title: Row(
        children: [
          Expanded(
            child: Text(
              item.toString(),
              softWrap: true,
              overflow: TextOverflow.visible,
              style: GoogleFonts.ubuntu(fontSize: 15),
            ),
          ),
        ],
      ),
      trailing: isMulti
          ? Checkbox(
        value: selected,
        onChanged: (_) => onTap(),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      )
          : (selected
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null),
    );
  }
}
