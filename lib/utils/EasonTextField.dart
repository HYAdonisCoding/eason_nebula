import 'package:flutter/material.dart';

class EasonTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final int maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final int? maxLines;

  const EasonTextField({
    Key? key,
    required this.label,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLength = 50,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLength: maxLength,
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText ?? '请输入$label',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          counterText: '',
        ),
        onChanged: onChanged,
      ),
    );
  }
}
