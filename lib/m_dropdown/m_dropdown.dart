import 'package:flutter/material.dart';
import '../utils/device_helper.dart';
import 'm_dropdown_bottomsheet.dart';
import 'm_dropdown_field.dart';

class MDropdown<T> extends StatelessWidget {
  const MDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    this.isMultiSelect = false,
    this.searchHint = 'Pretraži...',
  });

  final String label;
  final List<T> items;
  final List<T> selectedItems;
  final bool isMultiSelect;
  final String searchHint;
  final Function(List<T>) onChanged;

  @override
  Widget build(BuildContext context) {
    if (DeviceHelpers.isDesktopDeviceOrWeb) {
      return MDropdownField<T>(
        label: label,
        items: items,
        selectedItems: selectedItems,
        isMultiSelect: isMultiSelect,
        searchHint: searchHint,
        onChanged: onChanged,
      );
    } else {
      return MDropdownBottomSheet<T>(
        label: label,
        items: items,
        selectedItems: selectedItems,
        isMultiSelect: isMultiSelect,
        searchHint: searchHint,
        onChanged: onChanged,
      );
    }
  }
}
