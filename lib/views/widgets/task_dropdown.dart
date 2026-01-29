import 'package:flutter/material.dart';

class TaskDropdown<T> extends StatelessWidget {
  final T? value;
  final String? hint;
  final List<T> items;
  final List<String>? itemLabels;
  final ValueChanged<T?> onChanged;

  const TaskDropdown({
    super.key,
    this.value,
    this.itemLabels,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        isExpanded: true,
        value: value,
        hint: hint != null
            ? Text(hint!, style: TextStyle(color: Colors.grey.shade600))
            : null,
        icon: const Icon(Icons.keyboard_arrow_down),
        items: List.generate(items.length, (index) {
          final item = items[index];
          final displayText = itemLabels != null && index < itemLabels!.length
              ? itemLabels![index]
              : item.toString();

          return DropdownMenuItem(value: item, child: Text(displayText));
        }),
        onChanged: onChanged,
      ),
    );
  }
}
