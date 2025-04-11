import 'package:flutter/material.dart';

class CustomTextArea extends StatelessWidget {
  final String label;
  final Function(String?)? onSaved; // cho phép null
  final String? Function(String?)? validator;
  final String? initialValue;
  final bool enabled;

  const CustomTextArea({
    Key? key,
    required this.label,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.enabled = true, // mặc định là true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        initialValue: initialValue,
        maxLines: 4,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          alignLabelWithHint: true,
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}
