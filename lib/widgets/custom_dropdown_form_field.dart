import 'package:flutter/material.dart';

class CustomDropdownFormField<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final String selectedId;
  final String Function(T) getId;
  final String Function(T) getLabel;
  final void Function(T?) onChanged;

  const CustomDropdownFormField({
    super.key,
    required this.label,
    required this.items,
    required this.selectedId,
    required this.getId,
    required this.getLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Thêm item mặc định rỗng vào danh sách
    final itemsWithEmpty = [
      null,
      ...items,
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<T?>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        value: itemsWithEmpty.firstWhere(
          (item) {
            if (item == null) return selectedId.isEmpty;
            return getId(item) == selectedId;
          },
          orElse: () => null,
        ),
        items: itemsWithEmpty.map((item) {
          if (item == null) {
            return DropdownMenuItem<T?>(
              value: null,
              child: Text("-- Chọn --"),
            );
          }
          return DropdownMenuItem<T?>(
            value: item,
            child: Text(getLabel(item)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
