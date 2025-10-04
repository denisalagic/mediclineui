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
    required double width,
    double maxHeight = 400,
  }) async {
    List<T> filtered = List.from(items);
    List<T> selected = List.from(initialSelected);

    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Stack(
          children: [
            Positioned(
              left: position.dx,
              top: position.dy,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: width,
                  height: maxHeight,
                  padding: const EdgeInsets.all(8.0),
                  child: StatefulBuilder(
                    builder: (context, setState) => Column(
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
                                  .where((e) => e
                                  .toString()
                                  .toLowerCase()
                                  .contains(q.toLowerCase()))
                                  .toList();
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
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
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
    );
  }


  // Mobile bottom sheet remains unchanged
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
          builder:
              (context, ctrl) => StatefulBuilder(
                builder:
                    (context, setState) => Padding(
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
                            onChanged:
                                (q) => setState(() {
                                  filtered =
                                      items
                                          .where(
                                            (e) => e
                                                .toString()
                                                .toLowerCase()
                                                .contains(q.toLowerCase()),
                                          )
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
                                        isSel
                                            ? selected.remove(it)
                                            : selected.add(it);
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
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        selected.clear();
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
