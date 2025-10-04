import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/mcolors.dart';
import './m_dropdown_decoration.dart';
import 'm_dropdown_item.dart';


class MDropdownField<T> extends StatefulWidget {
  const MDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.selectedItems,
    required this.isMultiSelect,
    required this.searchHint,
    required this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
  });

  final String label;
  final List<T> items;
  final List<T> selectedItems;
  final bool isMultiSelect;
  final String searchHint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(List<T>) onChanged;

  @override
  State<MDropdownField<T>> createState() => _MDropdownFieldState<T>();
}

class _MDropdownFieldState<T> extends State<MDropdownField<T>> {
  late List<T> _filtered;
  late List<T> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedItems);
    _filtered = List.from(widget.items);
  }

  void _openDropdown(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    await showMenu<T>(
      context: context,
      position: position,
      constraints: const BoxConstraints(maxHeight: 500, minWidth: 280),
      items: [
        PopupMenuItem(
          enabled: false,
          child: SizedBox(
            height: 420,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: widget.searchHint,
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  onChanged: (query) => setState(() {
                    _filtered = widget.items
                        .where((e) => e.toString().toLowerCase().contains(query.toLowerCase()))
                        .toList();
                  }),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final item = _filtered[index];
                      final selected = _selected.contains(item);
                      return MDropdownItem<T>(
                        item: item,
                        selected: selected,
                        onTap: () {
                          setState(() {
                            if (widget.isMultiSelect) {
                              selected ? _selected.remove(item) : _selected.add(item);
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
      child: Container(
        padding: MDropdownDecoration.defaultPadding,
        decoration: BoxDecoration(
          color: MDropdownDecoration.defaultFillColor,
          border: MDropdownDecoration.defaultBorder,
          borderRadius: MDropdownDecoration.defaultRadius,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 2,
            )
          ],
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
