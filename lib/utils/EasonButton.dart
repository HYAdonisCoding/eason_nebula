import 'package:flutter/material.dart';

class EasonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final double borderRadius;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final bool enabled;
  final BorderSide? border;

  const EasonButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.color,
    this.textColor,
    this.borderRadius = 8,
    this.fontSize = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.enabled = true,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).primaryColor;
    final effectiveTextColor = textColor ?? Colors.white;
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveColor,
          foregroundColor: effectiveTextColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: border ?? BorderSide.none,
          ),
          textStyle: TextStyle(fontSize: fontSize),
        ),
        child: Text(text),
      ),
    );
  }
}