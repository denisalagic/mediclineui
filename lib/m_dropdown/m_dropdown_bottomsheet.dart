import 'package:flutter/material.dart';
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
  });

  final String label;
  final List<T> items;
  final List<T> selectedItems;
  final Function(List<T>) onChanged;
  final bool isMultiSelect;
  final String searchHint;

  @override
  State<MDropdownBottomSheet<T>> createState() =>
      _MDropdownBottomSheetState<T>();
}

class _MDropdownBottomSheetState<T> extends State<MDropdownBottomSheet<T>> {
  late List<T> _filteredItems;
  late List<T> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List<T>.from(widget.selectedItems);
    _filteredItems = List<T>.from(widget.items);
  }

  void _openBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          builder: (_, controller) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: widget.searchHint,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (query) {
                      setState(() {
                        _filteredItems = widget.items
                            .where((e) => e
                            .toString()
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
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
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onChanged(_selected);
                      Navigator.pop(context);
                    },
                    child: const Text('Potvrdi'),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _selected.isEmpty
        ? widget.label
        : _selected.map((e) => e.toString()).join(', ');

    return GestureDetector(
      onTap: _openBottomSheet,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
        ),
        child: Text(displayText),
      ),
    );
  }
}
