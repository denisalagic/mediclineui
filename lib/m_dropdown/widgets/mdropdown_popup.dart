
import 'package:flutter/material.dart';

import 'mdropdown_item.dart';

class DropdownPicker {
  // Web/desktop popup
  static Future<void> showPopup<T>({
    required BuildContext context,
    required GlobalKey fieldKey,
    required List<T> items,
    required List<T> initialSelected,
    required bool isMulti,
    required String searchHint,
    required Function(List<T>) onConfirmed,
    double maxHeight = 400,
  }) async {
    final RenderBox renderBox = fieldKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final double width = renderBox.size.width;

    final overlay = Overlay.of(context)!;
    List<T> filtered = List.from(items);
    List<T> selected = List.from(initialSelected);

    OverlayEntry? entry;

    entry = OverlayEntry(
      builder: (_) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => entry?.remove(),
          child: Stack(
            children: [
              Positioned(
                left: position.dx,
                top: position.dy + renderBox.size.height,
                width: width,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return SizedBox(
                        height: maxHeight,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: searchHint,
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onChanged: (q) {
                                  setState(() {
                                    filtered = items
                                        .where((e) => e
                                        .toString()
                                        .toLowerCase()
                                        .contains(q.toLowerCase()))
                                        .toList();
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (_, i) {
                                  final it = filtered[i];
                                  final isSel = selected.contains(it);
                                  return MDropdownItem<T>(
                                    item: it,
                                    selected: isMulti ? selected.contains(it) : isSel,
                                    isMulti: isMulti,
                                    onTap: () {
                                      setState(() {
                                        if (isMulti) {
                                          isSel
                                              ? selected.remove(it)
                                              : selected.add(it);
                                        } else {
                                          selected = [it];
                                          onConfirmed(selected);
                                          entry?.remove();
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                            if (isMulti)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            selected.clear();
                                          });
                                        },
                                        child: const Text('Očisti'),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          onConfirmed(selected);
                                          entry?.remove();
                                        },
                                        child: const Text('Potvrdi'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    overlay.insert(entry);
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
