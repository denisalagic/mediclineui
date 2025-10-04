
import 'package:flutter/material.dart';

import 'mdropdown_item.dart';

class DropdownPicker {
  // Web/desktop popup
  static Future<void> showPopup<T>({
    required BuildContext context,
    required Offset position,
    required List<T> items,
    required List<T> initialSelected,
    required bool isMulti,
    required String searchHint,
    required Function(List<T>) onConfirmed,
    double maxHeight = 400,
    double width = 320,
  }) async {
    List<T> filtered = List.from(items);
    List<T> selected = List.from(initialSelected);

    final overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final posRect = Rect.fromPoints(position, position);

    await showMenu<T>(
      context: context,
      position: RelativeRect.fromRect(posRect, Offset.zero & overlay.size),
      constraints: BoxConstraints(maxHeight: maxHeight, minWidth: width),
      items: [
        PopupMenuItem(
          enabled: false,
          child: SizedBox(
            height: maxHeight,
            width: width,
            child: StatefulBuilder(builder: (context, setState) {
              return Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: searchHint,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (q) {
                      setState(() {
                        filtered = items
                            .where((e) => e.toString().toLowerCase().contains(q.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true, // important
                      physics: const ClampingScrollPhysics(),
                      itemCount: filtered.length,
                      itemBuilder: (c, i) {
                        final it = filtered[i];
                        final isSel = selected.contains(it);

                        return MDropdownItem<T>(
                          item: it,
                          selected: isMulti ? selected.contains(it) : isSel,
                          onTap: () {
                            setState(() {
                              if (isMulti) {
                                isSel ? selected.remove(it) : selected.add(it);
                              } else {
                                selected = [it];
                                onConfirmed(selected);
                                Navigator.pop(context);
                              }
                            });
                          },
                          isMulti: isMulti,
                        );
                      },

                    ),
                  ),
                  if (isMulti)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                selected.clear();
                                setState(() {});
                              },
                              child: const Text('Očisti'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                onConfirmed(selected);
                                Navigator.pop(context);
                              },
                              child: const Text('Potvrdi'),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }),
          ),
        )
      ],
    );
  }

  // Mobile bottom sheet
  static Future<void> showBottomSheet<T>({
    required BuildContext context,
    required List<T> items,
    required List<T> initialSelected,
    required bool isMulti,
    required String searchHint,
    required Function(List<T>) onConfirmed,
  }) async {
    List<T> filtered = List.from(items);
    List<T> selected = List.from(initialSelected);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.3,
          maxChildSize: 0.95,
          builder: (context, ctrl) => StatefulBuilder(
            builder: (context, setState) => Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: searchHint,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (q) => setState(() {
                      filtered = items
                          .where((e) => e.toString().toLowerCase().contains(q.toLowerCase()))
                          .toList();
                    }),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      controller: ctrl,
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final it = filtered[i];
                        final isSel = selected.contains(it);
                        return MDropdownItem<T>(
                          item: it,
                          selected: isSel,
                          onTap: () {
                            setState(() {
                              if (isMulti) {
                                isSel ? selected.remove(it) : selected.add(it);
                              } else {
                                selected = [it];
                                onConfirmed(selected);
                                Navigator.pop(context);
                              }
                            });
                          },
                          isMulti: isMulti,
                        );
                      },
                    ),
                  ),
                  if (isMulti)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                selected.clear();
                                // update UI via setState closure
                                (ctx as dynamic).setState?.call(() {});
                              },
                              child: const Text('Očisti'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                onConfirmed(selected);
                                Navigator.pop(context);
                              },
                              child: const Text('Potvrdi'),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
