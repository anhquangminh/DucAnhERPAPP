import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  final String label;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;

  const CustomDatePicker({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime _firstDate = firstDate ?? DateTime(2000);
    final DateTime _lastDate = lastDate ?? DateTime(2101);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: !enabled
            ? null
            : () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: _firstDate,
                  lastDate: _lastDate,
                );
                if (picked != null && picked != selectedDate) {
                  onDateSelected(picked);
                }
              },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabled: enabled,
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          child: Text(
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
