import 'package:flutter/material.dart';

class MDropdownItem<T> extends StatelessWidget {
  const MDropdownItem({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final T item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.toString()),
      trailing: selected
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.circle_outlined),
      onTap: onTap,
    );
  }
}
