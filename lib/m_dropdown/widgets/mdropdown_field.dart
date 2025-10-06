// lib/widgets/mdropdown/mdropdown_field.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/mcolors.dart';
import '../controller/mdropdown_controller.dart';
import '../decoration/mdropdown_decoration.dart';

class DropDownField<T> extends StatefulWidget {
  final VoidCallback onTap;
  final SingleSelectController<T?> selectedItemNotifier;
  final MultiSelectController<T> selectedItemsNotifier;
  final String hintText;
  final Widget? prefixIcon, suffixIcon;
  final int maxLines;
  final bool enabled;
  final DropdownType dropdownType;
  final bool hasError;

  const DropDownField({
    super.key,
    required this.onTap,
    required this.selectedItemNotifier,
    required this.selectedItemsNotifier,
    required this.dropdownType,
    this.hintText = 'Select value',
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.enabled = true,
    this.hasError = false,
  });

  @override
  State<DropDownField<T>> createState() => _DropDownFieldState<T>();
}

class _DropDownFieldState<T> extends State<DropDownField<T>> {
  T? selectedItem;
  late List<T> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItemNotifier.value;
    selectedItems = widget.selectedItemsNotifier.value;
    widget.selectedItemNotifier.addListener(_ctrlChanged);
    widget.selectedItemsNotifier.addListener(_ctrlChanged);
  }

  @override
  void dispose() {
    widget.selectedItemNotifier.removeListener(_ctrlChanged);
    widget.selectedItemsNotifier.removeListener(_ctrlChanged);
    super.dispose();
  }

  void _ctrlChanged() {
    setState(() {
      selectedItem = widget.selectedItemNotifier.value;
      selectedItems = widget.selectedItemsNotifier.value;
    });
  }

  Widget _defaultHintBuilder() {
    return Text(
      widget.hintText,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.ubuntu(
        fontSize: 16,
        letterSpacing: 1.1,
        fontWeight: FontWeight.w500,
        color: MDropdownDecoration.hintTextColor,
      ),
    );
  }

  Widget _defaultHeaderBuilder() {
    if (widget.dropdownType == DropdownType.singleSelect) {
      return Text(
        selectedItem?.toString() ?? widget.hintText,
        maxLines: widget.maxLines,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.ubuntu(
          fontSize: 16,
          letterSpacing: 1.1,
          fontWeight: FontWeight.w500,
          color:
              selectedItem == null
                  ? MDropdownDecoration.hintTextColor
                  : Colors.black,
        ),
      );
    } else {
      if (selectedItems.isEmpty) return _defaultHintBuilder();
      return Wrap(
        spacing: 6,
        runSpacing: 6,
        children:
            selectedItems
                .map(
                  (e) => InputChip(
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    backgroundColor: MColors.primaryGreen,
                    label: Text(
                      e.toString(),
                      style: GoogleFonts.ubuntu(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    deleteIconColor: Colors.white,
                    onDeleted: () {
                      widget.selectedItemsNotifier.unselect(e);
                    },
                  ),
                )
                .toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enabled ? widget.onTap : null,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: MDropdownDecoration.defaultHeight,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: MDropdownDecoration.fillColor,
          borderRadius: MDropdownDecoration.borderRadius,
          border: Border.all(
            color: widget.hasError ? Colors.red : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            if (widget.prefixIcon != null) ...[
              widget.prefixIcon!,
              const SizedBox(width: 12),
            ],
            Expanded(child: _defaultHeaderBuilder()),
            const SizedBox(width: 12),
            widget.suffixIcon ?? MDropdownDecoration.overlayIcon,
          ],
        ),
      ),
    );
  }
}
