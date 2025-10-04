import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/mcolors.dart';
import 'm_dropdown_item.dart';

class MDropdownField<T> extends StatefulWidget {
  const MDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    required this.isMultiSelect,
    required this.searchHint,
  });

  final String label;
  final List<T> items;
  final List<T> selectedItems;
  final Function(List<T>) onChanged;
  final bool isMultiSelect;
  final String searchHint;

  @override
  State<MDropdownField<T>> createState() => _MDropdownFieldState<T>();
}

class _MDropdownFieldState<T> extends State<MDropdownField<T>> {
  late List<T> _filteredItems;
  late List<T> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List<T>.from(widget.selectedItems);
    _filteredItems = List<T>.from(widget.items);
  }

  void _openDropdown(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    await showMenu<T>(
      context: context,
      position: position,
      constraints: const BoxConstraints(maxHeight: 500, maxWidth: 300),
      items: [
        PopupMenuItem(
          enabled: false,
          child: SizedBox(
            height: 400,
            width: 280,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: widget.searchHint,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (query) {
                    setState(() {
                      _filteredItems = widget.items
                          .where((e) =>
                          e.toString().toLowerCase().contains(query.toLowerCase()))
                          .toList();
                    });
                  },
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final selected = _selected.contains(item);
                      return MDropdownItem<T>(
                        item: item,
                        selected: selected,
                        onTap: () {
                          setState(() {
                            if (widget.isMultiSelect) {
                              selected
                                  ? _selected.remove(item)
                                  : _selected.add(item);
                            } else {
                              _selected = [item];
                            }
                          });
                          widget.onChanged(_selected);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _selected.isEmpty
        ? widget.label
        : _selected.map((e) => e.toString()).join(', ');

    return GestureDetector(
      onTap: () => _openDropdown(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        child: Text(
          displayText,
          style: GoogleFonts.ubuntu(
            fontSize: 16,
            color:
            _selected.isEmpty ? MColors.hintText : Colors.black87,
          ),
        ),
      ),
    );
  }
}

