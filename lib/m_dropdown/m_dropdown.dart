import 'package:flutter/material.dart';

import '../utils/device_helper.dart';
import 'm_dropdown_bottomsheet.dart';
import 'm_dropdown_field.dart';


class MDropdown2<T> extends StatelessWidget {
  const MDropdown2({
    super.key,
    required this.label,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    this.isMultiSelect = false,
    this.prefixIcon,
    this.suffixIcon,
    this.searchHint = 'Pretraži...',
  });

  final String label;
  final List<T> items;
  final List<T> selectedItems;
  final bool isMultiSelect;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String searchHint;
  final Function(List<T>) onChanged;

  @override
  Widget build(BuildContext context) {
    return DeviceHelpers.isDesktopDeviceOrWeb
        ? MDropdownField<T>(
      label: label,
      items: items,
      selectedItems: selectedItems,
      isMultiSelect: isMultiSelect,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      searchHint: searchHint,
      onChanged: onChanged,
    )
        : MDropdownBottomSheet<T>(
      label: label,
      items: items,
      selectedItems: selectedItems,
      isMultiSelect: isMultiSelect,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      searchHint: searchHint,
      onChanged: onChanged,
    );
  }
}
