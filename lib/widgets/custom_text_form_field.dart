import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String? hintText;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int maxLines;
  final TextAlign textAlign;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onTap;

  const CustomTextFormField({
    Key? key,
    required this.label,
    this.hintText,
    this.onSaved,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.onChanged,
    this.controller,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        readOnly: readOnly,
        autofocus: autofocus,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        onSaved: onSaved,
        validator: validator,
        maxLines: maxLines,
        textAlign: textAlign,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        ),
      ),
    );
  }
}
