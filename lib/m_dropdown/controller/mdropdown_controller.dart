import 'package:flutter/foundation.dart';

enum DropdownType { singleSelect, multipleSelect }

class SingleSelectController<T> extends ValueNotifier<T?> {
  SingleSelectController([super.value]);
  set selected(T? v) => value = v;
  T? get selected => value;
}

class MultiSelectController<T> extends ValueNotifier<List<T>> {
  MultiSelectController([List<T>? value]) : super(value ?? []);
  void select(T item) {
    if (!value.contains(item)) value = [...value, item];
  }

  void unselect(T item) {
    value = value.where((e) => e != item).toList();
  }

  void toggle(T item) {
    if (value.contains(item)) {
      unselect(item);
    } else {
      select(item);
    }
  }

  void setAll(List<T> items) => value = List.from(items);
}
