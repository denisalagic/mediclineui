import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/device_helper.dart';
import 'controller/mdropdown_controller.dart';
import 'widgets/mdropdown_field.dart';
import 'widgets/mdropdown_popup.dart';

class MDropdown2<T> extends StatefulWidget {
  const MDropdown2({
    super.key,
    required this.items,
    this.initialSelected,
    this.isMultiSelect = false,
    this.hintText = 'Select value',
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
  });

  final List<T> items;
  final List<T>? initialSelected;
  final bool isMultiSelect;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(List<T>)? onChanged;
  final String? Function(List<T>?)? validator;

  @override
  State<MDropdown2<T>> createState() => _MDropdownState<T>();
}

class _MDropdownState<T> extends State<MDropdown2<T>> {
  final GlobalKey _fieldKey = GlobalKey();
  late SingleSelectController<T?> singleCtrl;
  late MultiSelectController<T> multiCtrl;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    singleCtrl = SingleSelectController<T?>(
      widget.initialSelected?.isNotEmpty == true
          ? widget.initialSelected!.first
          : null,
    );
    multiCtrl = MultiSelectController<T>(widget.initialSelected ?? []);
  }

  @override
  void didUpdateWidget(covariant MDropdown2<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelected != null) {
      if (widget.isMultiSelect) {
        multiCtrl.setAll(widget.initialSelected!);
      } else {
        singleCtrl.selected =
            widget.initialSelected!.isNotEmpty
                ? widget.initialSelected!.first
                : null;
      }
    }
  }

  void _onConfirmed(List<T> selected) {
    if (widget.isMultiSelect) {
      multiCtrl.setAll(selected);
    } else {
      singleCtrl.selected = selected.isNotEmpty ? selected.first : null;
    }
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(selected.isEmpty ? null : selected);
      });
    }
    widget.onChanged?.call(selected);
  }

  Future<void> _openPicker(BuildContext context) async {
    if (DeviceHelpers.isDesktopDeviceOrWeb) {
      // Measure the field's size
      final renderBox =
          _fieldKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final size = renderBox.size;
      final position = renderBox.localToGlobal(Offset.zero);

      await DropdownPicker.showPopup<T>(
        context: context,
        items: widget.items,
        initialSelected:
            widget.isMultiSelect
                ? multiCtrl.value
                : (singleCtrl.value != null ? [singleCtrl.value as T] : []),
        isMulti: widget.isMultiSelect,
        searchHint: widget.hintText,
        onConfirmed: _onConfirmed,
        width: size.width,
        // auto match field width
        position: position,
      );
    } else {
      await DropdownPicker.showBottomSheet<T>(
        context: context,
        items: widget.items,
        initialSelected:
            widget.isMultiSelect
                ? multiCtrl.value
                : (singleCtrl.value != null ? [singleCtrl.value as T] : []),
        isMulti: widget.isMultiSelect,
        searchHint: widget.hintText,
        onConfirmed: _onConfirmed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropDownField<T>(
            key: _fieldKey,
            onTap: () => _openPicker(context),
            selectedItemNotifier: singleCtrl,
            selectedItemsNotifier: multiCtrl,
            dropdownType:
                widget.isMultiSelect
                    ? DropdownType.multipleSelect
                    : DropdownType.singleSelect,
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            maxLines: 1,
          ),
          if (_errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 12.0),
              child: Text(
                _errorText!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
