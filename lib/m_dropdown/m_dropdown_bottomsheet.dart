import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/mcolors.dart';
import 'm_dropdown_decoration.dart';
import 'm_dropdown_item.dart';

class MDropdownBottomSheet<T> extends StatefulWidget {
  const MDropdownBottomSheet({
    super.key,
    required this.label,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    required this.isMultiSelect,
    required this.searchHint,
    this.prefixIcon,
    this.suffixIcon,
  });

  final String label;
  final List<T> items;
  final List<T> selectedItems;
  final bool isMultiSelect;
  final String searchHint;
  final Function(List<T>) onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  State<MDropdownBottomSheet<T>> createState() => _MDropdownBottomSheetState<T>();
}

class _MDropdownBottomSheetState<T> extends State<MDropdownBottomSheet<T>> {
  late List<T> _filtered;
  late List<T> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedItems);
    _filtered = List.from(widget.items);
  }

  void _openBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (_, setModalState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (q) => setModalState(() {
                  _filtered = widget.items
                      .where((e) => e.toString().toLowerCase().contains(q.toLowerCase()))
                      .toList();
                }),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: _filtered.length,
                  itemBuilder: (_, i) {
                    final item = _filtered[i];
                    final selected = _selected.contains(item);
                    return MDropdownItem<T>(
                      item: item,
                      selected: selected,
                      onTap: () => setModalState(() {
                        if (widget.isMultiSelect) {
                          selected ? _selected.remove(item) : _selected.add(item);
                        } else {
                          _selected = [item];
                        }
                      }),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onChanged(_selected);
                  Navigator.pop(context);
                },
                child: const Text('Potvrdi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _selected.isEmpty
        ? widget.label
        : _selected.map((e) => e.toString()).join(', ');

    return GestureDetector(
      onTap: _openBottomSheet,
      child: Container(
        padding: MDropdownDecoration.defaultPadding,
        decoration: BoxDecoration(
          color: MDropdownDecoration.defaultFillColor,
          border: MDropdownDecoration.defaultBorder,
          borderRadius: MDropdownDecoration.defaultRadius,
        ),
        child: Row(
          children: [
            if (widget.prefixIcon != null) ...[
              widget.prefixIcon!,
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                displayText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.ubuntu(
                  fontSize: 16,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w500,
                  color: _selected.isEmpty ? MColors.hintText : Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 8),
            widget.suffixIcon ?? MDropdownDecoration.defaultIcon,
          ],
        ),
      ),
    );
  }
}